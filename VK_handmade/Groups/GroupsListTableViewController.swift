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
        
        API.Client.shared.get(.searchGroups(name: "Music")) { [self] (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
            switch result {
            case .success(let success):
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let grp = success.response.items
                    self.groups = convertData(grp) 

                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
//                    }
                }
            case .failure(let failure):
                let ac = UIAlertController(title: "Something goes wrong", message: failure.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
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
            API.Client.shared.get(.joinGroup(id: group.id)) { (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in }
            self?.groups.remove(at: indexPath.row)
            self?.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        ac.addAction(follow)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    //MARK: - Private Methods
    private func convertData(_ data: [API.Types.Response.VKGroupData.Answer.VKGroup]) -> [Group] {
        return data.map { Group(group: $0) }
    }
}
