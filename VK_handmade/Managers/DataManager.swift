//
//  DataManager.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 27.09.2022.
//

import Foundation
import RealmSwift

protocol DataManager {
    func getAllData<T: Object>() -> [T]
    func getFriends(by userId: Int) -> [Friend]
    func getPhotos(by userId: Int) -> [Photo]
    func getGroups(by userId: Int) -> [Group]
    func getNewsFeed(by userId: Int) -> Feed?
}

class DataManagerImpl: DataManager {
    private let realm: Realm
    static let session = DataManagerImpl()

    private init?() {
        let configurator = Realm.Configuration(schemaVersion: 0, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else { return nil }
        self.realm = realm
        print(realm.configuration.fileURL ?? "")
    }

    func getAllData<T: Object>() -> [T] {
        return Array(realm.objects(T.self))
    }

    func getFriends(by userId: Int = ApiKey.session.userId) -> [Friend] {
        guard let user = realm.object(ofType: User.self, forPrimaryKey: userId) else { return [] }
        return Array(user.friends)
    }

    func getPhotos(by userId: Int) -> [Photo] {
        guard let user = realm.object(ofType: Friend.self, forPrimaryKey: userId) else { return [] }
        return Array(user.photos)
    }

    func getGroups(by userId: Int = ApiKey.session.userId) -> [Group] {
        guard let user = realm.object(ofType: User.self, forPrimaryKey: userId) else { return [] }
        return Array(user.groups)
    }

    func getNewsFeed(by userId: Int = ApiKey.session.userId) -> Feed? {
        guard let user = realm.object(ofType: User.self, forPrimaryKey: userId) else { return nil }
        return user.feeds.first
    }
}
