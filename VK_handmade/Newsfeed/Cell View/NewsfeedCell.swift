//
//  NewsfeedCell.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 29.08.2022.
//

import UIKit

protocol FeedCellViewModel {
    var iconUrl: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var views: String? { get }
    var attechment: FeedCellAttechmentViewModel? { get }
}

protocol FeedCellAttechmentViewModel {
    var photoUrlString: String { get }
    var height: Int { get }
    var width: Int { get }
}

class NewsfeedCell: UITableViewCell {

    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.clipsToBounds = true
        
        feedView.layer.cornerRadius = 10
        feedView.clipsToBounds = true
        feedView.backgroundColor = .white
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(with feed: FeedCellViewModel) {
        iconImageView.set(url: feed.iconUrl)
        nameLabel.text = feed.name
        dateLabel.text = feed.date
        postLabel.text = feed.text
        likesLabel.text = feed.likes
        commentsLabel.text = feed.comments
        viewsLabel.text = feed.views
        
        if let photoAttechment = feed.attechment {
            postImageView.set(url: photoAttechment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}
