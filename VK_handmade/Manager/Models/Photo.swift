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
    @objc dynamic var url = ""
    dynamic var sizes = List<Size>()

    var height: Int {
        return getPropperSize().height
    }

    var width: Int {
        return getPropperSize().width
    }

    var srcBIG: String {
        return getPropperSize().url
    }

    private func getPropperSize() -> Size {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return Size(height: 0, width: 0, url: "", type: "wrong image")
        }
    }

    convenience init(photo: API.Types.Response.VKPhoto.Res.Item) {
        self.init()

        id = photo.id
        guard let photoURL = photo.sizes.first?.url else {
            self.url = ""
            return
        }
        self.url = photoURL
        let realmSize = photo.sizes.map { size in
            return Size(height: size.height, width: size.width, url: size.url, type: size.type)
        }
        sizes.append(objectsIn: realmSize)
    }
}

class Size: Object {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""

    convenience init(height: Int, width: Int, url: String, type: String) {
        self.init()

        self.height = height
        self.width = width
        self.url = url
        self.type = type
    }
}
