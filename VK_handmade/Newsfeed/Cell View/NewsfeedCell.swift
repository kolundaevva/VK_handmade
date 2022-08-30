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
}

class NewsfeedCell: UITableViewCell {

    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with feed: FeedCellViewModel) {
        iconImageView.set(url: feed.iconUrl)
        nameLabel.text = feed.name
        dateLabel.text = feed.date
        postLabel.text = feed.text
        likesLabel.text = feed.likes
        commentsLabel.text = feed.comments
        viewsLabel.text = feed.views
    }
}
