//
//  FriendsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class FriendsListTableViewController: UITableViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Friend")
        network.getFriendList { [weak self] users in
            self?.friends = users
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendTableViewCell
        let friend = friends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
    
    //MARK: – Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Photos") as? FriendPhotoCollectionViewController else { return }
        let id = String(friends[indexPath.row].id)
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}
