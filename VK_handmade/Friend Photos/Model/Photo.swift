//
//  Phot.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import Foundation


// MARK: - Photo
class Photo: Codable {
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
    let sizes: [Size]

    enum CodingKeys: String, CodingKey {
        case sizes
    }

    init(sizes: [Size]) {
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
