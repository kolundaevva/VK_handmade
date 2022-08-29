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
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(group: API.Types.Response.VKGroupData.GroupResponse.VKGroup) {
        self.init()
        
        id = group.id
        name = group.name
        photo = group.photo
    }
}
