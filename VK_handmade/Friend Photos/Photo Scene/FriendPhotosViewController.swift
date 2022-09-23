//
//  FriendPhotosViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FriendPhotosDisplayLogic: AnyObject {
    func displayData(viewModel: FriendPhotos.Model.ViewModel.ViewModelData)
}

class FriendPhotosViewController: UICollectionViewController, FriendPhotosDisplayLogic {
    
    var interactor: FriendPhotosBusinessLogic?
    var router: (NSObjectProtocol & FriendPhotosRoutingLogic)?
    
    var id = 0
    private let dataManager: Manager = DataManager()
    private var userPhotos = [Photo]()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = FriendPhotosInteractor()
        let presenter             = FriendPhotosPresenter()
        let router                = FriendPhotosRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        interactor.dataManager    = dataManager
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Friend's Photos"
        setup()
        setupCollectionView()
        interactor?.makeRequest(request: .getFriendPhotos(id: id))
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FriendPhoto")
    }
    
    func displayData(viewModel: FriendPhotos.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayFriendPhotos(photos: let photos):
            userPhotos = photos
            collectionView.reloadData()
        case .showError(error: let error):
            let ac = UIAlertController(title: "Something goes wrong", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
}

extension FriendPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as! PhotoCollectionViewCell
        let photo = userPhotos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
}
