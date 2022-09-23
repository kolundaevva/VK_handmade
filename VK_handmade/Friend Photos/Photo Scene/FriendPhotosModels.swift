//
//  FriendPhotosModels.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum FriendPhotos {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getFriendPhotos(id: Int)
            }
        }
        struct Response {
            enum ResponseType {
                case presentFriendPhotos(id: Int)
                case presentError(error: API.Types.Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayFriendPhotos(photos: [Photo])
                case showError(error: API.Types.Error)
            }
        }
    }
    
}
