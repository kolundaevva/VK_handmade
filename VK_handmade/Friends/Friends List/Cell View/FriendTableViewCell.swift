//
//  FriendTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendImage: WebImageView!
    
    func configure(with friend: Friend) {
        friendName.text = "\(friend.firstName) \(friend.lastName)"
        friendImage.set(url: friend.photo)
    }
}
