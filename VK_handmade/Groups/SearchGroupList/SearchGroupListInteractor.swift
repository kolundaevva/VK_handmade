//
//  SearchGroupListInteractor.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 23.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchGroupListBusinessLogic {
    func makeRequest(request: SearchGroupList.Model.Request.RequestType)
}

class SearchGroupListInteractor: SearchGroupListBusinessLogic {
    var presenter: SearchGroupListPresentationLogic?
    var service: SearchGroupListService?

    func makeRequest(request: SearchGroupList.Model.Request.RequestType) {
    }
}
