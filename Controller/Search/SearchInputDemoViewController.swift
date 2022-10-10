//
//  File.swift
//  Flytant
//
//  Created by Vivek Rai on 02/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import InstantSearch

class SearchInputDemoViewController: UIViewController, UISearchBarDelegate {
  
  typealias HitType = UserItem
  
  let searchTriggeringMode: SearchTriggeringMode
  
  let searcher: SingleIndexSearcher
  
  let queryInputConnector: QueryInputConnector
  
  let hitsInteractor: HitsInteractor<HitType>

  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  init(searchTriggeringMode: SearchTriggeringMode) {
    self.searchBar = .init()
    self.searchTriggeringMode = searchTriggeringMode
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "users")
    self.textFieldController = .init(searchBar: searchBar)
    self.queryInputConnector = QueryInputConnector(searcher: searcher,
                                                   searchTriggeringMode: searchTriggeringMode,
                                                   controller: textFieldController)
    self.hitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    self.hitsTableViewController = MovieHitsTableViewController()
    super.init(nibName: .none, bundle: .none)
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureNavigationBar()
  }
  
  private func setup() {
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    searcher.search()
    searchBar.delegate = self
    searchBar.placeholder = "Search Influencers"
    searchBar.showsCancelButton = true
    searchBar.becomeFirstResponder()
  }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationItem.title = ""
        navigationItem.titleView = searchBar
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeViewController()
        view.endEditing(true)
    }
    
    private func closeViewController() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
  
}

private extension SearchInputDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .systemBackground
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    let stackView = UIStackView()
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(hitsTableViewController.view)
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
    
}

