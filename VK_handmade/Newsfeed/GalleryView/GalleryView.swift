//
//  GalleryView.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 01.09.2022.
//

import Foundation
import UIKit

class GalleryView: UICollectionView, UICollectionViewDelegateFlowLayout {

    private var photos: [FeedCellAttechmentViewModel] = []

    init() {
        let layout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        delegate = self
        dataSource = self

        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        register(GalleryViewCell.self, forCellWithReuseIdentifier: "photoView")

        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
    }

    func set(photos: [FeedCellAttechmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "photoView",
            for: indexPath
        ) as? GalleryViewCell else { return UICollectionViewCell() }
        cell.configure(photoUrl: photos[indexPath.row].photoUrlString)
        return cell
    }
}

extension GalleryView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        return CGSize(width: photo.width, height: photo.height)
    }
}
