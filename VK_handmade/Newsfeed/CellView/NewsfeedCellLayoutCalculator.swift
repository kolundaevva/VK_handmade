//
//  NewsfeedCellSizeCalculator.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 30.08.2022.
//

import Foundation
import UIKit

private struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var moreTextButtonFrame: CGRect
    var totalHeight: CGFloat
}

protocol NewsfeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachments: [FeedCellAttachmentViewModel], isFullSize: Bool) -> FeedCellSizes
}

final class NewsfeedCellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol {

    private let screenWidth: CGFloat

    init(width: CGFloat = UIScreen.main.bounds.width) {
        self.screenWidth = width
    }

    func sizes(
        postText: String?,
        attachments: [FeedCellAttachmentViewModel],
        isFullSize: Bool
    ) -> FeedCellSizes {
        let feedWidth = screenWidth - Constans.feedInsets.left - Constans.feedInsets.right
        var showMoreButton = false

        // MARK: - Calculate post text height
        var postLabelFrame = CGRect(
            origin: CGPoint(
                x: Constans.postLabelInsets.left,
                y: Constans.postLabelInsets.top
            ), size: CGSize.zero
        )

        if let postText = postText, !postText.isEmpty {
            let width = feedWidth - Constans.postLabelInsets.left - Constans.postLabelInsets.right
            var height = postText.height(width: width, font: Constans.labelFont)

            let limitHeight = Constans.labelFont.lineHeight * Constans.minifiedPostLimitLines

            if !isFullSize && height > limitHeight {
                height = Constans.labelFont.lineHeight * Constans.minifiedPostLines
                showMoreButton = true
            }

            postLabelFrame.size = CGSize(width: width, height: height)
        }

        // MARK: - Calculate moreTextButton size
        var moreTextButtonSize = CGSize.zero

        if showMoreButton {
            moreTextButtonSize = Constans.moreTextButtonSize
        }

        let moreTextButtonSizeOrigin = CGPoint(x: Constans.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        let moreTextButtonFrame = CGRect(origin: moreTextButtonSizeOrigin, size: moreTextButtonSize)

        // MARK: - Calculate post image height
        let postImageTop = postLabelFrame.size == CGSize.zero ?
        Constans.postLabelInsets.top : moreTextButtonFrame.maxY + Constans.postLabelInsets.bottom

        var postImageFrame = CGRect(origin: CGPoint(x: 0, y: postImageTop), size: CGSize.zero)

        if let attachment = attachments.first {
            let photoHeight = Float(attachment.height)
            let photoWidth = Float(attachment.width)
            let ration = CGFloat(photoHeight / photoWidth)

            if attachments.count == 1 {
                postImageFrame.size = CGSize(width: feedWidth, height: feedWidth * ration)
            } else if attachments.count > 1 {
                var photoSizes = [CGSize]()

                for attachment in attachments {
                    let size = CGSize(width: attachment.width, height: attachment.height)
                    photoSizes.append(size)
                }

                let height = RowLayout.rowHeightCounter(superViewWidth: feedWidth, photoSizes: photoSizes)
                let frameSize = CGSize(width: feedWidth, height: height!)
                postImageFrame.size = frameSize
            }
        }

        // MARK: - Calculate post bottomView height
        let bottomViewTop = max(postLabelFrame.maxY, postImageFrame.maxY)
        let bottomViewFrame = CGRect(
            origin: CGPoint(
                x: 0,
                y: bottomViewTop
            ), size: CGSize(
                width: feedWidth,
                height: Constans.bottomHeight
            )
        )

        // MARK: - Calculate total height
        let totalHeight = bottomViewFrame.maxY + Constans.feedInsets.bottom

        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: postImageFrame,
                     bottomViewFrame: bottomViewFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     totalHeight: totalHeight)
    }
}
