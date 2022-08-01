//
//  User.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import Foundation
import RealmSwift

// MARK: - User
class User: Codable {
    let response: Response

    init(response: Response) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let items: [Friend]

    init(items: [Friend]) {
        self.items = items
    }
}

// MARK: - Item
class Friend: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var photo: String
    @objc dynamic var firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case id
        case photo = "photo_50"
        case firstName = "first_name"
        case lastName = "last_name"
    }

    convenience init(id: Int, photo: String, firstName: String, lastName: String) {
        self.init()
        
        self.id = id
        self.photo = photo
        self.firstName = firstName
        self.lastName = lastName
    }
}
