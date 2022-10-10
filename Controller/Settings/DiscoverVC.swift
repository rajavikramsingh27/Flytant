//
//  DiscoverVC.swift
//  Flytant
//
//  Created by Vivek Rai on 04/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "discoverCollectionViewCell"

class DiscoverVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, DiscverCellDelegate {
    
//    MARK: - Properties
    var users = [Users]()
    var userFollowingIDs = [String]()

//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureCollectionView()
        configureRefreshControl()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Discover"
    }
    
    private func configureCollectionView(){
        self.collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
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
    
//    MARK: - CollectionView Delegate and Data Source
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
   }

   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return users.count
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width = (view.frame.width - 2) / 3
       return CGSize(width: width, height: CGFloat(exactly: width)! + 50)
   }

   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverCollectionViewCell
       cell.delegate = self
       if !users.isEmpty{
            cell.profileImageView.loadImage(with: users[indexPath.row].profileImageURL)
            cell.usernameLabel.text = users[indexPath.row].username
            cell.nameLabel.text = users[indexPath.row].name
        }
       
       configureFollow(indexPath: indexPath, cell: cell)
       
       return cell
   }
       
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if !self.users.isEmpty{
           let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
           profileVC.user = self.users[indexPath.row]
           navigationController?.pushViewController(profileVC, animated: true)
       }
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 1
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 1
   }
    
    
//    MARK: - Handlers
    
    @objc private func handleRefresh(){
        fetchUsers()
    }
    
    func handleFollow(for cell: DiscoverCollectionViewCell) {
        debugPrint("Follow tapped")
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        if !users[indexPath.row].didFollow{
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.label, for: .normal)
            cell.followButton.backgroundColor = UIColor.systemBackground
            self.updateFollowing(indexPath: indexPath)
        }else{
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.backgroundColor = UIColor.systemRed
            self.updateFollowing(indexPath: indexPath)
        }
    }
    
//    MARK: - API
    
    func configureFollow(indexPath: IndexPath, cell: DiscoverCollectionViewCell){
        if !users.isEmpty{
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            guard let otherUserID = users[indexPath.row].userID else {return}
            FOLLOWING_REF.document(currentUserID).getDocument { (snapshot, error) in
                if let _ = error{
                    return
                }
                guard let data = snapshot?.data() else {return}
                let postUser = data[otherUserID] as? Bool ?? false
                if postUser{
                    if !self.users.isEmpty{
                        self.users[indexPath.row].didFollow = true
                        cell.followButton.setTitle("Following", for: .normal)
                        cell.followButton.setTitleColor(.label, for: .normal)
                        cell.followButton.backgroundColor = UIColor.systemBackground
                    }
                }else{
                    if !self.users.isEmpty{
                        self.users[indexPath.row].didFollow = false
                        cell.followButton.setTitle("Follow", for: .normal)
                        cell.followButton.setTitleColor(.white, for: .normal)
                        cell.followButton.backgroundColor = UIColor.systemRed
                    }
                }
            }
            
        }
        
    }
    
    private func fetchUsers(){
        showIndicatorView()
        users.removeAll()
        fetchFollowingUserIDs { (success, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            if success{
                USER_REF.limit(to: 30).getDocuments { (snapshot, error) in
                    if let _ = error{
                        self.dismissIndicatorView()
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
                        let userID = data["userId"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let websiteUrl = data["websiteUrl"] as? String ?? ""
                        let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
                        if !self.userFollowingIDs.contains(userID){
                            self.users.append(user)
                        }
                    }
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                    self.dismissIndicatorView()
                }
            }
        }
        
    }
    
    
    private func updateFollowing(indexPath: IndexPath){
        if !users[indexPath.row].didFollow{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            guard let otherUserId = users[indexPath.row].userID else {return}
            let currentUserData = ["\(otherUserId)": true]
            let otherUserData = ["\(currentUserId)": true]
            FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                FOLLOWERS_REF.document(otherUserId).setData(otherUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    self.users[indexPath.row].didFollow = !self.users[indexPath.row].didFollow
                    NotificationService.instance.sendFollowNotification(userId: otherUserId, didFollow: true)
                }
            }
            
        }else{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            guard let otherUserId = users[indexPath.row].userID else {return}
            let currentUserData = ["\(otherUserId)": false]
            let otherUserData = ["\(currentUserId)": false]
            FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                FOLLOWERS_REF.document(otherUserId).setData(otherUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    self.users[indexPath.row].didFollow = !self.users[indexPath.row].didFollow
                    NotificationService.instance.sendFollowNotification(userId: otherUserId, didFollow: false)
                }
            }
        }
        
    }
    
    private func fetchFollowingUserIDs(fetchComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        FOLLOWING_REF.document(userID).getDocument { (snapshot, error) in
            if let _ = error{
                fetchComplete(false, error)
                return
            }
            if let data = snapshot?.data(){
                for (i,j) in data{
                    if (j as? Bool ?? false){
                        self.userFollowingIDs.append(i)
                    }
                }
                fetchComplete(true, nil)
            }else{
                fetchComplete(true, nil)
            }
        }
    }
        
}
