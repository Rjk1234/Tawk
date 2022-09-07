//
//  UserRepository.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation
import CoreData
 
enum CoreRepositoryError: Error {
    case NotFound
}

protocol UserListRepositryProtocol {
    associatedtype T
    func getAll( completion: @escaping ([T]?,Error?)->Void)
    func create(data:[T], completion: @escaping (Bool?,Error?)->Void)
    func setView(id: Int, completion: @escaping (Bool?,Error?)->Void)
    func isViewed(id: Int, completion: @escaping (Bool?,Error?)->Void)
    func readLast(completion: @escaping (Int?,Error?)->Void)
}

class UserListRepository:  UserListRepositryProtocol {
    
    typealias T = UserListElement
    
    func readLast(completion: @escaping (Int?, Error?) -> Void) {
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: "id", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor1]
        fetchReq.fetchLimit = 1
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if let id = entity.first?.id as? Int64 {
                completion(Int(id), nil)
            }
        } catch {
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    func setView(id: Int, completion: @escaping (Bool?, Error?) -> Void) {
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                completion(false, nil)
            }
            if let managedObject = entity.first {
                managedObject.setValue(true, forKey: "isViewed")
                CoreDataStack.sharedInstance.saveContext()
            }
        }catch{
            print(error.localizedDescription)
            completion(false, nil)
        }
    }
    
    func isViewed(id: Int, completion: @escaping (Bool?, Error?) -> Void) {
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                completion(false, nil)
            }
            if let viewed = entity.first?.isViewed as? Bool {
                completion(viewed, nil)
            }
        }catch{
            print(error.localizedDescription)
            completion(nil, error)
        }
        
    }
    
    func create(data: [UserListElement], completion: @escaping (Bool?, Error?) -> Void) {
        _ = data.map{self.createUserEntityFrom(object: $0)}
        do {
            try CoreDataStack.sharedInstance.writeManagedObjectContext.save()
        } catch let error {
            print(error)
            completion(false, error)
        }
    }
    
    private func createUserEntityFrom(object: UserListElement) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.writeManagedObjectContext
        if let entity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            entity.login = object.login
            entity.id = Int64(object.id!)
            entity.nodeID = object.nodeID
            entity.avatarURL = object.avatarURL
            entity.gravatarID = object.gravatarID
            entity.url = object.url
            entity.htmlURL = object.htmlURL
            entity.followersURL = object.followersURL
            entity.followingURL = object.followingURL
            entity.gistsURL = object.gistsURL
            entity.starredURL = object.starredURL
            entity.subscriptionsURL = object.subscriptionsURL
            entity.organizationsURL = object.organizationsURL
            entity.reposURL = object.reposURL
            entity.eventsURL = object.eventsURL
            entity.receivedEventsURL = object.receivedEventsURL
            entity.type = object.type?.rawValue
            entity.siteAdmin = object.siteAdmin!
            entity.isViewed = object.isViewed ?? false
            
            return entity
        }
        return nil
    }
    
    
    
    func getAll(completion: @escaping ([UserListElement]?, Error?) -> Void) {
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: "id", ascending: true)
        fetchReq.sortDescriptors = [sortDescriptor1]
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            var arr = entity.map{self.createUser(entity: $0)}
            completion(arr, nil)
        }catch{
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    private  func createUser(entity:User)-> UserListElement{
        var object = UserListElement(
            login: entity.login,
            id: Int(entity.id),
            nodeID: entity.nodeID,
            avatarURL: entity.avatarURL,
            gravatarID: entity.gravatarID,
            url: entity.url,
            htmlURL: entity.htmlURL,
            followersURL: entity.followersURL,
            followingURL: entity.followingURL,
            gistsURL: entity.gistsURL,
            starredURL: entity.starredURL,
            subscriptionsURL: entity.subscriptionsURL,
            organizationsURL: entity.organizationsURL,
            reposURL: entity.reposURL,
            eventsURL: entity.eventsURL,
            receivedEventsURL: entity.receivedEventsURL,
            type: .organization,
            siteAdmin: entity.siteAdmin,
            isViewed: entity.isViewed)
        return object
    }
    
    func updateRecord(data:[UserListElement]){
        
        _ = data.map{self.create(object: $0)}
        do {
            try CoreDataStack.sharedInstance.writeManagedObjectContext.save()
        } catch let error {
            print(error)
        }
    }
    func create(object: UserListElement){
        let user: User!
        let id = object.id
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
                             
        fetchReq.predicate = NSPredicate(format: "id = %@", "\(object.id!)")
        do {
            let entity = try CoreDataStack.sharedInstance.writeManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                user = User(context: CoreDataStack.sharedInstance.writeManagedObjectContext)
            } else {
                user = entity.first
            }
            user.login = object.login
            user.id = Int64(object.id!)
            user.nodeID = object.nodeID
            user.avatarURL = object.avatarURL
            user.gravatarID = object.gravatarID
            user.url = object.url
            user.htmlURL = object.htmlURL
            user.followersURL = object.followersURL
            user.followingURL = object.followingURL
            user.gistsURL = object.gistsURL
            user.starredURL = object.starredURL
            user.subscriptionsURL = object.subscriptionsURL
            user.organizationsURL = object.organizationsURL
            user.reposURL = object.reposURL
            user.eventsURL = object.eventsURL
            user.receivedEventsURL = object.receivedEventsURL
            user.type = object.type?.rawValue
            user.siteAdmin = object.siteAdmin!
            user.isViewed = object.isViewed ?? false
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
