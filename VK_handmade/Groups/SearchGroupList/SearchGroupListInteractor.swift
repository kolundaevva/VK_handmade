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
//        if service == nil {
//            service = SearchGroupListService()
//        }
        
//        switch request {
//        case .getGroupsList:
//            API.Client.shared.get(.getUserGroupsList) { [weak self] (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
//                switch result {
//                case .success(let success):
//                    let groups = success.response.items.map { groupData in
//                        Group(group: groupData)
//                    }
//
//                    self?.presenter?.presentData(response: .presentGroupsList(groups: groups))
//
//                case .failure(let failure):
//                    self?.presenter?.presentData(response: .presentError(error: failure))
//                }
//            }
//        }
    }
    
}
