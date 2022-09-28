//
//  FriendPhotosInteractor.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FriendPhotosBusinessLogic {
    func makeRequest(request: FriendPhotos.Model.Request.RequestType)
}

class FriendPhotosInteractor: FriendPhotosBusinessLogic {

    var presenter: FriendPhotosPresentationLogic?
    var service: FriendPhotosService?

    func makeRequest(request: FriendPhotos.Model.Request.RequestType) {
        if service == nil {
            service = FriendPhotosService()
        }

        switch request {
        case .getFriendPhotos(id: let id):
            let stringId = String(id)

            API.NetworkRequestManagerImpl.shared.get(
                .getUserPhotos(id: stringId)
            ) { [weak self] (result: Result<API.Types.Response.VKPhoto, API.Types.Error>) in
                switch result {
                case .success(let success):
                    guard let photos = self?.dataConvertor(data: success.response.items) else { return }
                    UserManagerImpl.session?.saveUserPhotosData(photos, id: id)
                    self?.presenter?.presentData(response: .presentFriendPhotos(id: id))

                case .failure(let failure):
                    self?.presenter?.presentData(response: .presentError(error: failure))
                }
            }

        case .getCachedPhotos(id: let id):
            presenter?.presentData(response: .presentFriendPhotos(id: id))
        }
    }

    private func dataConvertor(data: [API.Types.Response.VKPhoto.Res.Item]) -> [Photo] {
        return data.map { Photo(photo: $0) }
    }
}
