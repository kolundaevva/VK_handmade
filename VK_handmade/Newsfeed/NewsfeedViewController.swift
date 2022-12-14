//
//  NewsfeedViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: AnyObject {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {

    @IBOutlet weak var tableView: UITableView!

    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?

    private var feedViewModel = FeedViewModel.init(cells: [])

    lazy private var refreshControl: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateFeed), for: .valueChanged)
        return refresh
    }()

    // MARK: Setup
    private func setup() {
        title = "News"
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
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
        view.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.4980392157, blue: 0.5607843137, alpha: 1)

        interactor?.makeRequest(request: .getCachedFeed)
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
    }

    private func setupTableView() {
        tableView.register(NewsfeedCellCode.self, forCellReuseIdentifier: "Post")

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.addSubview(refreshControl)
    }

    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsFeed(feed: let feed):
            self.feedViewModel = feed
            self.tableView.reloadData()
            refreshControl.endRefreshing()
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

    @objc private func updateFeed() {
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Post",
            for: indexPath
        ) as? NewsfeedCellCode else { return UITableViewCell() }
        let feed = feedViewModel.cells[indexPath.row]
        cell.configure(with: feed)
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedViewModel.cells[indexPath.row].sizes.totalHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedViewModel.cells[indexPath.row].sizes.totalHeight
    }
}

extension NewsfeedViewController: NewsfeedCellCodeDelegate {
    func revealPost(for cell: NewsfeedCellCode) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let feed = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.revealPostIds(postId: feed.postId))
    }
}
