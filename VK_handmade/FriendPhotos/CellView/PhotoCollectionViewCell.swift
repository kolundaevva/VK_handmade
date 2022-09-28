//
//  PhotoCollectionViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var photoView: WebImageView!

    func configure(with photo: Photo) {
        photoView.set(url: photo.url)
    }
}
