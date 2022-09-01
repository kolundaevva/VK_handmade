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
  
    private var response: API.Types.Response.VKPostData?
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
                  self?.response = success
                  self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(success: success, postIds: self?.revealPostIds ?? []))
              case .failure(let failure):
                  self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentError(error: failure))
              }
          }
      case .revealPostIds(postId: let postId):
          revealPostIds.append(postId)
          guard let response = response else { return }
          presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(success: response, postIds: revealPostIds))
      }
  }
  
}
