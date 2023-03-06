
import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
        
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            do {
                return Single.just(try response.map(type, atKeyPath: path))
                
            } catch(let error){
                return Single.error(NetworkError.other(error))
            }
        }
    }
    
    func mapArray<T: Codable>(_ type: [T].Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.map(type, atKeyPath: path))
        }
    }
    
    func filterSuccess() -> Single<Element> {
        return flatMap {
            (response) -> Single<Element> in
            if 200 ... 299 ~= response.statusCode {
                return Single.just(response)
            } else {
                let netError = CustomNetworkingError(response)
                return Single.error(NetworkError.network(netError))
            }
        }
    }
}

extension Single {
    var asDriverResult: Driver<Result<Element, Error>> {
        return asObservable()
            .map { .success($0) }
            .asDriver(onErrorRecover: { .just(.failure($0)) })
    }
}
