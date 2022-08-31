//
//  NewsfeedCellCode.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 31.08.2022.
//

import Foundation
import UIKit

final class NewsfeedCellCode: UITableViewCell {
    
    //First Layer
    let feedView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Second Layer
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postLabel: UILabel = {
      let label = UILabel()
        label.numberOfLines = 0
        label.font = Constans.labelFont
        return label
    }()
    
    let postImageView: WebImageView = {
       let view = WebImageView()
        return view
    }()
    
    let bottomView: UIView = {
       let view = UIView()
        return view
    }()
    
    //Third layer on topView
    let iconImageView: WebImageView = {
        let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //Third layer on bottomView
    let likesView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let commentsView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Fourth layer on bottomViewViews
    
    let likesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let commentsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comment")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "view")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let commentsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let viewsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayerOnTopView()
        overlayThirdLayerOnBottomView()
        overlayFouthLayerOnBottomViewView()
    }
    
    //Fouth layer on bottomViewViews constraints
    private func overlayFouthLayerOnBottomViewView() {
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentsImage)
        commentsView.addSubview(commentsLabel)
        
        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)
        
        helpInFouthLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInFouthLayer(view: commentsView, imageView: commentsImage, label: commentsLabel)
        helpInFouthLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }
    
    private func helpInFouthLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constans.imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constans.imageSize).isActive = true
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 2).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    //Third layer on bottomView constraints
    func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(viewsView)
        
        likesView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        likesView.heightAnchor.constraint(equalToConstant: Constans.viewHeight).isActive = true
        likesView.widthAnchor.constraint(equalToConstant: Constans.viewWidth).isActive = true
        
        commentsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
        commentsView.heightAnchor.constraint(equalToConstant: Constans.viewHeight).isActive = true
        commentsView.widthAnchor.constraint(equalToConstant: Constans.viewWidth).isActive = true
        
        viewsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        viewsView.heightAnchor.constraint(equalToConstant: Constans.viewHeight).isActive = true
        viewsView.widthAnchor.constraint(equalToConstant: Constans.viewWidth).isActive = true
    }
        
    //Third layer on topView constraints
    func overlayThirdLayerOnTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constans.topHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constans.topHeight).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Constans.topHeight / 2 - 2).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    //Second layer constraints
    func overlaySecondLayer() {
        feedView.addSubview(topView)
        
        topView.topAnchor.constraint(equalTo: feedView.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: feedView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: feedView.trailingAnchor, constant: -8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constans.topHeight).isActive = true
        
        feedView.addSubview(postLabel)
        feedView.addSubview(postImageView)
        feedView.addSubview(bottomView)
    }
    //First layer constraints
    func overlayFirstLayer() {
        addSubview(feedView)
        

        feedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        feedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        feedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        feedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
    func configure(with feed: FeedCellViewModel) {
        iconImageView.set(url: feed.iconUrl)
        nameLabel.text = feed.name
        dateLabel.text = feed.date
        postLabel.text = feed.text
        likesLabel.text = feed.likes
        commentsLabel.text = feed.comments
        viewsLabel.text = feed.views
        
        postLabel.frame = feed.sizes.postLabelFrame
        postImageView.frame = feed.sizes.attechmentFrame
        bottomView.frame = feed.sizes.bottomViewFrame
        
        if let photoAttechment = feed.attechment {
            postImageView.set(url: photoAttechment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
