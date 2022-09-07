//
//  NotesRepository.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation
import CoreData

protocol NotesRepositoryProtocol {
    associatedtype T
    func save(id: Int, note: T, completion: @escaping (Bool,Error?)->Void)
    func readAvailable(id: Int, completion: @escaping (Bool,String?)->Void)
}
 
class NotesRepository: NotesRepositoryProtocol {
    typealias T = String
    func save(id: Int, note: String, completion: @escaping (Bool, Error?) -> Void) {
        let context = CoreDataStack.sharedInstance.writeManagedObjectContext
         let entity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context) as! Notes
        entity.noteText = note
        entity.userId = Int64(id)
            do {
                try CoreDataStack.sharedInstance.writeManagedObjectContext.save()
                completion(true, nil)
            } catch let error {
                print(error)
                completion(false, error)
            }
    }
    
    func readAvailable(id: Int, completion: @escaping (Bool, String?) -> Void) {
        let fetchReq: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "userId LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                completion(false, nil)
            }
            if let noteText = entity.first?.noteText as? String {
                completion(true, noteText)
            }
        }catch{
            print(error.localizedDescription)
            completion(false, nil)
        }
    }
    func read(id: Int) -> String? {
        let fetchReq: NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "userId LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                return nil
            }
            if let noteText = entity.first?.noteText as? String {
                return noteText
            }
        }catch{
            print(error.localizedDescription)
           return nil
        }
        return nil
    }
    
}
