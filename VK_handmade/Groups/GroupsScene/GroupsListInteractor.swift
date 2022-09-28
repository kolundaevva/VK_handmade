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

    func makeRequest(request: GroupsList.Model.Request.RequestType) {
        if service == nil {
            service = GroupsListService()
        }

        switch request {
        case .getGroupsList:
            API.NetworkRequestManagerImpl.shared.get(
                .getUserGroupsList
            ) { [weak self] (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
                switch result {
                case .success(let success):
                    guard let groups = self?.dataConvertor(data: success.response.items) else { return }
                    UserManagerImpl.session?.saveUserGroupsData(groups)
                    self?.presenter?.presentData(response: .presentGroupsList)

                case .failure(let failure):
                    self?.presenter?.presentData(response: .presentError(error: failure))
                }
            }

        case .getCachedGroups:
            presenter?.presentData(response: .presentGroupsList)
        }
    }

    private func dataConvertor(data: [API.Types.Response.VKGroupData.GroupResponse.VKGroup]) -> [Group] {
        return data.map { Group(group: $0) }
    }
}
