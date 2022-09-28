//
//  GroupsListPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 22.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GroupsListPresentationLogic {
    func presentData(response: GroupsList.Model.Response.ResponseType)
}

class GroupsListPresenter: GroupsListPresentationLogic {
    weak var viewController: GroupsListDisplayLogic?

    func presentData(response: GroupsList.Model.Response.ResponseType) {
        switch response {
        case .presentGroupsList:
            guard let groups = DataManagerImpl.session?.getGroups() else { return }

            let cellsList = groups.map { group in
                self.cellViewModel(from: group)
            }
            let cells = Array(cellsList)
            let groupsCells = GroupViewModel.init(cells: cells)

            viewController?.displayData(viewModel: .displayGroupsList(groups: groupsCells))

        case .presentError(error: let error):
            viewController?.displayData(viewModel: .showError(error: error))
        }
    }

    private func cellViewModel(from group: Group) -> GroupViewModel.Cell {
        return GroupViewModel.Cell.init(id: group.id,
                                        name: group.name,
                                        photo: group.photo)
    }
}
