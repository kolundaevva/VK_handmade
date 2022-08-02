//
//  GroupsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit

class UserGroupsListTableViewController: UITableViewController {

    private let network: NetworkServiceDescription = NetworkService()
    private let dataManager: Manager = DataManager()
    private var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Group")
        
        network.getUserGroupsList { [weak self] in
            DispatchQueue.main.async {
                self?.groups = self?.dataManager.loadUserGroups(id: ApiKey.userID.rawValue) ?? []
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
    
    @IBAction func addNewGroupPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Search") as? GroupsListTableViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
