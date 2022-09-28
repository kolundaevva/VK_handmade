//
//  DataManager.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.08.2022.
//

import Foundation
import RealmSwift

protocol UserManager {
    func saveUser(id: Int)
    func saveFriends(_ friends: [Friend])
    func saveUserPhotosData(_ photos: [Photo], id: Int)
    func saveUserGroupsData(_ groups: [Group])
    func saveUserFeedData(_ feeds: Feed)
    func addGroup(_ group: Group)
}

class UserManagerImpl: UserManager {
    private let realm: Realm
    static let session = UserManagerImpl()

    private init?() {
        let configurator = Realm.Configuration(schemaVersion: 0, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else { return nil }
        self.realm = realm
        print(realm.configuration.fileURL ?? "")
    }

    func saveUser(id: Int) {
        let user = User()
        user.id = id

        do {
            //            let realm = try Realm()
            try realm.write {
                realm.add(user)
            }
        } catch {
            print(error)
        }
    }

    func saveFriends(_ friends: [Friend]) {
        do {
            //            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }
            let oldFriends = Array(user.friends)

            if friends != oldFriends {

                var uniqueNewFriends = [Friend]()
                var uniqueOldFriends = [Friend]()

                friends.forEach { friend in
                    if !oldFriends.contains(where: { $0.id == friend.id }) {
                        uniqueNewFriends.append(friend)
                    }
                }

                oldFriends.forEach { friend in
                    if !friends.contains(where: { $0.id == friend.id }) {
                        uniqueOldFriends.append(friend)
                    }
                }

                try realm.write {
                    uniqueOldFriends.forEach { frd in
                        realm.delete(frd.photos)
                    }

                    realm.delete(uniqueOldFriends)
                    user.friends.append(objectsIn: uniqueNewFriends)
                }
            }
        } catch {
            print(error)
        }
    }

    func saveUserPhotosData(_ photos: [Photo], id: Int) {
        do {
            //            let realm = try Realm()
            //            let id = Int(ApiKey.session.userId) ?? 0
            guard let user = realm.object(ofType: Friend.self, forPrimaryKey: id) else { return }
            let oldPhotos = user.photos

            try realm.write {
                realm.delete(oldPhotos)
                user.photos.append(objectsIn: photos)
            }
        } catch {
            print(error)
        }
    }

    func saveUserGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }

            let oldGourps = Array(user.groups)
            var uniqueNewGroups = [Group]()
            var uniqueOldGrops = [Group]()

            if oldGourps != groups {

                groups.forEach { group in
                    if !oldGourps.contains(where: { $0.id == group.id }) {
                        uniqueNewGroups.append(group)
                    }
                }

                oldGourps.forEach { group in
                    if !groups.contains(where: { $0.id == group.id }) {
                        uniqueOldGrops.append(group)
                    }
                }

                try realm.write {
                    uniqueOldGrops.forEach { group in
                        realm.delete(group)
                    }

                    uniqueNewGroups.forEach { group in
                        user.groups.append(group)
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    func saveUserFeedData(_ feeds: Feed) {
        do {
            //            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }
            let oldFeeds = user.feeds

            if oldFeeds.first != feeds {

                try realm.write {
                    oldFeeds.forEach { oldFeed in
                        realm.delete(oldFeed.groups)
                        realm.delete(oldFeed.users)
                        oldFeed.feed.forEach { feed in
                            feed.photos.forEach { photo in
                                realm.delete(photo.sizes)
                            }
                            realm.delete(feed.photos)
                        }
                        realm.delete(oldFeed.feed)
                    }

                    realm.delete(oldFeeds)
                    user.feeds.append(feeds)
                }
            }
        } catch {
            print(error)
        }
    }

    func addGroup(_ group: Group) {
        do {
            //            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }

            try realm.write {
                user.groups.append(group)
            }
        } catch {
            print(error)
        }
    }
}
