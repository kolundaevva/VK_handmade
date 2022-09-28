//
//  FriendPhotosPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift

protocol FriendPhotosPresentationLogic {
    func presentData(response: FriendPhotos.Model.Response.ResponseType)
}

class FriendPhotosPresenter: FriendPhotosPresentationLogic {
    weak var viewController: FriendPhotosDisplayLogic?

    func presentData(response: FriendPhotos.Model.Response.ResponseType) {
        switch response {
        case .presentFriendPhotos(id: let id):
            guard let photos = DataManagerImpl.session?.getPhotos(by: id) else { return }
            viewController?.displayData(viewModel: .displayFriendPhotos(photos: photos))

        case .presentError(error: let error):
            viewController?.displayData(viewModel: .showError(error: error))
        }
    }

}
