//
//  GroupsListModels.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 22.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum GroupsList {
    enum Model {
        struct Request {
            enum RequestType {
                case getGroupsList
                case getCachedGroups
            }
        }
        struct Response {
            enum ResponseType {
                case presentGroupsList
                case presentError(error: API.Types.Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayGroupsList(groups: GroupViewModel)
                case showError(error: API.Types.Error)
            }
        }
    }
}

struct GroupViewModel {
    struct Cell: ProfileRepsentable {
        var id: Int
        var name: String
        var photo: String
    }

    var cells: [Cell]
}
