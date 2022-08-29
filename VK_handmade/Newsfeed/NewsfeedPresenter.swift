//
//  NewsfeedPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed(success: let success):
            let cells = success.response.items.map { item in
                cellViewModel(from: item)
            }
            
            let feedCells = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsFeed(feed: feedCells))
        case .presentError(error: let error):
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.showError(error: error))
        }
    }
    
    private func cellViewModel(from item: API.Types.Response.VKPostData.FeedResponse.VKPost ) -> FeedViewModel.Cell {
        let cell = FeedViewModel.Cell.init(iconUrl: "",
                                           name: "test name",
                                           date: "some date",
                                           text: item.text,
                                           likes: String(item.likes?.count ?? 0),
                                           comments: String(item.comments?.count ?? 0),
                                           views: String(item.views?.count ?? 0))
        return cell
    }
}
