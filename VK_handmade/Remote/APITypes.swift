//
//  APITypes.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 20.08.2022.
//

import Foundation

protocol ProfileRepsentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

extension API {
    enum Types {
        enum Response {
            //MARK: - Models
            
            //VK User model
            class VKUser: Codable {
                let response: UserResponse
                
                init(response: UserResponse) {
                    self.response = response
                }
                
                class UserResponse: Codable {
                    let items: [VKFriend]
                    
                    init(items: [VKFriend]) {
                        self.items = items
                    }
                    
                    class VKFriend: Codable, ProfileRepsentable {
                        let id: Int
                        let photo: String
                        let firstName, lastName: String
                        var name: String { firstName + " " + lastName }
                        
                        enum CodingKeys: String, CodingKey {
                            case id
                            case photo = "photo_50"
                            case firstName = "first_name"
                            case lastName = "last_name"
                        }
                        
                        init(id: Int, photo: String, firstName: String, lastName: String) {
                            self.id = id
                            self.photo = photo
                            self.firstName = firstName
                            self.lastName = lastName
                        }
                    }
                }
            }
            
            //VK Group model
            class VKGroupData: Codable {
                let response: GroupResponse
                
                class GroupResponse: Codable {
                    let items: [VKGroup]
                    
                    class VKGroup: Codable, ProfileRepsentable {
                        let id: Int
                        let name: String
                        let photo: String
                        
                        enum CodingKeys: String, CodingKey {
                            case id, name
                            case photo = "photo_50"
                        }
                    }
                }
            }
            
            //VK Photo model
            class VKPhoto: Codable {
                let response: Res
                
                class Res: Codable {
                    let items: [Item]

                    init(items: [Item]) {
                        self.items = items
                    }
                    
                    class Item: Codable {
                        let id, ownerID: Int
                        let sizes: [Size]
                        
                        var height: Int {
                            return getPropperSize().height
                        }
                        
                        var width: Int {
                            return getPropperSize().width
                        }
                        
                        var srcBIG: String {
                            return getPropperSize().url
                        }
                        
                        private func getPropperSize() -> Size {
                            if let sizeX = sizes.first(where: { $0.type == "x" }) {
                                return sizeX
                            } else if let fallBackSize = sizes.last {
                                return fallBackSize
                            } else {
                                return Size(height: 0, width: 0, url: "", type: "wrong image")
                            }
                        }
                        
                        enum CodingKeys: String, CodingKey {
                            case id
                            case ownerID = "owner_id"
                            case sizes
                        }
                        
                        class Size: Codable {
                            let height: Int
                            let width: Int
                            let url: String
                            let type: String
                            
                            init(height: Int, width: Int, url: String, type: String) {
                                self.height = height
                                self.width = width
                                self.url = url
                                self.type = type
                            }
                        }
                    }
                }
            }
            
            //VK Post Model
            
            class VKPostData: Codable {
                let response: FeedResponse
                
                class FeedResponse: Codable {
                    let items: [VKPost]
                    let groups: [VKGroupData.GroupResponse.VKGroup]
                    let profiles: [VKUser.UserResponse.VKFriend]
                    let nextFrom: String?
                    
                    class VKPost: Codable {
                        let sourceId: Int
                        let postId: Int
                        let date: Double
                        let type: String
                        let text: String?
                        let attachments: [Attechment]?
                        let comments: CountableItem?
                        let likes: CountableItem?
                        let views: CountableItem?
                        
                        class Attechment: Codable {
                            let photo: VKPhoto.Res.Item?
                        }
                        
                        class CountableItem: Codable {
                            let count: Int
                        }
                        
                        enum CodingKeys: String, CodingKey {
                            case sourceId = "source_id"
                            case postId = "post_id"
                            case type = "post_type"
                            case date, text, attachments
                            case comments, likes, views
                        }
                        
                    }
                }
            }
            
            class Empty: Decodable { }
        }
        
        enum Request {
            struct Empty: Encodable {}
        }
        
        enum Error: LocalizedError {
            case generic(reason: String)
            case `iternal`(reason: String)
            
            var errorDescription: String? {
                switch self {
                case .generic(reason: let reason):
                    return reason
                case .iternal(reason: let reason):
                    return "Internal Error: \(reason)"
                }
            }
        }
        
        enum Endpoint {
            case getFriendsList
            case getUserPhotos(id: String)
            case getUserGroupsList
            case searchGroups(name: String)
            case joinGroup(id: Int)
            case getNewsFeed
            
            var url: URL {
                let userID = ApiKey.session.userId
                let token = ApiKey.session.token
                var urlConstructor = URLComponents()
                urlConstructor.scheme = "https"
                urlConstructor.host = "api.vk.com"
                
                switch self {
                case .getFriendsList:
                    urlConstructor.path = "/method/friends.get"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "user_id", value: userID),
                        URLQueryItem(name: "fields", value: "photo_50"),
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                case .getUserPhotos(let id):
                    urlConstructor.path = "/method/photos.getAll"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "owner_id", value: id),
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                case .getUserGroupsList:
                    urlConstructor.path = "/method/groups.get"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "user_id", value: userID),
                        URLQueryItem(name: "extended", value: "1"),
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                case .searchGroups(let name):
                    urlConstructor.path = "/method/groups.search"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "q", value: name),
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                case .joinGroup(let id):
                    urlConstructor.path = "/method/groups.join"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "group_id", value: "\(id)"),
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                case .getNewsFeed:
                    urlConstructor.path = "/method/newsfeed.get"
                    urlConstructor.queryItems = [
                        URLQueryItem(name: "access_token", value: token),
                        URLQueryItem(name: "filters", value: "post,photo"),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
                }
                
                return urlConstructor.url!
            }
        }
        
        enum Method: String {
            case get
        }
    }
}
