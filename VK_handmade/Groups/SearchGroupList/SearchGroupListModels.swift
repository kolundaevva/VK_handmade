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
            }
        }
        struct Response {
            enum ResponseType {
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showError(error: API.Types.Error)
            }
        }
    }
}
