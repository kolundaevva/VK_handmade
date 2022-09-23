//
//  SearchGroupListViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 23.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchGroupListDisplayLogic: AnyObject {
    func displayData(viewModel: SearchGroupList.Model.ViewModel.ViewModelData)
}

protocol SearchGroupDelegate: AnyObject {
    func makeRequest()
}

class SearchGroupListViewController: UITableViewController, SearchGroupListDisplayLogic {
    
    var interactor: SearchGroupListBusinessLogic?
    var router: (NSObjectProtocol & SearchGroupListRoutingLogic)?
    
    var groupsViewModel = GroupViewModel.init(cells: [])
    private let dataManager: Manager = DataManager()
    
    weak var delegate: SearchGroupDelegate?

    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchGroupListInteractor()
        let presenter             = SearchGroupListPresenter()
        let router                = SearchGroupListRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchGroup")
    }
    
    func displayData(viewModel: SearchGroupList.Model.ViewModel.ViewModelData) {
        switch viewModel {
//        case .displayGroupsList(groups: let groups):
//            groupsViewModel = groups
//            tableView.reloadData()
        case .showError(error: let error):
            let ac = UIAlertController(title: "Something goes wrong", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
}

extension SearchGroupListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsViewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroup", for: indexPath) as! GroupTableViewCell
        let group = groupsViewModel.cells[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = groupsViewModel.cells[indexPath.row]
        
        let ac = UIAlertController(title: "Groups", message: "Do you want to follow \(selectedGroup.name)", preferredStyle: .alert)
        let follow = UIAlertAction(title: "Follow", style: .default) { [weak self] _ in
            API.Client.shared.get(.joinGroup(id: selectedGroup.id)) { (result: Result<API.Types.Response.Empty, API.Types.Error>) in
                switch result {
                case .success(_):
                    self?.delegate?.makeRequest()
                case .failure(let failure):
                    self?.displayData(viewModel: .showError(error: failure))
                }
            }
            self?.groupsViewModel.cells.remove(at: indexPath.row)
            self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        ac.addAction(follow)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}
