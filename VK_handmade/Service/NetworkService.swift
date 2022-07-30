//
//  NetworkService.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 29.07.2022.
//

import UIKit

protocol NetworkServiceDescription {
    func getFriendList()
    func getUserPhotos(id: String)
    func getUserGroupsList(user id: String)
    func searchGroups(name: String)
}

final class NetworkService: NetworkServiceDescription {
    
    private let baseURL = "api.vk.com"
    private let userID = ApiKey.userID.rawValue
    private let token = ApiKey.vkToken.rawValue
        
    private let configuration = URLSessionConfiguration.default
    private lazy var session = URLSession(configuration: configuration)
    private var urlConstructor = URLComponents()
    private let jsonDecoder = JSONDecoder()
    
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
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
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
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
            }.resume()
        } else {
            print("Error")
        }
    }
    
    func getUserGroupsList(user id: String) {
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: id),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
            }.resume()
        } else {
            print("Error")
        }
    }
    
    func searchGroups(name: String) {
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
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
            }.resume()
        } else {
            print("Error")
        }
    }
}
