import Foundation

// MARK: - Method

public extension Method {
    /// A Boolean value determining whether the request supports multipart.
    var supportsMultipart: Bool {
        switch self {
        case .post, .put, .patch, .connect:
            return true
        default:
            return false
        }
    }
}

// MARK: - NetworkLayerManager

/// Internal extension to keep the inner-workings outside the main swift file.
public extension NetworkLayerManager {
    /// Performs normal requests.
    func requestNormal(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable {
        let endpoint = self.endpoint(target)
        self.endpointEntity = endpoint
        let stubBehavior = self.stubClosure(target)
        let cancellableToken = CancellableWrapper()

        let performNetworking = { (requestResult: Result<URLRequest, NetworkLayerError>) in
            if cancellableToken.isCancelled {
                self.cancelCompletion(completion, target: target)
                return
            }

            var request: URLRequest!

            switch requestResult {
            case .success(let urlRequest):
                request = urlRequest
            case .failure(let error):
                completion(.failure(error))
                return
            }
            
            cancellableToken.innerCancellable = self.performRequest(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion, endpoint: endpoint, stubBehavior: stubBehavior)
        }

        requestClosure(endpoint, performNetworking)

        return cancellableToken
    }

    // swiftlint:disable:next function_parameter_count
    private func performRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion, endpoint: Endpoint, stubBehavior: StubBehavior) -> Cancellable {
        switch stubBehavior {
        case .never:
            switch endpoint.task {
            case .requestPlain, .requestData, .requestJSONEncodable, .requestCustomJSONEncodable, .requestParameters, .requestParametersWithTargetEncoding, .requestCompositeData, .requestCompositeParameters:
                return self.sendRequest(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
            case .uploadFile(let file):
                return self.sendUploadFile(target, request: request, callbackQueue: callbackQueue, file: file, progress: progress, completion: completion)
            case .uploadMultipart(let multipartBody), .uploadCompositeMultipart(let multipartBody, _):
                guard !multipartBody.isEmpty && endpoint.method.supportsMultipart else {
                    fatalError("\(target) is not a multipart upload target.")
                }
                return self.sendUploadMultipart(target, request: request, callbackQueue: callbackQueue, multipartBody: multipartBody, progress: progress, completion: completion)
            case .downloadDestination(let destination), .downloadParameters(_, _, let destination):
                return self.sendDownloadRequest(target, request: request, callbackQueue: callbackQueue, destination: destination, progress: progress, completion: completion)
            }
        default:
            return self.stubRequest(target, request: request, callbackQueue: callbackQueue, completion: completion, endpoint: endpoint, stubBehavior: stubBehavior)
        }
    }

    func cancelCompletion(_ completion: Completion, target: Target) {
        let error = NetworkLayerError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil), nil)
        completion(.failure(error))
    }

    /// Creates a function which, when called, executes the appropriate stubbing behavior for the given parameters.
    final func createStubFunction(_ token: CancellableToken, forTarget target: Target, withCompletion completion: @escaping Completion, endpoint: Endpoint, request: URLRequest) -> (() -> Void) { // swiftlint:disable:this function_parameter_count
        return {
            if token.isCancelled {
                self.cancelCompletion(completion, target: target)
                return
            }

            let validate = { (response: Response) -> Result<Response, NetworkLayerError> in
                let validCodes = target.validationType.statusCodes
                guard !validCodes.isEmpty else { return .success(response) }
                if validCodes.contains(response.statusCode) {
                    return .success(response)
                } else {
                    let statusError = NetworkLayerError.statusCode(response)
                    let error = NetworkLayerError.underlying(statusError, response)
                    return .failure(error)
                }
            }

            switch endpoint.sampleResponseClosure() {
            case .networkResponse(let statusCode, let data):
                let response = Response(statusCode: statusCode, data: data, request: request, response: nil)
                let result = validate(response)
                completion(result)
            case .response(let customResponse, let data):
                let response = Response(statusCode: customResponse.statusCode, data: data, request: request, response: customResponse)
                let result = validate(response)
                completion(result)
            case .networkError(let error):
                let error = NetworkLayerError.underlying(error, nil)
                completion(.failure(error))
            }
        }
    }

    /// Notify all plugins that a stub is about to be performed. You must call this if overriding `stubRequest`.
}

private extension NetworkLayerManager {
    private func interceptor(target: Target) -> NetworkRequestInterceptor {
        return NetworkRequestInterceptor(prepare: { [weak self] urlRequest in
            return urlRequest
       })
    }

