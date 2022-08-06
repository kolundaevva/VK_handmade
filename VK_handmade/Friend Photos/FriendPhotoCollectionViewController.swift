//
//  FriendPhotoCollectionViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

class FriendPhotoCollectionViewController: UICollectionViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private let dataManger: Manager = DataManager()
    
    private var photos: List<Photo>!
    private var token: NotificationToken?
    
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FriendPhoto")
        
        let stringId = String(id)
        
        network.getUserPhotos(id: stringId)
        pairCollectionAndRealm()
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
    
    //MARK: - Private Methods
    private func pairCollectionAndRealm() {
        guard let realm = try? Realm(), let user = realm.object(ofType: Friend.self, forPrimaryKey: id) else { return }
        photos = user.photos
        
        token = photos.observe({ [weak self] changes in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial(_):
                collectionView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
                break
            case .error(_):
                fatalError("Something goes wrong")
            }
        })
    }
}
