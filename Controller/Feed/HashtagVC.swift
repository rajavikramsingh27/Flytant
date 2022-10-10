//
//  HashtagVC.swift
//  Flytant
//
//  Created by Vivek Rai on 05/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit

private let reuseIdentifier = "hashtagCollectionViewCell"

class HashtagVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    var hashtag: String?
    var userPosts = [Posts]()
    var hashtagPostIds = [String]()
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
               
        configureRefreshControl()

        fetchHashtagPosts()
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
        if let hashtag = self.hashtag{
            navigationItem.title = "#\(hashtag)"
        }else{
            navigationItem.title = "#hashtag"
        }
    }
    
    private func configureCollectionView(){
        self.collectionView.register(HashtagCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
        fetchHashtagPosts()
    }
    
//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: CGFloat(exactly: width)!)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HashtagCollectionViewCell
        if !userPosts.isEmpty{
            cell.posts = userPosts[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.userPosts.append(self.userPosts[indexPath.row])
        feedVC.typeVC = "search"
        navigationController?.pushViewController(feedVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
//    MARK: - API
    
   private func fetchHashtagPosts(){
        showIndicatorView()
        userPosts.removeAll()
        fetchHashtagPostIDs { (success, error) in
            POST_REF.getDocuments { (snapshot, error) in
                if let _ = error{
                    self.dismissIndicatorView()
                    self.collectionView.refreshControl?.endRefreshing()
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
                    let userID = data["userId"] as? String ?? "userID"
                    let username = data["username"] as? String ?? "username"
                    let postType = data["postType"] as? String ?? ""
                    let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
                    let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
                    let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                    let followersCount = data["followersCount"] as? Int ?? 10
                    
                    let posts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
                    
                    if self.hashtagPostIds.contains(where: {$0 == postID}){
                        self.userPosts.append(posts)
                    }
                }
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
            }
        }
    }
    
    private func fetchHashtagPostIDs(fetchComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        guard let hashtag = self.hashtag else {return}
        
        HASHTAG_POST_REF.document(hashtag).getDocument { (snapshot, error) in
            if let _ = error{
                fetchComplete(false, error)
                return
            }
            if let data = snapshot?.data(){
                for (i,_) in data{
                    let hashtagId = i as? String ?? ""
                    self.hashtagPostIds.append(hashtagId)
                }
                print(self.hashtagPostIds)
                fetchComplete(true, nil)
            }
        }
    }
}

