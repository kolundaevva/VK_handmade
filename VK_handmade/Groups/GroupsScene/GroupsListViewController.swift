//
//  GroupsListViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 22.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GroupsListDisplayLogic: AnyObject {
    func displayData(viewModel: GroupsList.Model.ViewModel.ViewModelData)
}

class GroupsListViewController: UITableViewController, GroupsListDisplayLogic {
    var interactor: GroupsListBusinessLogic?
    var router: (NSObjectProtocol & GroupsListRoutingLogic)?

    private let searchController = UISearchController(searchResultsController: SearchGroupListViewController())

    var groupsViewModel = GroupViewModel.init(cells: [])

    // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = GroupsListInteractor()
        let presenter             = GroupsListPresenter()
        let router                = GroupsListRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Groups"
        setup()
        setupTableView()

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        interactor?.makeRequest(request: .getCachedGroups)
        interactor?.makeRequest(request: .getGroupsList)
    }

    private func setupTableView() {
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Group")
    }

    func displayData(viewModel: GroupsList.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayGroupsList(groups: let groups):
            groupsViewModel = groups
            tableView.reloadData()
        case .showError(error: let error):
            let alert = UIAlertController(
                title: "Something goes wrong",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension GroupsListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsViewModel.cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Group",
            for: indexPath
        ) as? GroupTableViewCell else { return UITableViewCell() }
        let group = groupsViewModel.cells[indexPath.row]
        cell.configure(with: group)
        return cell
    }
}

// MARK: – UISearchControllerDelegate
extension GroupsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let searchVC = searchController.searchResultsController as? SearchGroupListViewController else { return }
        searchVC.delegate = self
        let updateQueue = DispatchQueue(label: "com.kolundaev-update", qos: .utility, attributes: .concurrent)

        if !trimmed.isEmpty {
            API.NetworkRequestManagerImpl.shared.get(
                .searchGroups(name: trimmed)
            ) { (result: Result<API.Types.Response.VKGroupData, API.Types.Error>) in
                switch result {
                case .success(let success):

                    updateQueue.async {
                        let groups = success.response.items.map { group in
                            Group(group: group)
                        }

                        let cells = groups.map { group in
                            self.cellViewModel(from: group)
                        }

                        let groupsCells = GroupViewModel.init(cells: cells)

                        DispatchQueue.main.async {
                            searchVC.groupsViewModel = groupsCells
                            searchVC.tableView.reloadData()
                        }
                    }

                case .failure(let failure):
                    let alert = UIAlertController(
                        title: "Something goes wrong",
                        message: failure.localizedDescription,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    searchVC.present(alert, animated: true)
                }
            }
        }
    }

    private func cellViewModel(from group: Group) -> GroupViewModel.Cell {
        return GroupViewModel.Cell.init(id: group.id,
                                        name: group.name,
                                        photo: group.photo)
    }
}

extension GroupsListViewController: SearchGroupDelegate {
    func makeRequest() {
        interactor?.makeRequest(request: .getGroupsList)
    }
}
