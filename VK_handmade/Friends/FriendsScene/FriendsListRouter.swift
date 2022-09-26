//
//  FriendsListRouter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FriendsListRoutingLogic {
    func routeToFriendPhotos(segue: UIStoryboardSegue?)
}

class FriendsListRouter: NSObject, FriendsListRoutingLogic {

    weak var viewController: FriendsListViewController?

    // MARK: Routing
    func routeToFriendPhotos(segue: UIStoryboardSegue?) {
        if let segue = segue {
            guard let photosVC = segue.destination as? FriendPhotosViewController else { return }

            passDataToFriendPhotos(destination: photosVC)
        }
    }

    private func passDataToFriendPhotos(destination: FriendPhotosViewController) {
        if let selectedIndexPath = viewController?.tableView.indexPathForSelectedRow {
            if let id = viewController?.friendsViewModel.cells[selectedIndexPath.row].id {
                destination.id = id
            }
        }
    }
}
