//
//  FriendsListModels.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum FriendsList {
    enum Model {
        struct Request {
            enum RequestType {
                case getFriendsList
                case getCachedFriends
            }
        }
        struct Response {
            enum ResponseType {
                case presentFriendsList
                case presentError(error: API.Types.Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayFriendsList(friends: FriendViewModel)
                case showError(error: API.Types.Error)
            }
        }
    }
}

struct FriendViewModel {
    struct Cell: ProfileRepsentable {
        var id: Int
        var name: String
        var photo: String
    }

    var cells: [Cell]
}
