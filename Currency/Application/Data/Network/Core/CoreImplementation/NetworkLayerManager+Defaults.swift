import Foundation

/// These functions are default mappings to `NetworkLayerManager`'s properties: endpoints, requests, session etc.
public extension NetworkLayerManager {
    final class func defaultEndpointMapping(for target: Target) -> Endpoint {
        Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            encoding: target.encoding,
            httpHeaderFields: target.headers
        )
    }

    final class func defaultRequestMapping(for endpoint: Endpoint, closure: RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch NetworkLayerError.requestMapping(let url) {
            closure(.failure(NetworkLayerError.requestMapping(url)))
        } catch NetworkLayerError.parameterEncoding(let error) {
            closure(.failure(NetworkLayerError.parameterEncoding(error)))
        } catch {
            closure(.failure(NetworkLayerError.underlying(error, nil)))
        }
    }

    final class func defaultAlamofireSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default

        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}
