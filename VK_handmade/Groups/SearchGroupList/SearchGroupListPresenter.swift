//
//  SearchGroupListPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 23.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchGroupListPresentationLogic {
    func presentData(response: SearchGroupList.Model.Response.ResponseType)
}

class SearchGroupListPresenter: SearchGroupListPresentationLogic {
    
    weak var viewController: SearchGroupListDisplayLogic?
    
    func presentData(response: SearchGroupList.Model.Response.ResponseType) {
//        switch response {
//        case .presentGroupsList(groups: let groups):
//            let cells = groups.map { group in
//                cellViewModel(from: group)
//            }
//            let groupsCells = GroupViewModel.init(cells: cells)
//            viewController?.displayData(viewModel: .displayGroupsList(groups: groupsCells))
//            
//        case .presentError(error: let error):
//            viewController?.displayData(viewModel: .showError(error: error))
//        }
    }
    
    private func cellViewModel(from group: Group) -> GroupViewModel.Cell {
        return GroupViewModel.Cell.init(id: group.id,
                                        name: group.name,
                                        photo: group.photo)
    }
}
