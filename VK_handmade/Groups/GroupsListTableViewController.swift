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
    
    private var groups: List<Group>!
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Group")

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
    
    //MARK: - Private Methods
//    private func pairTableAndRealm() {
//        guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: id) else { return }
//        groups = user.groups
//        
//        token = groups?.observe({ [weak self] changes in
//            guard let tableView = self?.tableView else { return }
//            
//            switch changes {
//            case .initial(_):
//                tableView.reloadData()
//                break
//            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                     with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.endUpdates()
//                break
//            case .error(_):
//                fatalError("Something goes wrong")
//            }
//        })
//    }
}
