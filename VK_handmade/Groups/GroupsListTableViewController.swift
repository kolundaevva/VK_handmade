//
//  GroupsListTableViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

final class ResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let cellReuseIdentifier = "Group"
    
    private let dataManager: Manager = DataManager()
    var groups: [Group] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}

class GroupsListTableViewController: UITableViewController {
    private let dataManager: Manager = DataManager()
    private let searchController = UISearchController(searchResultsController: ResultVC())
    
    private var groups: [Group] = []
    private let cellReuseIdentifier = "Group"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        API.Client.shared.get(.getUserGroupsList) { (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
            switch result {
            case .success(let success):
                let grp = success.response.items
                self.groups = self.convertData(grp)

                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    //MARK: - Private Methods
    private func convertData(_ data: [API.Types.Response.VKGroupData.GroupResponse.VKGroup]) -> [Group] {
        return data.map { Group(group: $0) }
    }
}

//MARK: – UISearchControllerDelegate
extension GroupsListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let vc = searchController.searchResultsController as! ResultVC
        
        if !trimmed.isEmpty {
            API.Client.shared.get(.searchGroups(name: trimmed)) { (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
                switch result {
                case .success(let success):
                    let grp = success.response.items
                    
                    DispatchQueue.main.async {
                        vc.groups = self.convertData(grp)
                        vc.tableView.reloadData()
                    }
                    
                case .failure(let failure):
                    let ac = UIAlertController(title: "Something goes wrong", message: failure.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    vc.present(ac, animated: true)
                }
            }
        }
    }
}
