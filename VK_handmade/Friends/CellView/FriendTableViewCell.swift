//
//  FriendTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var friendName: UILabel!
    @IBOutlet private weak var friendImage: WebImageView!

    func configure(with friend: ProfileRepsentable) {
        friendName.text = friend.name
        friendImage.set(url: friend.photo)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        friendImage.layer.masksToBounds = true
        friendImage.layer.cornerRadius = 10
    }
}
