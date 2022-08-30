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
    
    let cellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol = NewsfeedCellLayoutCalculator()
    private let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed(success: let success):
            let cells = success.response.items.map { item in
                cellViewModel(from: item, profiles: success.response.profiles, groups: success.response.groups)
            }
            
            let feedCells = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsFeed(feed: feedCells))
        case .presentError(error: let error):
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.showError(error: error))
        }
    }
    
    private func cellViewModel(from item: API.Types.Response.VKPostData.FeedResponse.VKPost, profiles: [API.Types.Response.VKUser.UserResponse.VKFriend], groups: [API.Types.Response.VKGroupData.GroupResponse.VKGroup]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: item.sourceId, profiles: profiles, groups: groups)
        let photoAttechment = self.photoAttechment(feed: item)
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        let sizes = cellLayoutCalculator.sizes(postText: item.text, attechment: photoAttechment)
        
        return FeedViewModel.Cell.init(iconUrl: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: item.text,
                                       likes: String(item.likes?.count ?? 0),
                                       comments: String(item.comments?.count ?? 0),
                                       views: String(item.views?.count ?? 0),
                                       attechment: photoAttechment,
                                       sizes: sizes)
    }
    
    private func profile(for sourceId: Int, profiles: [API.Types.Response.VKUser.UserResponse.VKFriend], groups: [API.Types.Response.VKGroupData.GroupResponse.VKGroup]) -> ProfileRepsentable {
        let profilesOrGrpoups: [ProfileRepsentable] = sourceId >= 0 ? profiles : groups
        let id = abs(sourceId)
        let profileRepsentable = profilesOrGrpoups.first { $0.id == id }
        return profileRepsentable!
    }
    
    private func photoAttechment(feed: API.Types.Response.VKPostData.FeedResponse.VKPost) -> FeedViewModel.FeedCellPhotoAttechment? {
        guard let photo = feed.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photo.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: firstPhoto.srcBIG, height: firstPhoto.height, width: firstPhoto.width)
    }
}
