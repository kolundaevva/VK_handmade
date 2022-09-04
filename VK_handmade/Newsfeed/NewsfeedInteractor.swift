//
//  NewsfeedInteractor.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
    var dataManager: Manager?
  
    private var revealPostIds: [Int] = []
    
  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
      
      switch request {
      case .getNewsFeed:
          API.Client.shared.get(.getNewsFeed) { [weak self] (result: Result<API.Types.Response.VKPostData, API.Types.Error>) in
              switch result {
              case .success(let success):
                  self?.dataManager?.saveUserFeedData(success.response)
                  self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(postIds: self?.revealPostIds ?? []))
              case .failure(let failure):
                  self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentError(error: failure))
                  self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(postIds: self?.revealPostIds ?? []))
              }
          }
      case .revealPostIds(postId: let postId):
          revealPostIds.append(postId)
          presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(postIds: revealPostIds))
      }
  }
  
}
