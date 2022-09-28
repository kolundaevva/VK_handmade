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

    private var revealPostIds: [Int] = []

    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }

        switch request {
        case .getNewsFeed:
            API.NetworkRequestManagerImpl.shared.get(
                .getNewsFeed
            ) { [weak self] (result: Result<API.Types.Response.VKPostData, API.Types.Error>) in
                switch result {
                case .success(let success):
                    guard let feeds = self?.dataConvertor(data: success.response) else { return }
                    UserManagerImpl.session?.saveUserFeedData(feeds)
                    self?.presenter?.presentData(response: .presentNewsFeed(postIds: self?.revealPostIds ?? []))
                case .failure(let failure):
                    self?.presenter?.presentData(response: .presentError(error: failure))
                }
            }

        case .getCachedFeed:
            presenter?.presentData(response: .presentNewsFeed(postIds: revealPostIds))

        case .revealPostIds(postId: let postId):
            revealPostIds.append(postId)
            presenter?.presentData(response: .presentNewsFeed(postIds: revealPostIds))
        }
    }

    private func dataConvertor(data: API.Types.Response.VKPostData.FeedResponse) -> Feed {
        return Feed(feedResponse: data)
    }
}
