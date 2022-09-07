//
//  DatabaseService.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 05/09/22.
//

import Foundation
import CoreData

class DatabaseService {
    
    func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.readManagedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
}
