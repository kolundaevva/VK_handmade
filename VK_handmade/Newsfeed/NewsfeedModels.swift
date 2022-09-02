//
//  NewsfeedModels.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Newsfeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case revealPostIds(postId: Int)
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(success: API.Types.Response.VKPostData, postIds: [Int])
                case presentError(error: API.Types.Error)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(feed: FeedViewModel)
                case showError(error: API.Types.Error)
            }
        }
    }
    
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconUrl: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var views: String?
        var attechments: [FeedCellAttechmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttechment: FeedCellAttechmentViewModel {
        var photoUrlString: String
        var height: Int
        var width: Int
    }
    
    var cells: [Cell]
}
