//
//  User.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 05.08.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id = ApiKey.userID.rawValue
    var friends = List<Friend>()
    var groups = List<Group>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
