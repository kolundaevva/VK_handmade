//
//  GroupTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet private weak var groupName: UILabel!
    @IBOutlet private weak var groupImage: WebImageView!

    func configure(with group: ProfileRepsentable) {
        groupName.text = group.name
        groupImage.set(url: group.photo)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        groupImage.layer.masksToBounds = true
        groupImage.layer.cornerRadius = 10
    }
}
