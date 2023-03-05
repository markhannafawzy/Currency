import Foundation

/// The protocol used to define the specifications necessary for a `NetworkLayerManager`.
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Method { get }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The Encoding to be used in the request.
    var encoding: ParameterEncoding { get }
}

public extension TargetType {

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { .none }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data { Data() }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
}
