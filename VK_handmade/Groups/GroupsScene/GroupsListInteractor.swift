//
//  GroupsListInteractor.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 22.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GroupsListBusinessLogic {
    func makeRequest(request: GroupsList.Model.Request.RequestType)
}

class GroupsListInteractor: GroupsListBusinessLogic {
    var presenter: GroupsListPresentationLogic?
    var service: GroupsListService?
    var dataManager: Manager?

    func makeRequest(request: GroupsList.Model.Request.RequestType) {
        if service == nil {
            service = GroupsListService()
        }

        switch request {
        case .getGroupsList:
            API.Client.shared.get(
                .getUserGroupsList
            ) { [weak self] (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
                switch result {
                case .success(let success):
                    let grp = success.response.items
                    self?.dataManager?.saveUserGroupsData(grp)
                    self?.presenter?.presentData(response: .presentGroupsList)

                case .failure(let failure):
                    self?.presenter?.presentData(response: .presentError(error: failure))
                }
            }
        }
    }
}
