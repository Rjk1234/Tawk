//
//  ProfileRepository.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation
import CoreData

protocol UserProfileRepositryProtocol {
    associatedtype T
    func get(id: Int, completion: @escaping (T?,CoreRepositoryError?)->Void)
    func create(data:T, completion: @escaping (Bool?,Error?)->Void)
    func update(object: UserModel)
}

class UserProfileRepository: UserProfileRepositryProtocol{
    
    typealias T = UserModel
    
    func create(data: UserModel, completion: @escaping (Bool?, Error?) -> Void) {
        _ = self.createUserProfileEntityFrom(object: data)
        do {
            try CoreDataStack.sharedInstance.writeManagedObjectContext.save()
            
        } catch let error {
            CoreDataStack.sharedInstance.writeManagedObjectContext.rollback()
            completion(false, error)
        }
    }
    
    private  func createUserProfileEntityFrom(object: UserModel) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.writeManagedObjectContext
        if let entity = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: context) as? UserProfile {
            entity.login = object.login
            entity.id = Int64(object.id ?? 0)
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
            entity.type = UserType.user.rawValue
            entity.siteAdmin = object.siteAdmin ?? false
            entity.name = object.name
            entity.company = object.company
            entity.blog = object.blog
            entity.location = object.location
            entity.email = object.email
            entity.hireable = object.hireable
            entity.bio = object.bio
            entity.twitterUsername = object.twitterUsername
            entity.publicRepos = Int64(object.publicRepos ?? 0)
            entity.publicGists = Int64(object.publicGists ?? 0)
            entity.followers = Int64(object.followers ?? 0)
            entity.following = Int64(object.following ?? 0)
            entity.createdAt = object.createdAt
            entity.updatedAt = object.updatedAt
            entity.note = object.note
            return entity
        }
        return nil
    }
    
    func update(object: UserModel){
        let profile: UserProfile!
       
        let fetchReq: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
                             
        fetchReq.predicate = NSPredicate(format: "id = %@", "\(object.id)")
        do {
            let entity = try CoreDataStack.sharedInstance.writeManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                profile = UserProfile(context: CoreDataStack.sharedInstance.writeManagedObjectContext)
            } else {
                profile = entity.first
            }
            profile.login = object.login
            profile.id = Int64(object.id ?? 0)
            profile.nodeID = object.nodeID
            profile.avatarURL = object.avatarURL
            profile.gravatarID = object.gravatarID
            profile.url = object.url
            profile.htmlURL = object.htmlURL
            profile.followersURL = object.followersURL
            profile.followingURL = object.followingURL
            profile.gistsURL = object.gistsURL
            profile.starredURL = object.starredURL
            profile.subscriptionsURL = object.subscriptionsURL
            profile.organizationsURL = object.organizationsURL
            profile.reposURL = object.reposURL
            profile.eventsURL = object.eventsURL
            profile.receivedEventsURL = object.receivedEventsURL
            profile.type = UserType.user.rawValue
            profile.siteAdmin = object.siteAdmin ?? false
            profile.name = object.name
            profile.company = object.company
            profile.blog = object.blog
            profile.location = object.location
            profile.email = object.email
            profile.hireable = object.hireable
            profile.bio = object.bio
            profile.twitterUsername = object.twitterUsername
            profile.publicRepos = Int64(object.publicRepos ?? 0)
            profile.publicGists = Int64(object.publicGists ?? 0)
            profile.followers = Int64(object.followers ?? 0)
            profile.following = Int64(object.following ?? 0)
            profile.createdAt = object.createdAt
            profile.updatedAt = object.updatedAt
            profile.note = object.note
            
           try CoreDataStack.sharedInstance.writeManagedObjectContext.save()
        }catch{
            
        }
    }
    
    func get(id: Int, completion: @escaping (UserModel?,CoreRepositoryError?)->Void) {
        let fetchReq: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                completion(nil, .NotFound)
            }
            let object = createUserProfile(entity: entity[0])
            
            completion(object, nil)
        }catch{
            print(error.localizedDescription)
            completion(nil, .NotFound)
        }
    }
    
    private  func createUserProfile(entity:UserProfile)-> UserModel{
        var object = UserModel(
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
            type: UserType.user.rawValue,
            siteAdmin: entity.siteAdmin,
            name: entity.name,
            company: entity.company,
            blog: entity.blog,
            location: entity.location,
            email: entity.email,
            hireable: entity.hireable,
            bio: entity.bio,
            twitterUsername: entity.twitterUsername,
            publicRepos: Int(entity.publicRepos),
            publicGists: Int(entity.publicGists),
            followers: Int(entity.followers),
            following: Int(entity.following),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
            note: entity.note)
        return object
    }
    
    func updateViewAt(id:Int){
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                return
            }
            if let managedObject = entity.first {
                managedObject.setValue(true, forKey: "isViewed")
                CoreDataStack.sharedInstance.saveContext()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func isProfileViewedAt(id:Int)->Bool{
        let fetchReq: NSFetchRequest<User> = User.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        do {
            let entity = try CoreDataStack.sharedInstance.readManagedObjectContext.fetch(fetchReq)
            if entity.isEmpty{
                return false
            }
            if let viewed = entity.first?.isViewed as? Bool {
                return viewed
            }
        }catch{
            print(error.localizedDescription)
            return false
        }
        return false
    }
}



