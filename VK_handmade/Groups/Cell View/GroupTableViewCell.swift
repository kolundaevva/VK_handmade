//
//  GroupTableViewCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: WebImageView!
    
    func configure(with group: Group) {
        groupName.text = group.name
        groupImage.set(url: group.photo)
    }
}
