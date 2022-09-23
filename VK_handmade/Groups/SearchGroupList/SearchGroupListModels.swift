//
//  SearchGroupListModels.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 23.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SearchGroupList {
    
    enum Model {
        struct Request {
            enum RequestType {
//                case getGroupsList
            }
        }
        struct Response {
            enum ResponseType {
//                case presentGroupsList(groups: [Group])
//                case presentError(error: API.Types.Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
//                case displayGroupsList(groups: GroupViewModel)
                case showError(error: API.Types.Error)
            }
        }
    }
    
}
