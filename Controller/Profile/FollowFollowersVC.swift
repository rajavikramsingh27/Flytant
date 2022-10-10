//
//  FollowFollowersVC.swift
//  Flytant
//
//  Created by Vivek Rai on 10/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "followFollowersCollectionViewCell"

class FollowFollowersVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FollowFollowersCellDelegate {
    
//    MARK: - Properties
    
    var navigationItemTitle: String?
    var users = [Users]()
    var followFollowingUsers: [String]?
    var index = 0
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        guard let navigationTitle = self.navigationItemTitle else {return}
        navigationItem.title = navigationTitle
    }
    
    private func configureCollectionView(){
        self.collectionView.register(FollowFollowersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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

//  MARK: - Handlers
    
    @objc private func handleRefresh(){
        users.removeAll()
        self.index = 0
        fetchUsers()
    }
    
    func handleFollow(for cell: FollowFollowersCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
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

//    MARK: - CollectionView Dlelegate and Data Source
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FollowFollowersCollectionViewCell
        cell.delegate = self
        cell.profileImageView.loadImage(with: users[indexPath.row].profileImageURL)
        cell.usernameLabel.text = users[indexPath.row].username
        cell.nameLabel.text = users[indexPath.row].name
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
    
//    MARK: - API
    
    private func fetchUsersData(user: String, userDetailComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        showIndicatorView()
        USER_REF.document(user).getDocument { (snapshot, error) in
            if let error = error{
                
                self.dismissIndicatorView()
                userDetailComplete(false, error)
                return
            }
            guard let data = snapshot?.data() else {return}
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
            self.users.append(user)
            self.showIndicatorView()
            userDetailComplete(true, nil)
        }
        
    }
    
    
    private func fetchUsers(){
        guard let users = self.followFollowingUsers else {return}
        if self.index < users.count{
            fetchUsersData(user: users[index]) { (success, error) in
                if success{
                    self.index += 1
                    self.fetchUsers()
                }
            }
        }else{
            self.dismissIndicatorView()
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            return
        }
    }
    
    private func fetchFollowers(){
       
    }
    
    private func fetchFollowing(){
        
    }

    func configureFollow(indexPath: IndexPath, cell: FollowFollowersCollectionViewCell){
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
                
                if currentUserID == otherUserID{
                    cell.followButton.isHidden = true
                }else{
                    cell.followButton.isHidden = false
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
                    debugPrint("Successfully updated")
                    self.users[indexPath.row].didFollow = !self.users[indexPath.row].didFollow
                }
            }
        }
        
    }
        
}

