//
//  ExploreVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SwiftToast
import FirebaseFirestore

private let reuseIdentifier = "exploreCell"
private let headerIdentifier = "exploreHeader"
private let tableViewReuseIdentifier = "tableViewCell"

class ExploreVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ExploreHeaderDelegate, UISearchBarDelegate {

//    MARK: - Properties
    var usersPosts = [Posts]()
    var toast = SwiftToast()
    var users = [Users]()
    var filteredUsers = [Users]()
    var inSearchMode = false
    var exploreCategoryImages = [String]()
    var exploreCategoryNames = [String]()
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    
//    MARK: - Views
    
    private let usernameTableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    private let searchBar = UISearchBar()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground

        configureCollectionView()
        
        configureRefreshControl()
//        configureSearchBar()

        configureUsernameTableView()
        
        fetchSearchPosts()
            
        setRemoteConfigData()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        searchBar.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func configureNavigationBar(){
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Explore"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .done, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureCollectionView(){
        self.collectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ExploreHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func configureUsernameTableView(){
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        usernameTableView.separatorStyle = .none
        usernameTableView.separatorColor = UIColor.clear
        usernameTableView.backgroundColor = UIColor.systemBackground
        usernameTableView.keyboardDismissMode = .interactive
        usernameTableView.register(ExploreTableViewCell.self, forCellReuseIdentifier: tableViewReuseIdentifier)
        view.addSubview(usernameTableView)
        usernameTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameTableView.isHidden = true
    }
    
    private func configureSearchBar(){
//        searchBar.sizeToFit()
//        searchBar.delegate = self
//        searchBar.placeholder = "Search for influencers"
//        navigationItem.titleView = searchBar
//        searchBar.barTintColor = UIColor.clear
//        searchBar.tintColor = .white
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = .white
//        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
//        textFieldInsideSearchBarLabel?.textColor = .white
        
       
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func showIndicatorView() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }

    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }

//    MARK: - Handlers

    @objc func handleRefresh(){
        fetchSearchPosts()
    }

//    MARK: - CollectionView Header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ExploreHeader
        header.delegate = self
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }

//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: CGFloat(exactly: width)!)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreCollectionViewCell
        if !usersPosts.isEmpty{
            cell.posts = usersPosts[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
//        feedVC.typeVC = "explore"
//        feedVC.scrollIndex = indexPath.row
//        feedVC.userPosts = self.usersPosts
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationItem.backBarButtonItem = backButton
//        navigationController?.pushViewController(feedVC, animated: true)
        
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.typeVC = "explore"
        feedVC.scrollIndex = indexPath.row
        feedVC.userPosts.append(self.usersPosts[indexPath.row])
        feedVC.category = self.usersPosts[indexPath.row].category
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(feedVC, animated: true)
        
        //let navigationItem = UINavigationController(rootViewController: feedVC)
        //navigationItem.modalPresentationStyle = .overFullScreen
        //self.present(navigationItem, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if indexPath.row == usersPosts.count - 1{
                paginate()
            }
        }
    }
    
//    MARK: - SearchBar Delegate and Data Source
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
//        collectionView.isHidden = true
//        usernameTableView.isHidden = false
//
//        fetchUsers()
        
       handleSearch()
        
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let searchText = searchText.lowercased()
//
//        if searchText.isEmpty || searchText == " " {
//            inSearchMode = false
//            usernameTableView.reloadData()
//        } else {
//            inSearchMode = true
//            filteredUsers = users.filter({ (user) -> Bool in
//                return user.username.contains(searchText) || user.name.contains(searchText)
//            })
//            usernameTableView.reloadData()
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.endEditing(true)
//        searchBar.showsCancelButton = false
//        collectionView.isHidden = false
//        usernameTableView.isHidden = true
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        handleSearch()
//    }
//
    func handleSelectedCategory(for cell: ExploreHeaderCollectionViewCell, indexPath: IndexPath) {
        cell.imageView.loadImage(with: exploreCategoryImages[indexPath.row])
    }
    
    func handleSelectedCategoryTapped(for cell: ExploreHeaderCollectionViewCell, indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.postCategory = exploreCategoryNames[indexPath.row]
        feedVC.typeVC = "category"
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    @objc func handleSearch(){
        let searchVC = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
//    MARK: - API
    
    private func setRemoteConfigData(){
        let remoteConfigData = RemoteConfigManager.getExploreCategoryData(for: "explore_category")
        exploreCategoryNames = remoteConfigData[0]
        exploreCategoryImages = remoteConfigData[1]
    }
    
    private func fetchSearchPosts(){
        showIndicatorView()
        self.usersPosts.removeAll()
        self.documents.removeAll()
        self.hasMore = true
        query = POST_REF.limit(to: 36).order(by: "creationDate", descending: true)
        getSearchData()
    }
    
    private func getSearchData(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        query.getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                return
            }
            
            guard let snapshot = snapshot else {return}
            if snapshot.documents.isEmpty{
                self.hasMore = false
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                return
            }else{
                for document in snapshot.documents{
                    let data = document.data()
                    let postID = document.documentID
                    let category = data["category"] as? String ?? "Other"
                    let creationDate = data["creationDate"] as? Double ?? 0
                    let description = data["description"] as? String ?? ""
                    let imageUrls = data["imageUrls"] as? [String] ?? [String]()
                    let likes = data["likes"] as? Int ?? 0
                    let upvotes = data["upvotes"] as? Int ?? 0
                    let userID = data["userId"] as? String ?? "userId"
                    let username = data["username"] as? String ?? "username"
                    let postType = data["postType"] as? String ?? ""
                    let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
                    let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
                    let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                    let followersCount = data["followersCount"] as? Int ?? 10
                    
                    let posts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
                    if currentUserId != userID{
                        self.documents.append(document)
                        self.usersPosts.append(posts)
                        self.usersPosts.sort { (post1, post2) -> Bool in
                            return post1.creationDate > post2.creationDate
                        }
                    }
                }
            }
            
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func paginate() {
        query = query.start(afterDocument: documents.last!)
        getSearchData()
    }
    
    private func fetchUsers(){
        users.removeAll()
        filteredUsers.removeAll()
        USER_REF.getDocuments { (snapshot, error) in
            if let error = error{
                self.toast = SwiftToast(text: "An error occured. Error description: \n \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userId = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
                self.users.append(user)
            }
        }
    }
    
}

extension ExploreVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredUsers.count
        }else{
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReuseIdentifier, for: indexPath) as! ExploreTableViewCell
        
        var user: Users!
        
        if inSearchMode {
            if !filteredUsers.isEmpty{
                user = filteredUsers[indexPath.row]
            }
        } else {
            if !users.isEmpty{
                user = users[indexPath.row]
            }
        }
        
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user: Users!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileVC.user = user
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
