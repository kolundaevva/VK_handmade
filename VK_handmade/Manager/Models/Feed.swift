//
//  Feed.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 02.09.2022.
//

import Foundation
import RealmSwift

class Feed: Object {
    var feed = List<FeedResponse>()
    var groups = List<Group>()
    var users = List<Friend>()
    
    convenience init(feedResponse: API.Types.Response.VKPostData.FeedResponse) {
        self.init()
        
        let realmFeed = feedResponse.items.map { response in
            return FeedResponse(feedResponse: response)
        }
        
        self.feed.append(objectsIn: realmFeed)
        
        let realmGroups = feedResponse.groups.map { group in
            return Group(group: group)
        }
        
        self.groups.append(objectsIn: realmGroups)
        
        let realmUsers = feedResponse.profiles.map { user in
            return Friend(user: user)
        }
        
        self.users.append(objectsIn: realmUsers)
    }
}

class FeedResponse: Object {
    @objc dynamic var postId = 0
    @objc dynamic var sourceId = 0
    @objc dynamic var date = 0.0
    @objc dynamic var text: String? = ""
    @objc dynamic var likes = 0
    @objc dynamic var comments = 0
    @objc dynamic var views = 0
    var photos = List<Photo>()
    
    override class func primaryKey() -> String? {
        "postId"
    }
    
    convenience init(feedResponse: API.Types.Response.VKPostData.FeedResponse.VKPost) {
        self.init()
        
        postId = feedResponse.postId
        sourceId = feedResponse.sourceId
        date = feedResponse.date
        text = feedResponse.text
        likes = feedResponse.likes?.count ?? 0
        comments = feedResponse.comments?.count ?? 0
        views = feedResponse.views?.count ?? 0
        
        var realmPhotos = [Photo]()
        
        feedResponse.attachments?.forEach { attachment in
            guard let photo = attachment.photo else { return }
            realmPhotos.append(Photo(photo: photo))
        }
        
        self.photos.append(objectsIn: realmPhotos)
    }
}
