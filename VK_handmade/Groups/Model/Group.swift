//
//  Group.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import Foundation


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
class Group: Codable {
    let id: Int
    let name: String
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo = "photo_50"
    }

    init(id: Int, name: String, photo: String) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
