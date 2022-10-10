////
////  CategoryViewController.swift
////  Flytant
////
////  Created by Flytant on 06/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import FirebaseRemoteConfig
//
//protocol CategoriesDelegate: AnyObject {
//    func getCategories(categories: String)
//}
//
//final class CategoryViewController: UIViewController {
//
//    @IBOutlet weak var cateogrySearchBar: UISearchBar!
//    @IBOutlet weak var categoryTableView: UITableView!
//    @IBOutlet weak var doneButton: UIButton!
//
//    private let identifier: String = "categoryCell"
//    private var isSearching: Bool = false
//    private var remoteConfig = RemoteConfig.remoteConfig()
//    private var categories = [String]()
//    private var searchCategories = [String]()
//    var selectedCategories = [String]()
//    weak var delegate: CategoriesDelegate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        cateogrySearchBar.delegate = self
//        cateogrySearchBar.tintColor = .systemBackground
//        categoryTableView.register(UINib(nibName: "CategoryTVCell", bundle: nil), forCellReuseIdentifier: identifier)
//        categoryTableView.delegate = self
//        categoryTableView.dataSource = self
//        categoryTableView.tableFooterView = UIView()
//        categoryTableView.reloadData()
//        fetchRemoteConfig()
//    }
//
//    private func fetchRemoteConfig() {
//        remoteConfig.fetch { [unowned self] (status, error) in
//            guard error == nil else { return }
//            print("Got the value from remote config")
//            self.remoteConfig.activate { (_, _) in
//                print("config activate")
//            }
//            self.displayValues()
//        }
//    }
//
//    private func displayValues() {
//        if let value = remoteConfig.configValue(forKey: "explore_category").jsonValue {
//            let values = JSON(value)
//            for i in values {
//                categories.append(i.0)
//            }
//            categories = categories.sorted()
//            categoryTableView.reloadData()
//        }
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if selectedCategories.count > 0 {
//            let stringCategories = selectedCategories.joined(separator: ", ")
//            delegate?.getCategories(categories: stringCategories)
//            dismiss(animated: true, completion: nil)
//        }
//    }
//
//}
//extension CategoryViewController: UISearchBarDelegate {
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.layoutIfNeeded()
//        searchCategories.removeAll()
//        isSearching = false
//        categoryTableView.reloadData()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.text = nil
//        searchBar.showsCancelButton = true
//        searchBar.layoutIfNeeded()
//        isSearching = true
//        categoryTableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchCategories = categories.filter({$0.contains(searchText)})
//        categoryTableView.reloadData()
//    }
//}
//
//extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isSearching {
//            return searchCategories.count
//        } else {
//            return categories.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CategoryTVCell else { return UITableViewCell() }
//        if isSearching {
//            cell.cateogryLabel.text = searchCategories[indexPath.row]
//            if selectedCategories.contains(searchCategories[indexPath.row]) {
//                cell.selectedImageView.isHidden = false
//            } else {
//                cell.selectedImageView.isHidden = true
//            }
//        } else {
//            cell.cateogryLabel.text = categories[indexPath.row]
//            if selectedCategories.contains(categories[indexPath.row]) {
//                cell.selectedImageView.isHidden = false
//            } else {
//                cell.selectedImageView.isHidden = true
//            }
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTVCell else { return }
//        cell.selectedImageView.isHidden = !cell.selectedImageView.isHidden
//        if isSearching {
//            if selectedCategories.contains(searchCategories[indexPath.row]) {
//                if let index = selectedCategories.firstIndex(where: {$0 == searchCategories[indexPath.row]}) {
//                    selectedCategories.remove(at: index)
//                }
//            } else {
//                selectedCategories.append(searchCategories[indexPath.row])
//            }
//        } else {
//            if selectedCategories.contains(categories[indexPath.row]) {
//                if let index = selectedCategories.firstIndex(where: {$0 == categories[indexPath.row]}) {
//                    selectedCategories.remove(at: index)
//                }
//            } else {
//                selectedCategories.append(categories[indexPath.row])
//            }
//        }
//    }
//
//}
