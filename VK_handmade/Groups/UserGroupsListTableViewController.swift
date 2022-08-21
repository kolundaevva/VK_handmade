//
//  GroupsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

class UserGroupsListTableViewController: UITableViewController {
    
    private let network: NetworkServiceDescription = NetworkService()
    private let dataManager: Manager = DataManager()
    
    private var groups: List<Group>?
    private var token: NotificationToken?
    private let id = ApiKey.session.userId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Group")
        
//        network.getNewsFeed()
        API.Client.shared.get(.getUserGroupsList) { (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
            switch result {
            case .success(let success):
                let grp = success.response.items
                self.dataManager.saveUserGroupsData(grp)
            case .failure(let failure):
                let ac = UIAlertController(title: "Something goes wrong", message: failure.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }
        pairTableAndRealm()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupTableViewCell
        guard let group = groups?[indexPath.row] else { return GroupTableViewCell() }
        cell.configure(with: group)
        return cell
    }
    
    @IBAction func addNewGroupPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Search") as? GroupsListTableViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Private Methods
    private func pairTableAndRealm() {
        guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: id) else { return }
        groups = user.groups
        
        token = groups?.observe({ [weak self] changes in
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
