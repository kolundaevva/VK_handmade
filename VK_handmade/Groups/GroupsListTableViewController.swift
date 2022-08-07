//
//  GroupsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

class GroupsListTableViewController: UITableViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private let dataManager: Manager = DataManager()
    
    private var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Group")
        
        network.searchGroups(name: "Music") { [weak self] groups in
            self?.groups = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        
        let ac = UIAlertController(title: "Groups", message: "Do you want to follow \(group.name)", preferredStyle: .alert)
        let follow = UIAlertAction(title: "Follow", style: .default) { [weak self] _ in
            self?.dataManager.addGroup(group)
//            self?.network.joinGroup(id: group.id)
            self?.groups.remove(at: indexPath.row)
            self?.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        ac.addAction(follow)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}
