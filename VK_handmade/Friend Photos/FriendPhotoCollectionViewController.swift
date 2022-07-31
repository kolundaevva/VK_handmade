//
//  FriendPhotoCollectionViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendPhotoCollectionViewController: UICollectionViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private var items: [Item] = []
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FriendPhoto")
        
        network.getUserPhotos(id: id ?? ApiKey.userID.rawValue) { [weak self] itms in
            self?.items = itms
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as! PhotoCollectionViewCell
        guard let photoInformation = items[indexPath.row].sizes.first else { return UICollectionViewCell() }
        cell.configure(with: photoInformation)
        return cell
    }
}
