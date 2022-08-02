//
//  NetworkService.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 29.07.2022.
//

import UIKit

protocol NetworkServiceDescription {
    func getFriendList(completion: @escaping () -> Void)
    func getUserPhotos(id: String, completion: @escaping () -> Void)
    func getUserGroupsList(completion: @escaping () -> Void)
    func searchGroups(name: String, completion: @escaping () -> Void)
}

final class NetworkService: NetworkServiceDescription {
    private let baseURL = "api.vk.com"
    private let userID = ApiKey.userID.rawValue
    private let token = ApiKey.vkToken.rawValue
    private let photosToken = ApiKey.photosToken.rawValue
        
    private let configuration = URLSessionConfiguration.default
    private lazy var session = URLSession(configuration: configuration)
    private var urlConstructor = URLComponents()
    private let jsonDecoder = JSONDecoder()
    private let dataManager: Manager = DataManager()
    
    func getFriendList(completion: @escaping () -> Void) {
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
            DispatchQueue.main.async { [weak self] in
                self?.session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let data = data else { return }
                    do {
                        guard let users = try self?.jsonDecoder.decode(VKUser.self, from: data).response.items else { return }
                        self?.dataManager.saveFriends(users, pk: self!.userID)
                        completion()
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        } else {
            print("Error")
        }
    }
    
    func getUserPhotos(id: String, completion: @escaping () -> Void) {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/photos.getAll"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: id),
            URLQueryItem(name: "access_token", value: photosToken),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async { [weak self] in
                self?.session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let data = data else { return }
                    
                    do {
                        guard let result = try self?.jsonDecoder.decode(VKPhoto.self, from: data).response.items else { return }
                        self?.dataManager.saveUserPhotosData(result, pk: id)
                        completion()
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        } else {
            print("Error")
        }
    }
    
    func getUserGroupsList(completion: @escaping () -> Void) {
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
            DispatchQueue.main.async { [weak self] in
                self?.session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let data = data else { return }
                    do {
                        guard let result = try self?.jsonDecoder.decode(GroupData.self, from: data).response.items else { return }
                        self?.dataManager.saveUserGroupsData(result, pk: self!.userID)
                        completion()
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        } else {
            print("Error")
        }
    }
    
    func searchGroups(name: String, completion: @escaping () -> Void) {
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
            DispatchQueue.main.async { [weak self] in
                self?.session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let data = data else { return }
                    do {
//                        guard let groups = try self?.jsonDecoder.decode(GroupData.self, from: data).response.items else { return }
//                        self.dataManager.sa
                        completion()
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        } else {
            print("Error")
        }
    }
}
