//
//  Extension.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.07.2022.
//

import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        if URLAddress == url.absoluteString {                        
                            self?.image = loadedImage
                        }
                    }
                }
            }
        }
    }
}
