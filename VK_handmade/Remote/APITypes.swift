//
//  APITypes.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 20.08.2022.
//

import Foundation

extension API {
    enum Types {
        enum Response {
            //MARK: - Models
            
            //VK User model
            class VKUser: Codable {
                let response: Res
                
                init(response: Res) {
                    self.response = response
                }
                
                class Res: Codable {
                    let items: [VKFriend]
                    
                    init(items: [VKFriend]) {
                        self.items = items
                    }
                    
                    class VKFriend: Codable {
                        let id: Int
                        let photo: String
                        let firstName, lastName: String
                        
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
                let response: Answer
                
                class Answer: Codable {
                    let items: [VKGroup]
                    
                    class VKGroup: Codable {
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

                        enum CodingKeys: String, CodingKey {
                            case id
                            case ownerID = "owner_id"
                            case sizes
                        }
                        
                        class Size: Codable {
                            let height: Int
                            let url: String
                            let type: String
                            let width: Int

                        }
                    }
                }
            }
            
            //VK Post Model
            
            class VKPostData: Codable {
                let response: Res
                
                class Res: Codable {
                    let items: [VKPost]
                    let groups: [VKGroupData.Answer.VKGroup]
                    
                    class VKPost: Codable {
                        let sourceId: Int
                        let date: Date
                        let type: String
                        let text: String
                        let history: [History]?
                        let attachments: [VKPostInfo]?
                        
                        class History: Codable {
                            let id: Int
                            let ownerId: Int
                            let attachments: [VKPostInfo]
                            
                            enum CodingKeys: String, CodingKey {
                                case id
                                case ownerId = "owner_id"
                                case attachments
                            }
                        }
                        
                        class VKPostInfo: Codable {
                            let type: String
                            let photo: VKPhoto.Res.Item?
                            let audio: VKAudio?
                            
                            class VKAudio: Codable {
                                let id: Int
                                let artist: String
                                let title: String
                                let url: String
                            }
                        }
                        
                        enum CodingKeys: String, CodingKey {
                            case sourceId = "source_id"
                            case type = "post_type"
                            case history = "copy_history"
                            case date, text, attachments
                        }
                        
                    }
                }
            }
            
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
