//
//  FriendTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    
    private var URLAddress = ""
    
    func configure(with friend: Friend) {
        friendName.text = "\(friend.firstName) \(friend.lastName)"
        URLAddress = friend.photo
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
                            self?.friendImage.image = loadedImage
                        }
                    }
                }
            }
        }
    }
}
