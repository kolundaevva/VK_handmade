//
//  FriendsListInteractor.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FriendsListBusinessLogic {
    func makeRequest(request: FriendsList.Model.Request.RequestType)
}

class FriendsListInteractor: FriendsListBusinessLogic {
    var presenter: FriendsListPresentationLogic?
    var service: FriendsListService?

    func makeRequest(request: FriendsList.Model.Request.RequestType) {
        if service == nil {
          service = FriendsListService()
        }

        switch request {
        case .getFriendsList:
            API.NetworkRequestManagerImpl.shared.get(
                .getFriendsList
            ) { [weak self] (result: Result<API.Types.Response.VKUser, API.Types.Error>) in
                switch result {
                case .success(let success):
                    guard let friends = self?.dataConvertor(data: success.response.items) else { return }
                    UserManagerImpl.session?.saveFriends(friends)
                    self?.presenter?.presentData(response: .presentFriendsList)

                case .failure(let failure):
                    self?.presenter?.presentData(response: .presentError(error: failure))
                }
            }
        case .getCachedFriends:
            presenter?.presentData(response: .presentFriendsList)
        }
    }

    private func dataConvertor(data: [API.Types.Response.VKUser.UserResponse.VKFriend]) -> [Friend] {
        return data.map { Friend(user: $0) }
    }
}
