//
//  NewsfeedCellSizeCalculator.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 30.08.2022.
//

import Foundation
import UIKit

fileprivate struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attechmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
}

fileprivate struct Constans {
    static let feedInsets = UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16)
    static let topHeight: CGFloat = 40
    static let postLabelInsets = UIEdgeInsets(top: topHeight + 8, left: 8, bottom: 8, right: 8)
    static let labelFont = UIFont.systemFont(ofSize: 15)
}

protocol NewsfeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attechment: FeedCellAttechmentViewModel?) -> FeedCellSizes
}

final class NewsfeedCellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(width: CGFloat = UIScreen.main.bounds.width) {
        self.screenWidth = width
    }
    
    func sizes(postText: String?, attechment: FeedCellAttechmentViewModel?) -> FeedCellSizes {
        
        let feedWidth = screenWidth - Constans.feedInsets.left - Constans.feedInsets.right
        
        //MARK: - Calculate post height
        var postLabelFrame = CGRect(origin: CGPoint(x: Constans.postLabelInsets.left, y: Constans.postLabelInsets.top), size: CGSize.zero)
        
        if let postText = postText, !postText.isEmpty {
            let width = feedWidth - Constans.postLabelInsets.left - Constans.postLabelInsets.right
            let height = postText.height(width: width, font: Constans.labelFont)
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        return Sizes(postLabelFrame: postLabelFrame, attechmentFrame: CGRect.zero, bottomView: CGRect.zero, totalHeight: 300)
    }
}
