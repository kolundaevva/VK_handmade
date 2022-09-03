//
//  User.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 02.08.2022.
//

import Foundation
import RealmSwift

class Friend: Object, ProfileRepsentable {
    @objc dynamic var id = 0
    @objc dynamic var photo = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    var name: String {
        return firstName + " " + lastName
    }
    var photos = List<Photo>()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(user: API.Types.Response.VKUser.UserResponse.VKFriend) {
        self.init()
        
        id = user.id
        photo = user.photo
        firstName = user.firstName
        lastName = user.lastName
    }
}
