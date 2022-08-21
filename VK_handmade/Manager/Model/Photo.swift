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
    
    convenience init(photo: API.Types.Response.VKPhoto.Res.Item) {
        self.init()
        
        id = photo.id
        guard let photoURL = photo.sizes.first?.url else {
            self.url = ""
            return
        }
        self.url = photoURL
    }
}
