//
//  DataManager.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.08.2022.
//

import Foundation
import RealmSwift

protocol Manager {
    func saveFriends(_ data: [VKFriend])
    func saveUserPhotosData(_ data: [Item], pk: String)
    func saveUserGroupsData(_ data: [VKGroup])
    func addGroup(_ group: Group)
}

class DataManager: Manager {
    func saveFriends(_ data: [VKFriend]) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.userID.rawValue) else { return }
            let friends = data.map { Friend(user: $0) }
            let oldFriends = user.friends

            try realm.write {
                oldFriends.forEach { frd in
                    realm.delete(frd.photos)
                }
                
                realm.delete(oldFriends)
                user.friends.append(objectsIn: friends)
            }
        } catch {
            print(error)
        }
    }
    
    func saveUserPhotosData(_ data: [Item], pk: String) {
        do {
            let realm = try Realm()
            let id = Int(pk) ?? 0
            guard let user = realm.object(ofType: Friend.self, forPrimaryKey: id) else { return }
            let photos = data.map { Photo(photo: $0) }
            let oldPhotos = user.photos
            
            try realm.write {
                realm.delete(oldPhotos)
                user.photos.append(objectsIn: photos)
            }
        } catch {
            print(error)
        }
    }
    
    func saveUserGroupsData(_ data: [VKGroup]) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.userID.rawValue) else { return }
            let groups = data.map { Group(group: $0) }
            let oldGourps = user.groups

            try realm.write {
                realm.delete(oldGourps)
                user.groups.append(objectsIn: groups)
            }
        } catch {
            print(error)
        }
    }
    
    func addGroup(_ group: Group) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.userID.rawValue) else { return }
            
            try realm.write {
                user.groups.append(group)
            }
        } catch {
            print(error)
        }
    }
}
