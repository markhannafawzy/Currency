////
////  File.swift
////  
////
////  Created by Mark Hanna on 05/01/2023.
////
//
//import Foundation
//import Alamofire
//
//public protocol NetworkRouter: AnyObject {
//    associatedtype Target: TargetType
//    typealias CompletionHandler<T> = (Result<T, NetworkError>) -> Void
//    func request<T: Decodable>(with target: Target, completion: @escaping CompletionHandler<T>)
//}
//
//public final class Router<Target: TargetType>: NetworkRouter {
//    
//    private var networkManager = NetworkLayerManager<Target>()
//    public init() {
//    }
//    
//    public func request<T>(with target: Target, completion: @escaping CompletionHandler<T>) where T : Decodable {
//        
//        guard let manager = NetworkReachabilityManager(), manager.isReachable else {
//            completion(.failure(NetworkError.offline))
//            return
//        }
//        networkManager.request(target) { result in
//            switch result {
//            case let .success(networkResponse):
//                do {
//                    let filteredResponse = try networkResponse.filterSuccessfulStatusCodes()
//                    guard let decodedResponse = try? filteredResponse.map(T.self) else { completion(.failure(.json)); return }
//                    DispatchQueue.main.async{ completion(.success(decodedResponse)) }
//                }
//                catch {
//                    let netError = CustomNetworkingError(networkResponse)
//                    DispatchQueue.main.async { completion(.failure(.network(netError))) }
//                }
//            case let .failure(error):
//                DispatchQueue.main.async{ completion(.failure(.other(error))) }
//            }
//        }
//    }
//}
//// let router = Router<NameOfTarget>()
//// remoteService.request(target: yourTarget) { result in
////    switch result {
//
////}
////}
//// let repo = Repo(remoteService: router, localService: ...)
//// Repository Interfaces
//
//protocol TestRepositoryProtocol {
//
//    associatedtype RemoteServiceType: NetworkRouter
//
//    func fetchDataList(query: Data, completion: @escaping (Result<String, Error>) -> Void)
//
//}
//
//class Repo: TestRepositoryProtocol {
//    typealias RemoteServiceType = Router<ExampleNetworkTarget>
//    
//    
//    let networkService: Router<ExampleNetworkTarget>
//    
//    init(networkService: RemoteServiceType = Router<ExampleNetworkTarget>) {
//        self.networkService = networkService
//    }
//    
//    func fetchDataList(query: Data, completion: @escaping (Result<String, Error>) -> Void) {
//        <#code#>
//    }
//    
//    
//}
//
//enum ExampleNetworkTarget {
//    case posts
//}
//
//extension ExampleNetworkTarget: NetworkTargetType {
//    
//    var sampleData: Data {
//        Data()
//    }
//    var task: Task {
//        switch self {
//        case .posts:
//            return .requestPlain
//        }
//    }
//    var headers: [String: String]? {
//        return nil
//    }
//    var path: String {
//        switch self {
//        case .posts:
//            return "/posts"
//
//        }
//    }
//
//    var method: Method {
//        switch self {
//        case .posts:
//            return .get
//        }
//    }
//    
////    var host: HOST {
////        switch self {
////        case .posts, .addPost(_):
////            return .defaultBase
////        case .uploadAsset:
////            return .mediaServer
////        }
////    }
//}
//
//protocol NetworkTargetType: TargetType {
////    var host: HOST { get }
//}
//extension NetworkTargetType {
//    func buildRequest(using formDataDict: [String: Any]) -> [MultipartFormData] {
//        var formData: [MultipartFormData] = []
//        formDataDict.forEach { key, value in
//            if let data = value as? Data {
//                formData.append(MultipartFormData(provider: .data(data), name: key, fileName: "file.jpeg", mimeType: "image/jpeg"))
//            } else if let string = value as? String {
//                formData.append(MultipartFormData(provider: .data(string.data(using: .utf8)!), name: key))
//            } else if let bool = value as? Bool {
//                formData.append(MultipartFormData(provider: .data(bool.description.data(using: .utf8)!), name: key))
//            } else {
//                fatalError("request parameters is not a string or Data , please check here")
//            }
//        }
//        return formData
//    }
//}
//extension NetworkTargetType {
//    var baseURL: URL {
//        guard let url =  URL(string: "host.baseUrl") else {
//            fatalError("Incorrect Url")
//        }
//        return url
//    }
//}
