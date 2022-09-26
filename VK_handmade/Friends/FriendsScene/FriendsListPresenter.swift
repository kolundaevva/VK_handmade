//
//  FriendsListPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift
protocol FriendsListPresentationLogic {
    func presentData(response: FriendsList.Model.Response.ResponseType)
}

class FriendsListPresenter: FriendsListPresentationLogic {
    weak var viewController: FriendsListDisplayLogic?

    func presentData(response: FriendsList.Model.Response.ResponseType) {
        switch response {
        case .presentFriendsList:
            guard let realm = try? Realm(),
                  let user = realm.object(
                    ofType: User.self,
                    forPrimaryKey: ApiKey.session.userId
                  ) else { return }
            let friends = user.friends

            let cellsList = friends.map { friend in
                self.cellViewModel(from: friend)
            }
            let cells = Array(cellsList)
            let friendsCells = FriendViewModel.init(cells: cells)

            viewController?.displayData(viewModel: .displayFriendsList(friends: friendsCells))

        case .presentError(error: let error):
            viewController?.displayData(viewModel: .showError(error: error))
        }
    }

    private func cellViewModel(from friend: Friend) -> FriendViewModel.Cell {
        return FriendViewModel.Cell.init(id: friend.id,
                                         name: friend.name,
                                         photo: friend.photo)
    }
}
