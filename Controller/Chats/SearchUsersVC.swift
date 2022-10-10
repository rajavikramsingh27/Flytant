//
//  SearchUsersVC.swift
//  Flytant
//
//  Created by Vivek Rai on 07/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "searchUsersCollectionViewCell"

class SearchUsersVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

//    MARK: - Properties
    var users = [Users]()
    var filteredUsers = [Users]()
    var inSearchMode = false
    var chatsVC: ChatsVC?
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    var openProfile = false
    
//    MARK: - Views
    private let searchBar = UISearchBar()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
        configureSearchBar()
        
        //fetchUsers()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func configureCollectionView(){
        self.collectionView.register(SearchUsersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
    }
    
    private func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search by name or username"
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = .white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = .white
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
    

//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredUsers.count
        }else{
            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 64)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchUsersCollectionViewCell
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var user: Users!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        if openProfile{
            let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
        //        if !checkBlockedStatus(withUser: user) {
                self.dismiss(animated: true) {
                    self.chatsVC?.showMessagesVC(user: user)
                }

        //        } else {
        //            ProgressHUD.showError("This user is not available for chat!")
        //        }
        }

        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
//    MARK: - SearchBar Delegate and Data Source
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        fetchUsers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            collectionView.reloadData()
        } else {
            inSearchMode = true
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.contains(searchText) || user.name.contains(searchText)
            })
            collectionView.reloadData()
        }
        if users.count < 10{
            if self.hasMore{
                paginateUsers()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
//    MARK: - API
    
    private func fetchUsers(){
        self.users.removeAll()
        self.filteredUsers.removeAll()
        documents.removeAll()
        self.hasMore = true
        showIndicatorView()
        query = USER_REF.limit(to: 50)
        
        getUsersData()
    }
    
    func getUsersData() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        query.getDocuments() { (snapshot, error) in
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
                    if userId != currentUserId{
                        self.users.append(user)
                    }
                }
            }
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func paginateUsers() {
        guard let last = documents.last else {
            self.hasMore = false
            return
        }
        query = query.start(afterDocument: last)
        getUsersData()
    }
    
       
    //    private func fetchUsers(){
    //        self.users.removeAll()
    //        self.filteredUsers.removeAll()
    //        showIndicatorView()
    //        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
    //
    //        USER_REF.limit(to: 10).getDocuments { (snapshot, error) in
    //            if let _ = error{
    //                self.dismissIndicatorView()
    //                return
    //            }
    //            guard let snapshot = snapshot else {return}
    //            for document in snapshot.documents{
    //                let data = document.data()
    //                let bio = data["bio"] as? String ?? ""
    //                let dateofBirth = data["dateofBirth"] as? String ?? ""
    //                let email = data["email"] as? String ?? ""
    //                let gender = data["gender"] as? String ?? ""
    //                let name = data["name"] as? String ?? ""
    //                let phoneNumber = data["phoneNumber"] as? String ?? ""
    //                let profileImageURL = data["profileImageUrl"] as? String ?? ""
    //                let userId = data["userId"] as? String ?? ""
    //                let username = data["username"] as? String ?? ""
    //                let websiteUrl = data["websiteUrl"] as? String ?? ""
    //                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
    //                if userId != currentUserId{
    //                    self.users.append(user)
    //                }
    //            }
    //
    //            self.collectionView.reloadData()
    //            self.dismissIndicatorView()
    //        }
    //
    //    }
    
}
