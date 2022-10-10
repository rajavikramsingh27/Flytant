//
//  AlgoliaSearchVC.swift
//  Flytant
//
//  Created by Vivek Rai on 22/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import InstantSearch

typealias UsersHitsViewController = HitsTableViewController<UsersTableViewCellConfigurator>

struct UsersItem: Codable {
    let username: String
}

struct UsersTableViewCellConfigurator: TableViewCellConfigurable {

    let model: UsersItem

    init(model: UsersItem, indexPath: IndexPath) {
        self.model = model
    }

    func configure(_ cell: UITableViewCell) {
        cell.textLabel?.text = model.username
        cell.detailTextLabel?.text = "Hello"
        cell.imageView?.image = UIImage(named: "profile_bottom")

    }
}

class AlgoliaSearchVC: UIViewController {


    let searcher = SingleIndexSearcher(appID: "AFZLHKQDJB",
                                         apiKey: "a134c1f100e57c7ff779fbf8f60435af",
                                         indexName: "users")
    lazy var searchController: UISearchController = .init(searchResultsController: hitsViewController)
    lazy var searchConnector: SingleIndexSearchConnector<UsersItem> = .init(searcher: searcher,
                                                                                searchController: searchController,
                                                                                hitsController: hitsViewController)
    let hitsViewController: UsersHitsViewController = .init()

    let statsInteractor: StatsInteractor = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchConnector.connect()
        statsInteractor.connectSearcher(searcher)
        statsInteractor.connectController(self)
        searcher.search()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       configureNavigationBar()
       searchController.searchBar.becomeFirstResponder()
    }

    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationItem.title = ""
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchBar.barTintColor = UIColor.label
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        searchController.automaticallyShowsCancelButton = true
    }

}

extension AlgoliaSearchVC: StatsTextController {

  func setItem(_ item: String?) {
//    title = item
  }


}
