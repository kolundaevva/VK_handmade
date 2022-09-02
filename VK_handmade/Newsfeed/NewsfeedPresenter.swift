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
        case .presentNewsFeed(success: let success, postIds: let postIds):
            let cells = success.response.items.map { item in
                cellViewModel(from: item, profiles: success.response.profiles, groups: success.response.groups, postIds: postIds)
            }
            
            let feedCells = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsFeed(feed: feedCells))
        case .presentError(error: let error):
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.showError(error: error))
        }
    }
    
    private func cellViewModel(from item: API.Types.Response.VKPostData.FeedResponse.VKPost, profiles: [API.Types.Response.VKUser.UserResponse.VKFriend], groups: [API.Types.Response.VKGroupData.GroupResponse.VKGroup], postIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: item.sourceId, profiles: profiles, groups: groups)
//        let photoAttechment = self.photoAttechment(feed: item)
        let photoAttechments = self.photoAttechments(feed: item)
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        let isFullSize = postIds.contains(item.postId)
        let sizes = cellLayoutCalculator.sizes(postText: item.text, attechments: photoAttechments, isFullSize: isFullSize)
        
        return FeedViewModel.Cell.init(postId: item.postId,
                                       iconUrl: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: item.text,
                                       likes: formattedCounter(item.likes?.count),
                                       comments: formattedCounter(item.comments?.count),
                                       views: formattedCounter(item.views?.count),
                                       attechments: photoAttechments,
                                       sizes: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var stringCounter = String(counter)
        
        if 4...6 ~= stringCounter.count {
            stringCounter = String(stringCounter.dropLast(3)) + "K"
        } else if stringCounter.count > 6 {
            stringCounter = String(stringCounter.dropLast(6)) + "M"
        }
        
        return stringCounter
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
    
    private func photoAttechments(feed: API.Types.Response.VKPostData.FeedResponse.VKPost) -> [FeedViewModel.FeedCellPhotoAttechment] {
        guard let attechments = feed.attachments else { return [] }
        
        return attechments.compactMap { attechment in
            guard let photo = attechment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: photo.srcBIG, height: photo.height, width: photo.width)
        }
    }
}
