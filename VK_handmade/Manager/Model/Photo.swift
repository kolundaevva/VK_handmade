//
//  Photo.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 02.08.2022.
//

import Foundation
import RealmSwift

class Photo: Object {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var url = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    override class func indexedProperties() -> [String] {
        ["id", "ownerId"]
    }
    
    convenience init(photo: Item) {
        self.init()
        
        id = photo.id
        ownerId = photo.ownerID
        guard let photoURL = photo.sizes.first?.url else {
            self.url = ""
            return
        }
        self.url = photoURL
    }
}
