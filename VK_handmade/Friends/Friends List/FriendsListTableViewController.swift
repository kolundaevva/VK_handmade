//
//  FriendsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

class FriendsListTableViewController: UITableViewController {
    
    private let network: NetworkServiceDescription = NetworkService()
    private let dataManager: Manager = DataManager()
    
    private var friends: List<Friend>?
    private var token: NotificationToken?
    private let id = ApiKey.userID.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Friend")
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        network.getFriendList()
        pairTableAndRealm()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendTableViewCell
        guard let friend = friends?[indexPath.row] else { return FriendTableViewCell() }
        cell.configure(with: friend)
        return cell
    }
    
    //MARK: – Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Photos") as? FriendPhotoCollectionViewController else { return }
        let friendId = friends?[indexPath.row].id ?? 0
        vc.id = friendId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Private methods
    private func pairTableAndRealm() {
        guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: id) else { return }
        friends = user.friends
        
        token = friends?.observe({ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial(_):
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(_):
                fatalError("Something goes wrong")
            }
        })
    }
}
