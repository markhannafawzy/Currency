
import Foundation
import Alamofire
import RxSwift
public protocol NetworkRouter: AnyObject {
    associatedtype Target: TargetType
    func request<T:Codable>(_ target: Target) -> Observable<T>
}

public final class Router<Target: TargetType>: NetworkRouter {
    
    private let scheduler: ConcurrentDispatchQueueScheduler
    private var networkManager = NetworkLayerManager<Target>()
    public init() {
        let qos = DispatchQoS(qosClass: DispatchQoS.QoSClass.background,
                              relativePriority: 1)
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
    }

    public func request<T:Codable>(_ target: Target) -> Observable<T> {
        guard let manager = NetworkReachabilityManager(), manager.isReachable else {
            return Observable.error(NetworkError.offline)
        }
            return networkManager.rx
                    .request(target)
                    .filterSuccess()
                    .mapObject(T.self)
//                    .debug()
                    .subscribe(on: scheduler)
                    .observe(on: MainScheduler.instance)
                    .asObservable()
    }
}
