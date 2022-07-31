//
//  PhotoCollectionViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with photo: Size) {
        photoView.loadFrom(URLAddress: photo.url)
    }
}
