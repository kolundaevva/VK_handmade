//
//  ApiKey.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 29.07.2022.
//

import Foundation

class ApiKey {
    static let session = ApiKey()

    var token = ""
    var userId = ""

    private init() {}
}
