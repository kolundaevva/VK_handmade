//
//  FriendsListViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FriendsListDisplayLogic: AnyObject {
    func displayData(viewModel: FriendsList.Model.ViewModel.ViewModelData)
}

class FriendsListViewController: UITableViewController, FriendsListDisplayLogic {
    
    var interactor: FriendsListBusinessLogic?
    var router: (NSObjectProtocol & FriendsListRoutingLogic)?
    
    private let dataManager: Manager = DataManager()
    var friendsViewModel = FriendViewModel.init(cells: [])
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = FriendsListInteractor()
        let presenter             = FriendsListPresenter()
        let router                = FriendsListRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        interactor.dataManager    = dataManager
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Friends"
        setup()
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logut))
        
        interactor?.makeRequest(request: FriendsList.Model.Request.RequestType.getFriendsList)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Friend")
    }
    
    @objc private func logut() {
        KeychainWrapper.standard.removeObject(forKey: "userToken")
        performSegue(withIdentifier: "toLoginView", sender: nil)
    }
    
    func displayData(viewModel: FriendsList.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayFriendsList(friends: let friends):
            friendsViewModel = friends
            tableView.reloadData()
        case .showError(error: let error):
            let ac = UIAlertController(title: "Something goes wrong", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            router?.routeToFriendPhotos(segue: segue)
        }
    }
}

extension FriendsListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsViewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendTableViewCell
        let friend = friendsViewModel.cells[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = friendsViewModel.cells[indexPath.row].id
        performSegue(withIdentifier: "showPhoto", sender: id)
    }
}
