//
//  GalleryViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.09.2022.
//

import Foundation
import UIKit

class GalleryViewCell: UICollectionViewCell {
    let imageView: WebImageView = {
       let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.9117177725, green: 0.918438971, blue: 0.927837193, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        //imageView contraints
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        imageView.set(url: nil)
    }
    
    func configure(photoUrl: String?) {
        imageView.set(url: photoUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
