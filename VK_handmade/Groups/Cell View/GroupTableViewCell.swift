//
//  GroupTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    private var URLAddress = ""
    
    func configure(with group: Group) {
        groupName.text = group.name
        URLAddress = group.photo
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
                            self?.groupImage.image = loadedImage
                        }
                    }
                }
            }
        }
    }
}
