//
//  User.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 02.08.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var friendId = 0
    @objc dynamic var userId = 0
    @objc dynamic var photo = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    
    override class func primaryKey() -> String? {
        "friendId"
    }
    
    override class func indexedProperties() -> [String] {
        ["friendId", "userId"]
    }
    
    convenience init(userId: String, user: Friend) {
        self.init()
        
        let id = Int(userId) ?? 0
        self.userId = id
        friendId = user.id
        photo = user.photo
        firstName = user.firstName
        lastName = user.lastName
    }
}
