//
//  DataService.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 24.04.2023.
//

import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    
    func fetchCategory() throws -> [DBCategoryManagedObject]
    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
    func clearData()
    func deleteObjects(from categoryName: String)
    var persistentContainer: NSPersistentContainer { get }
}

final class CoreDataService: CoreDataServiceProtocol {
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Categories")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            print(error)
        }
        return persistentContainer
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func fetchCategory() throws -> [DBCategoryManagedObject] {
        let fetchRequest = DBCategoryManagedObject.fetchRequest()
        return try viewContext.fetch(fetchRequest)
    }
    
    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        let saveContext = persistentContainer.newBackgroundContext()
        saveContext.perform {
            do {
                try block(saveContext)
                if saveContext.hasChanges {
                    try saveContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func deleteObjects(from categoryName: String) {
        let fetchRequest = DBCategoryManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", categoryName as CVarArg)
        if let result = try? viewContext.fetch(fetchRequest) {
            for object in result {
                viewContext.delete(object)
            }
        }
        do {
            try viewContext.save()
        } catch {
            //Handle error
        }
    }
    
    func clearData() {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DBCategoryManagedObject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        backgroundContext.perform {
            do {
                let batchDelete = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult
                guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }
                let deletedObjects: [AnyHashable: Any] = [ NSDeletedObjectsKey: deleteResult]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [backgroundContext])
            } catch {
                print(error)
            }
        }
    }
}
