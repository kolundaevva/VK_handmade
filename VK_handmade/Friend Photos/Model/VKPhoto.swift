//
//  Phot.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import Foundation

// MARK: - VKPhoto
class VKPhoto: Codable {
    let response: Result

    init(response: Result) {
        self.response = response
    }
}

// MARK: - Response
class Result: Codable {
    let items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    let id, ownerID: Int
    let sizes: [Size]

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }

    init(id: Int, ownerID: Int, sizes: [Size]) {
        self.id = id
        self.ownerID = ownerID
        self.sizes = sizes
    }
}

// MARK: - Size
class Size: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int

    init(height: Int, url: String, type: String, width: Int) {
        self.height = height
        self.url = url
        self.type = type
        self.width = width
    }
}
