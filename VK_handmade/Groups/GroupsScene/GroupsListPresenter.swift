//
//  GroupsListPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 22.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift

protocol GroupsListPresentationLogic {
    func presentData(response: GroupsList.Model.Response.ResponseType)
}

class GroupsListPresenter: GroupsListPresentationLogic {
    weak var viewController: GroupsListDisplayLogic?

    func presentData(response: GroupsList.Model.Response.ResponseType) {
        switch response {
        case .presentGroupsList:
            guard let realm = try? Realm(),
                  let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }
            let groups = user.groups

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
