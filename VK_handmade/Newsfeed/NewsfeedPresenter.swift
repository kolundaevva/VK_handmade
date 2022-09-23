//
//  NewsfeedPresenter.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift

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
        case .presentNewsFeed(postIds: let postIds):
            guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: ApiKey.session.userId) else { return }
            guard let response = user.feeds.first else { return }
            let groups = realm.objects(Group.self)
            let users = realm.objects(Friend.self)

            let cellsList = response.feed.map { feed -> FeedViewModel.Cell in
                return self.cellViewModel(from: feed, profiles: Array(users), groups: Array(groups), postIds: postIds)
            }
            
            let cells = Array(cellsList)
            let feedCells = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsFeed(feed: feedCells))
        case .presentError(error: let error):
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.showError(error: error))
        }
    }
    
    private func cellViewModel(from item: FeedResponse, profiles: [Friend], groups: [Group], postIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: item.sourceId, profiles: profiles, groups: groups)
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
                                       likes: formattedCounter(item.likes),
                                       comments: formattedCounter(item.comments),
                                       views: formattedCounter(item.views),
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
    
    private func profile(for sourceId: Int, profiles: [Friend], groups: [Group]) -> ProfileRepsentable {
        let profilesOrGrpoups: [ProfileRepsentable] = sourceId >= 0 ? profiles : groups
        let id = abs(sourceId)
        let profileRepsentable = profilesOrGrpoups.first { $0.id == id }
        return profileRepsentable!
    }
    
    private func photoAttechments(feed: FeedResponse) -> [FeedViewModel.FeedCellPhotoAttechment] {

        return feed.photos.map { photo in
            return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: photo.srcBIG, height: photo.height, width: photo.width)
        }
    }
}
