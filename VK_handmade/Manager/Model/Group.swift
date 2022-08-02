//
//  Group.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 02.08.2022.
//

import Foundation
import RealmSwift

class Group: Object {
    @objc dynamic var id = 0
    @objc dynamic var userId = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    override class func indexedProperties() -> [String] {
        ["id", "userId"]
    }
    
    convenience init(userId: String, group: VKGroup) {
        self.init()
        
        let userId = Int(userId) ?? 0
        self.userId = userId
        id = group.id
        name = group.name
        photo = group.photo
    }
}
