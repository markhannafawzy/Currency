import Foundation
import CoreData
import RxSwift

protocol AbstractLocalDataSource {
    associatedtype T
    func query(with predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]?) -> Observable<[T]>
    func save(entity: T) -> Observable<Void>
    func delete(entity: T) -> Observable<Void>
    func batchDelete(with predicate: NSPredicate?) -> Observable<Void>
}

final class LocalDataSource<T: CoreDataRepresentable>: AbstractLocalDataSource where T == T.CoreDataType.DomainType {
    private let context: NSManagedObjectContext
    private let scheduler: ContextScheduler

    init(context: NSManagedObjectContext) {
        self.context = context
        self.scheduler = ContextScheduler(context: context)
    }

    func query(with predicate: NSPredicate? = nil,
                        sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[T]> {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return context.rx.entities(fetchRequest: request)
            .mapToDomain()
            .subscribe(on: scheduler)
    }

    func save(entity: T) -> Observable<Void> {
        return entity.sync(in: context)
            .mapToVoid()
            .flatMapLatest(context.rx.save)
            .subscribe(on: scheduler)
    }

    func delete(entity: T) -> Observable<Void> {
        return entity.sync(in: context)
            .map({$0 as! NSManagedObject})
            .flatMapLatest(context.rx.delete)
    }
    
    func batchDelete(with predicate: NSPredicate? = nil) -> Observable<Void> {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        return context.rx.batchDelete(fetchRequest: request)
    }

}
