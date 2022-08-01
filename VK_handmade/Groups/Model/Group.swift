//
//  Group.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import Foundation
import RealmSwift

// MARK: - Group
class GroupData: Codable {
    let response: Answer

    init(response: Answer) {
        self.response = response
    }
}

// MARK: - Response
class Answer: Codable {
    let count: Int
    let items: [Group]

    init(count: Int, items: [Group]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class Group: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var photo: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo = "photo_50"
    }

    convenience init(id: Int, name: String, photo: String) {
        self.init()
        
        self.id = id
        self.name = name
        self.photo = photo
    }
}
