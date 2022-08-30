//
//  WebImageView.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 30.08.2022.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    func set(url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)) {
            self.image = UIImage(data: cachedResponse.data)
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let data = data, let response = response {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
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
    }
}
