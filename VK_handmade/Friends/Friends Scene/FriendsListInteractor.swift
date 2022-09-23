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
    var dataManager: Manager?
    
    func makeRequest(request: FriendsList.Model.Request.RequestType) {
        if service == nil {
          service = FriendsListService()
        }
        
        switch request {
        case .getFriendsList:
            API.Client.shared.get(.getFriendsList) { [weak self] (result: Result<API.Types.Response.VKUser, API.Types.Error>) in
                switch result {
                case .success(let success):
                    let frd = success.response.items
                    self?.dataManager?.saveFriends(frd)
                    self?.presenter?.presentData(response: FriendsList.Model.Response.ResponseType.presentFriendsList)
                    
                case .failure(let failure):
                    self?.presenter?.presentData(response: FriendsList.Model.Response.ResponseType.presentError(error: failure))
                }
            }
        }
    }
    
}
