//
//  FriendPhotoCollectionViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendPhotoCollectionViewController: UICollectionViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private let dataManger: Manager = DataManager()
    
    private var photos: [Photo] = []
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FriendPhoto")
        
        let id = id ?? ApiKey.userID.rawValue
        
        network.getUserPhotos(id: id) { [weak self] in
            DispatchQueue.main.async {
                self?.photos = self?.dataManger.loadUserPhotos(id: id) ?? []
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
}
