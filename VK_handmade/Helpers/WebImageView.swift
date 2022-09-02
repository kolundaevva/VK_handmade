//
//  WebImageView.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 30.08.2022.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    
    private var currentImageUrl: String?
    
    func set(url: String?) {
        guard let url = url, let imageURL = URL(string: url) else {
            self.image = nil
            return }
        
        currentImageUrl = url
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let data = data, let response = response {
                DispatchQueue.main.async {
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        task.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentImageUrl {
            self.image = UIImage(data: data)
        }
    }
}
