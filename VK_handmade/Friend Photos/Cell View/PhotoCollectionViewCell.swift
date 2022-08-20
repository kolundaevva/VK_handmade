//
//  PhotoCollectionViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!
    private var URLAddress = ""

    func configure(with photo: Photo) {
        URLAddress = photo.url
        updateUI()
    }
    
    private func updateUI() {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        if self?.URLAddress == url.absoluteString {
                            self?.photoView.image = loadedImage
                        }
                    }
                }
            }
        }
    }
}