    private func setup(interceptor: NetworkRequestInterceptor, with target: Target, and request: Request) {
        interceptor.willSend = { [weak self, weak request] urlRequest in
            guard let self = self, let request = request else { return }
        }
    }

    func sendUploadMultipart(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, multipartBody: [MultipartFormData], progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableToken {
        let formData = RequestMultipartFormData()
        formData.applyMultipartFormData(multipartBody)

        let interceptor = self.interceptor(target: target)
        let uploadRequest: UploadRequest = session.requestQueue.sync {
            let uploadRequest = session.upload(multipartFormData: formData, with: request, interceptor: interceptor)
            setup(interceptor: interceptor, with: target, and: uploadRequest)

            return uploadRequest
        }

        let validationCodes = target.validationType.statusCodes
        let validatedRequest = validationCodes.isEmpty ? uploadRequest : uploadRequest.validate(statusCode: validationCodes)
        return sendAlamofireRequest(validatedRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    func sendUploadFile(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, file: URL, progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableToken {
        let interceptor = self.interceptor(target: target)
        let uploadRequest: UploadRequest = session.requestQueue.sync {
            let uploadRequest = session.upload(file, with: request, interceptor: interceptor)
            setup(interceptor: interceptor, with: target, and: uploadRequest)

            return uploadRequest
        }

        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? uploadRequest : uploadRequest.validate(statusCode: validationCodes)
        return sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    func sendDownloadRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, destination: @escaping DownloadDestination, progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableToken {
        let interceptor = self.interceptor(target: target)
        let downloadRequest: DownloadRequest = session.requestQueue.sync {
            let downloadRequest = session.download(request, interceptor: interceptor, to: destination)
            setup(interceptor: interceptor, with: target, and: downloadRequest)

            return downloadRequest
        }

        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? downloadRequest : downloadRequest.validate(statusCode: validationCodes)
        return sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    func sendRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> CancellableToken {
        let interceptor = self.interceptor(target: target)
        let initialRequest: DataRequest = session.requestQueue.sync {
            let initialRequest = session.request(request, interceptor: interceptor)
            setup(interceptor: interceptor, with: target, and: initialRequest)

            return initialRequest
        }

        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? initialRequest : initialRequest.validate(statusCode: validationCodes)
        return sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    // swiftlint:disable:next cyclomatic_complexity
    func sendAlamofireRequest<T>(_ alamoRequest: T, target: Target, callbackQueue: DispatchQueue?, progress progressCompletion: ProgressBlock?, completion: @escaping Completion) -> CancellableToken where T: Requestable, T: Request {
        // Give plugins the chance to alter the outgoing request
        var progressAlamoRequest = alamoRequest
        let progressClosure: (Progress) -> Void = { progress in
            let sendProgress: () -> Void = {
                progressCompletion?(ProgressResponse(progress: progress))
            }

            if let callbackQueue = callbackQueue {
                callbackQueue.async(execute: sendProgress)
            } else {
                sendProgress()
            }
        }

        // Perform the actual request
        if progressCompletion != nil {
            switch progressAlamoRequest {
            case let downloadRequest as DownloadRequest:
                if let downloadRequest = downloadRequest.downloadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = downloadRequest
                }
            case let uploadRequest as UploadRequest:
                if let uploadRequest = uploadRequest.uploadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = uploadRequest
                }
            case let dataRequest as DataRequest:
                if let dataRequest = dataRequest.downloadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = dataRequest
                }
            default: break
            }
        }

        let completionHandler: RequestableCompletion = { response, request, data, error in
            let result = convertResponseToResult(response, request: request, data: data, error: error, endpointEntity: self.endpointEntity)
            // Inform all plugins about the response
            if let progressCompletion = progressCompletion {
                let value = try? result.get()
                switch progressAlamoRequest {
                case let downloadRequest as DownloadRequest:
                    progressCompletion(ProgressResponse(progress: downloadRequest.downloadProgress, response: value))
                case let uploadRequest as UploadRequest:
                    progressCompletion(ProgressResponse(progress: uploadRequest.uploadProgress, response: value))
                case let dataRequest as DataRequest:
                    progressCompletion(ProgressResponse(progress: dataRequest.downloadProgress, response: value))
                default:
                    progressCompletion(ProgressResponse(response: value))
                }
            }
            completion(result)
        }

        progressAlamoRequest = progressAlamoRequest.response(callbackQueue: callbackQueue, completionHandler: completionHandler)

        progressAlamoRequest.resume()

        return CancellableToken(request: progressAlamoRequest)
    }
}
