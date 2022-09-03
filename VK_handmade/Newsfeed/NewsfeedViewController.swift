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
    private let dataManager: Manager = DataManager()
    private var feedViewModel = FeedViewModel.init(cells: [])
    private let refreshControl: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.addTarget(NewsfeedViewController.self, action: #selector(updateFeed), for: .valueChanged)
        return refresh
    }()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        interactor.dataManager    = dataManager
        presenter.viewController  = viewController
        presenter.dataManager     = dataManager
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
    }
    
    private func setupTableView() {
        //        let nib = UINib(nibName: "NewsfeedCell", bundle: nil)
        //        tableView.register(nib, forCellReuseIdentifier: "Post")
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
            let ac = UIAlertController(title: "Something goes wrong", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! NewsfeedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! NewsfeedCellCode
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
