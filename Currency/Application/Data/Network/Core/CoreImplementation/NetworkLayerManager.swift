import Foundation

/// Closure to be executed when a request has completed.
public typealias Completion = (_ result: Result<Response, NetworkLayerError>) -> Void

/// Closure to be executed when progress changes.
public typealias ProgressBlock = (_ progress: ProgressResponse) -> Void

/// A type representing the progress of a request.
public struct ProgressResponse {

    /// The optional response of the request.
    public let response: Response?

    /// An object that conveys ongoing progress for a given request.
    public let progressObject: Progress?

    /// Initializes a `ProgressResponse`.
    public init(progress: Progress? = nil, response: Response? = nil) {
        self.progressObject = progress
        self.response = response
    }

    /// The fraction of the overall work completed by the progress object.
    public var progress: Double {
        if completed {
            return 1.0
        } else if let progressObject = progressObject, progressObject.totalUnitCount > 0 {
            // if the Content-Length is specified we can rely on `fractionCompleted`
            return progressObject.fractionCompleted
        } else {
            // if the Content-Length is not specified, return progress 0.0 until it's completed
            return 0.0
        }
    }

    /// A Boolean value stating whether the request is completed.
    public var completed: Bool { response != nil }
}

/// A protocol representing a minimal interface for a NetworkLayerManager.
/// Used by the reactive networkkManager extensions.
public protocol NetworkLayerManagerType: AnyObject {

    associatedtype Target: TargetType

    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable
}

/// Request networkManager class. Requests should be made through this class only.
open class NetworkLayerManager<Target: TargetType>: NetworkLayerManagerType {

    /// Closure that defines the endpoints for the networkManager.
    public typealias EndpointClosure = (Target) -> Endpoint

    /// Closure that decides if and what request should be performed.
    public typealias RequestResultClosure = (Result<URLRequest, NetworkLayerError>) -> Void

    /// Closure that resolves an `Endpoint` into a `RequestResult`.
    public typealias RequestClosure = (Endpoint, @escaping RequestResultClosure) -> Void

    /// Closure that decides if/how a request should be stubbed.
    public typealias StubClosure = (Target) -> StubBehavior

    /// A closure responsible for mapping a `TargetType` to an `EndPoint`.
    public let endpointClosure: EndpointClosure

    var endpointEntity: Endpoint?
    
    /// A closure deciding if and what request should be performed.
    public let requestClosure: RequestClosure

    /// A closure responsible for determining the stubbing behavior
    /// of a request for a given `TargetType`.
    public let stubClosure: StubClosure

    public let session: Session

    /// Propagated to Alamofire as callback queue. If nil - the Alamofire default (as of their API in 2017 - the main queue) will be used.
    let callbackQueue: DispatchQueue?

    let lock: NSRecursiveLock = NSRecursiveLock()

    /// Initializes a networkManager.
    public init(endpointClosure: @escaping EndpointClosure = NetworkLayerManager.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = NetworkLayerManager.defaultRequestMapping,
                stubClosure: @escaping StubClosure = NetworkLayerManager.neverStub,
                callbackQueue: DispatchQueue? = nil,
                session: Session = NetworkLayerManager<Target>.defaultAlamofireSession()) {

        self.endpointClosure = endpointClosure
        self.requestClosure = requestClosure
        self.stubClosure = stubClosure
        self.session = session
        self.callbackQueue = callbackQueue
    }

    /// Returns an `Endpoint` based on the token, method, and parameters by invoking the `endpointClosure`.
    open func endpoint(_ token: Target) -> Endpoint {
        endpointClosure(token)
    }

    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    @discardableResult
    open func request(_ target: Target,
                      callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping Completion) -> Cancellable {

        let callbackQueue = callbackQueue ?? self.callbackQueue
        return requestNormal(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    @discardableResult
    open func stubRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, completion: @escaping Completion, endpoint: Endpoint, stubBehavior: StubBehavior) -> CancellableToken {
        let callbackQueue = callbackQueue ?? self.callbackQueue
        let cancellableToken = CancellableToken { }
        let alamoRequest = session.request(request)
        alamoRequest.cancel()
        let stub: () -> Void = createStubFunction(cancellableToken, forTarget: target, withCompletion: completion, endpoint: endpoint, request: request)
        switch stubBehavior {
        case .immediate:
            switch callbackQueue {
            case .none:
                stub()
            case .some(let callbackQueue):
                callbackQueue.async(execute: stub)
            }
        case .delayed(let delay):
            let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
            let killTime = DispatchTime.now() + Double(killTimeOffset) / Double(NSEC_PER_SEC)
            (callbackQueue ?? DispatchQueue.main).asyncAfter(deadline: killTime) {
                stub()
            }
        case .never:
            fatalError("Method called to stub request when stubbing is disabled.")
        }

        return cancellableToken
    }
    // swiftlint:enable function_parameter_count
}

// MARK: Stubbing

/// Controls how stub responses are returned.
public enum StubBehavior {

    /// Do not stub.
    case never

    /// Return a response immediately.
    case immediate

    /// Return a response after a delay.
    case delayed(seconds: TimeInterval)
}

public extension NetworkLayerManager {

    /// Do not stub.
    final class func neverStub(_: Target) -> StubBehavior { .never }

    /// Return a response immediately.
    final class func immediatelyStub(_: Target) -> StubBehavior { .immediate }

    /// Return a response after a delay.
    final class func delayedStub(_ seconds: TimeInterval) -> (Target) -> StubBehavior {
        return { _ in .delayed(seconds: seconds) }
    }
}

/// A public function responsible for converting the result of a `URLRequest` to a Result<Response, NetworkLayerError>.
public func convertResponseToResult(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Swift.Error?, endpointEntity: Endpoint?) ->
    Result<Response, NetworkLayerError> {
        if let endpoint = endpointEntity {
            Logger.debugingLog(fileName: #file.description,
                               functionName: #function.description,
                               LineNumber: #line.description,
                               data: [
                                      "service.host": endpoint.url,
                                      "successResult.data 'successData'": String(data: data ?? Data(), encoding: .utf8) ?? ""])
        }
        switch (response, data, error) {
        case let (.some(response), data, .none):
            let response = Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            return .success(response)
        case let (.some(response), _, .some(error)):
            let response = Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            let error = NetworkLayerError.underlying(error, response)
            return .failure(error)
        case let (_, _, .some(error)):
            let error = NetworkLayerError.underlying(error, nil)
            return .failure(error)
        default:
            let error = NetworkLayerError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
            return .failure(error)
        }
}
