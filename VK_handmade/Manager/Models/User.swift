//
//  User.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 05.08.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id = ""
    var friends = List<Friend>()
    var groups = List<Group>()
    var feeds = List<Feed>()

    override class func primaryKey() -> String? {
        return "id"
    }
}
