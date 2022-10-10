//
//  AnalyticsVC.swift
//  Flytant
//
//  Created by Vivek Rai on 08/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "analyticsCollectionViewCell"

class AnalyticsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    var posts = [Posts]()
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
        configureRefreshControl()
        
        fetchPosts()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
        
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Analytics"
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func configureCollectionView(){
        collectionView.register(AnalyticsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
//    MARK: - CollectionView Delegate and DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnalyticsCollectionViewCell
        if !posts.isEmpty{
            cell.posts = self.posts[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2)/3
        return CGSize(width: width, height: width+40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
//    MARK: Handlers
    
    @objc private func handleRefresh(){
        fetchPosts()
    }
    
//    MARK: - API
    
    private func fetchPosts(){
        self.posts.removeAll()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        showIndicatorView()
        POST_REF.whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            for document in snapshot.documents{
                let data = document.data()
                let postID = document.documentID
                let category = data["category"] as? String ?? "Other"
                let creationDate = data["creationDate"] as? Double ?? 0
                let description = data["description"] as? String ?? ""
                let imageUrls = data["imageUrls"] as? [String] ?? [String]()
                let likes = data["likes"] as? Int ?? 0
                let upvotes = data["upvotes"] as? Int ?? 0
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? "username"
                let postType = data["postType"] as? String ?? ""
                let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
                let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
                let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                let followersCount = data["followersCount"] as? Int ?? 10
                
                let userPosts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
                self.posts.append(userPosts)
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
            }
            
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.dismissIndicatorView()
        }
    }
    
}
