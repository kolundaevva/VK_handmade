//
//  ItemLayout.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.09.2022.
//

import Foundation
import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {
    weak var delegate: RowLayoutDelegate!
    
    var photos = [CGSize]()
    
    static let numberOfLines = 2
    fileprivate let cellPadding: CGFloat = 8
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache = []
        contentWidth = 0
        
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let index = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: index)
            photos.append(photoSize)
        }
        
        let superViewWidth = collectionView.frame.width
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photoSizes: photos) else { return }
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfLines)
        
        let photosRation = photos.map{ $0.height / $0.width }
        var yOffset = [CGFloat]()
        
        for row in 0..<RowLayout.numberOfLines {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfLines)
        var row = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let index = IndexPath(item: item, section: 0)
            
            let ration = photosRation[index.row]
            let width = rowHeight / ration
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let frameInset = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frameInset
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < (RowLayout.numberOfLines - 1) ? (row + 1) : 0
        }
    }
    
    static func rowHeightCounter(superViewWidth: CGFloat, photoSizes: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        let minPhotoRation = photoSizes.min { first, second in
            (first.height / first.width) < (second.height / second.width)
        }
        
        guard let minPhotoRation = minPhotoRation else { return nil }
        let difference = superViewWidth / minPhotoRation.height
        rowHeight = minPhotoRation.height * difference * CGFloat(RowLayout.numberOfLines)
        
        return rowHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayout = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayout.append(attribute)
            }
        }
        
        return visibleLayout
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
