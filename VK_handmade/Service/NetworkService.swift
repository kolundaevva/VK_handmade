//
//  NetworkService.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 29.07.2022.
//

import UIKit
import RealmSwift

protocol NetworkServiceDescription {
    func getFriendList()
    func getUserPhotos(id: String)
    func getUserGroupsList()
    func searchGroups(name: String, completion: @escaping ([Group]) -> Void)
    func joinGroup(id: Int)
    func getNewsFeed()
}

final class NetworkService: NetworkServiceDescription {
    private let baseURL = "api.vk.com"
    private let userID = ApiKey.session.userId
    private let token = ApiKey.session.token
        
    private let configuration = URLSessionConfiguration.default
    private lazy var session = URLSession(configuration: configuration)
    private var urlConstructor = URLComponents()
    private let jsonDecoder = JSONDecoder()
    private let dataManager: Manager = DataManager()
    
    func getFriendList() {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
                session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let data = data else { return }
                        do {
                            guard let friends = try self?.jsonDecoder.decode(VKUser.self, from: data).response.items else { return }
                            self?.dataManager.saveFriends(friends)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
        } else {
            print("Error")
        }
    }
    
    func getUserPhotos(id: String) {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/photos.getAll"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: id),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
                session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let data = data else { return }
                        do {
                            guard let result = try self?.jsonDecoder.decode(VKPhoto.self, from: data).response.items else { return }
                            self?.dataManager.saveUserPhotosData(result, pk: id)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
        } else {
            print("Error")
        }
    }
    
    func getUserGroupsList() {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
                session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let data = data else { return }
                        do {
                            guard let result = try self?.jsonDecoder.decode(GroupData.self, from: data).response.items else { return }
                            self?.dataManager.saveUserGroupsData(result)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
        } else {
            print("Error")
        }
    }
    
    func searchGroups(name: String, completion: @escaping ([Group]) -> Void) {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = data else { return }
                    do {
                        guard let VKGroups = try self?.jsonDecoder.decode(GroupData.self, from: data).response.items else { return }
                        let groups = VKGroups.map { Group(group: $0) }
                        completion(groups)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                }.resume()
        } else {
            print("Error")
        }
    }
    
    func joinGroup(id: Int) {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.join"
        urlConstructor.queryItems = [
            URLQueryItem(name: "group_id", value: "\(id)"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
    }
    
    func getNewsFeed() {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/newsfeed.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            session.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                print(url)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = data else { return }
                    do {
                        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        //                        print(json)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        } else {
            print("Error")
        }
    }
}
