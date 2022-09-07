//
//  CoreDataStack.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 05/09/22.
//

import Foundation
import CoreData

// MARK: - Core Data stack
class CoreDataStack: NSObject{
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TawkAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var writeManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
    return managedObjectContext
    }()

    public private(set) lazy var readManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.writeManagedObjectContext
        return managedObjectContext
    }()
    
    
    // MARK: - Core Data Saving support
    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    func saveContext(){
        readManagedObjectContext.performAndWait {
            do{
                if self.readManagedObjectContext.hasChanges {
                    try self.readManagedObjectContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        writeManagedObjectContext.perform {
            do{
                if self.writeManagedObjectContext.hasChanges {
                    try self.writeManagedObjectContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
