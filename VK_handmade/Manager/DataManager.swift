//
//  DataManager.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.08.2022.
//

import Foundation
import RealmSwift

protocol Manager {
    func saveFriends(_ data: [Friend], pk: String)
    func saveUserPhotosData(_ data: [Item], pk: String)
    func saveUserGroupsData(_ data: [VKGroup], pk: String)
    func loadFriendsData(id: String) -> [User]
    func loadUserPhotos(id: String) -> [Photo]
    func loadUserGroups(id: String) -> [Group]
}

class DataManager: Manager {
    func saveFriends(_ data: [Friend], pk: String) {
        print("HEEEEERE")
        print(data)
        print(pk)
        do {
            let realm = try Realm()
            let users = data.map { User(userId: pk, user: $0) }
            try realm.write {
                realm.add(users, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func saveUserPhotosData(_ data: [Item], pk: String) {
        do {
            let realm = try Realm()
            let photos = data.map { Photo(photo: $0) }
            try realm.write {
                realm.add(photos, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func saveUserGroupsData(_ data: [VKGroup], pk: String) {
        do {
            let realm = try Realm()
            let groups = data.map { Group(userId: pk, group: $0) }
            try realm.write {
                realm.add(groups, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func loadFriendsData(id: String) -> [User] {
        do {
            let realm = try Realm()
            let userId = Int(id) ?? 0
            let list = realm.objects(User.self).filter("userId == %@", userId)
            return Array(list)
        } catch {
            print(error)
            return []
        }
    }
    
    func loadUserPhotos(id: String) -> [Photo] {
        do {
            let realm = try Realm()
            let userId = Int(id) ?? 0
            let list = realm.objects(Photo.self).filter("ownerId == %@", userId)
            return Array(list)
        } catch {
            print(error)
            return []
        }
    }
    
    func loadUserGroups(id: String) -> [Group] {
        do {
            let realm = try Realm()
            let userId = Int(id) ?? 0
            let list = realm.objects(Group.self).filter("userId == %@", userId)
            return Array(list)
        } catch {
            print(error)
            return []
        }
    }
}
