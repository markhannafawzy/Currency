import Foundation
import CoreData

extension NSManagedObjectContext {
    func create<T: NSFetchRequestResult>() -> T {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self),
                into: self) as? T else {
            fatalError()
        }
        return entity
    }
}

extension NSManagedObjectContext {
    
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
