//
//  ProfileVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SwiftToast
import ProgressHUD
import SafariServices
import FirebaseFirestore

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class ProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileHeaderDelegate, AnonymousLoginViewDelegate {
   
//    MARK: - Properties
    
    var user: Users?
    var userPosts = [Posts]()
    var userFollowingIDs = [String]()
    var toast = SwiftToast()
    var followers = [String]()
    var following = [String]()
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    var isBlocked = false
    var blockedUsers = [String]()
    
//    MARK: - Views
    
    private var anonymousView = AnonymousView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configureCollectionView()
        configureRefreshControl()
        configureBlockedUser()
        fetchPosts()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(RELOAD_PROFILE_DATA), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

//    MARK: - Handlers
    
    @objc private func handleRefresh(){
        fetchPosts()
    }
    
    @objc private func handleMenu(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if !userPosts.isEmpty{
                guard let userId = userPosts[0].userID else {return}
                if currentUserId != userId{
                    showAlertForOtherUser()
                }else{
                    showAlertForCurrentUser()
                }
            }else{
                if let user = self.user{
                    if currentUserId == user.userID{
                        showAlertForCurrentUser()
                    }else{
                        showAlertForOtherUser()
                    }
                }else{
                    showAlertForCurrentUser()
                }
                
            }
        }
    }
    
    func handleLogin() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DataService.instance.socialLogout()
            DataService.instance.resetDefaults()
            let displayVC = DisplayVC()
            displayVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(displayVC, animated: true)
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func handleCancel() {
        removeAnonymousView()
    }
    
    @objc func reloadData(){
        self.collectionView.reloadData()
    }
    
    private func showAlertForCurrentUser(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            let settingsVC = SettingsVC()
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showAlertForOtherUser(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Share Profile", style: .default, handler: { (action) in
            self.shareProfile()
        }))
        alertVC.addAction(UIAlertAction(title: "Report Profile", style: .destructive, handler: { (action) in
            self.reportProfile()
        }))
        if self.isBlocked{
            alertVC.addAction(UIAlertAction(title: "Unblock User", style: .destructive, handler: { (action) in
                self.blockUser()
            }))
        }else{
            alertVC.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { (action) in
                self.blockUser()
            }))
        }
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func handleEditFollowTapped(for header: ProfileHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            if let user = self.user{
                guard let userId = user.userID else {return}
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                if userId == currentUserId{
                    let editProfileVC = EditProfileVC()
                    navigationController?.pushViewController(editProfileVC, animated: true)
                }else{
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    handleFollow(userId: userId, currentUserId: currentUserId, for: header)
                }
                
            }else{
                let editProfileVC = EditProfileVC()
                navigationController?.pushViewController(editProfileVC, animated: true)
            }
        }
    }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profileMenuIcon"), style: .plain, target: self, action: #selector(handleMenu))
    }
    
    private func configureCollectionView(){
        self.collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
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
    
    private func handleFollow(userId: String, currentUserId: String, for header: ProfileHeader){
        fetchFollowingUserIDs { (success, error) in
            if success{
                if self.userFollowingIDs.contains(where: {$0 == userId}) {
                    self.unFollowUser(userId: userId, currentUserId: currentUserId)
                    header.editProfileFollowButton.setTitle("Follow", for: .normal)
//                    header.editProfileFollowButton.setGradientBackground(color1: UIColor.systemBackground, color2: UIColor.systemBackground)
                    header.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
                }else{
                    self.followUser(userId: userId, currentUserId: currentUserId)
                    header.editProfileFollowButton.setTitle("Following", for: .normal)
//                    header.editProfileFollowButton.backgroundColor = UIColor.systemBackground
                    header.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    }
    
    func handleWebsiteTapped(for header: ProfileHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            var userId = ""
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if let user = self.user{
                userId = user.userID
            }else{
                userId = currentUserId
            }
            DataService.instance.fetchPartnerUser(with: userId) { (user) in
                guard let websiteUrl = user.websiteUrl else {return}
                if let url = URL(string: websiteUrl){
                    if UIApplication.shared.canOpenURL(url){
                        let svc = SFSafariViewController(url: url)
                        self.present(svc, animated: true, completion: nil)
                        return
                    }else{
                        self.toast = SwiftToast(text: "Invalid website url entered. Try entering the complete url.")
                        self.present(self.toast, animated: true)
                        return
                    }
                    
                } else {
                    self.toast = SwiftToast(text: "No website url found")
                    self.present(self.toast, animated: true)
                }
            }
        }
    }
    
    func handleFollowersTapped(for header: ProfileHeader) {
        let followersVC = FollowFollowersVC(collectionViewLayout: UICollectionViewFlowLayout())
        followersVC.followFollowingUsers = self.followers
        followersVC.navigationItemTitle = "Followers"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func handleFollowingTapped(for header: ProfileHeader) {
        let followersVC = FollowFollowersVC(collectionViewLayout: UICollectionViewFlowLayout())
        followersVC.followFollowingUsers = self.following
        followersVC.navigationItemTitle =  "Following"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(followersVC, animated: true)
    }
       
    
//    MARK: - CollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //here, be sure you set the font type and size that matches the one set in the storyboard label
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "I make apps."
        label.sizeToFit()
        
        // Set some extra pixels for height due to the margins of the header section.
        //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 16 worked for me as I have 8px for top and bottom constraints.
        return CGSize(width: collectionView.frame.width, height: label.frame.height + 340)
            
//        return CGSize(width: view.frame.width, height: 380)

//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        let dummyCell = ProfileHeader(frame: frame)
//        dummyCell.user = user
//        dummyCell.layoutIfNeeded()
//
//        let targetSize = CGSize(width: view.frame.width, height: 1000)
//        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
//        let height = max(40 + 8 + 8, estimatedSize.height)
//        return CGSize(width: view.frame.width, height: height)
        
        
    }
    
//    MARK: - CollectionView Delegates and DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if indexPath.row == userPosts.count-1{
                paginate()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        configureUserDetails(header: header)
        configureFollowers(header: header)
        configureFollowing(header: header)
        configurePosts(header: header)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
        if !userPosts.isEmpty{
            cell.posts = userPosts[indexPath.row]
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.typeVC = "profile"
        feedVC.userPosts = self.userPosts
        feedVC.scrollIndex = indexPath.row
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
//    MARK: - API
    
    private func configureUserDetails(header: ProfileHeader){
        var userId = ""
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if let user = self.user{
            userId = user.userID
        }else{
            userId = currentUserId
        }
        
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            header.bioLabel.text = user.bio
            header.nameLabel.text = user.name
            header.profileImageView.loadImage(with: user.profileImageURL)
            header.editProfileFollowButton.layer.borderWidth = 0
            self.navigationItem.title = user.username
        }
        
        if userId != currentUserId{
            fetchFollowingUserIDs { (success, error) in
                if success{
                    if self.userFollowingIDs.contains(where: {$0 == userId}) {
                        header.editProfileFollowButton.setTitle("Following", for: .normal)
                        header.editProfileFollowButton.backgroundColor = UIColor.systemBackground
                        header.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
                        header.editProfileFollowButton.layer.borderWidth = 0
                        header.editProfileFollowButton.setGradientBackground(color1: UIColor.systemBackground, color2: UIColor.systemBackground)
                    }else{
                        header.editProfileFollowButton.setTitle("Follow", for: .normal)
                        header.editProfileFollowButton.backgroundColor = UIColor.systemRed
                        header.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
                    }
                }
            }
        }else{
            header.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        }
            
    }
    
    private func configureFollowers(header: ProfileHeader){
        self.followers.removeAll()
        var userId = ""
        var followersCount = 0
        if let userID = self.user?.userID{
            userId = userID
        }else{
            guard let userID = Auth.auth().currentUser?.uid else {return}
            userId = userID
        }
        FOLLOWERS_REF.document(userId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            for (i,j) in data{
                let isFollower = j as? Bool ?? false
                if isFollower{
                    followersCount += 1
                    self.followers.append(i)
                }
            }
            let attributedText = NSMutableAttributedString(string: "\(followersCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
            header.followersLabel.attributedText = attributedText
            return
        }
    }
    
    private func configureFollowing(header: ProfileHeader){
        self.following.removeAll()
        var userId = ""
        var followingCount = 0
        if let userID = self.user?.userID{
            userId = userID
        }else{
            guard let userID = Auth.auth().currentUser?.uid else {return}
            userId = userID
        }
        FOLLOWING_REF.document(userId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            for (i,j) in data{
                let isFollowing = j as? Bool ?? false
                if isFollowing{
                    followingCount += 1
                    self.following.append(i)
                }
            }
            let attributedText = NSMutableAttributedString(string: "\(followingCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
            header.followingLabel.attributedText = attributedText
            return
        }
    }
    
    private func configurePosts(header: ProfileHeader){
        var userId = ""
        var postsCount = 0
        if let userID = self.user?.userID{
            userId = userID
        }else{
            guard let userID = Auth.auth().currentUser?.uid else {return}
            userId = userID
        }
        
        POST_REF.whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            for _ in snapshot.documents{
                postsCount += 1
            }
            let attributedText = NSMutableAttributedString(string: "\(postsCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
            header.postsLabel.attributedText = attributedText
            return
            
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func shareProfile() {
        guard let username = self.userPosts[0].username else {return}
        let text = "Hi, \(username) is on Flytant. Install the app from App Store to connect and follow there."
        let url = NSURL(string:"https://flytant.com")
        let shareAll = [text , url!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func reportProfile(){
        let alertVC = UIAlertController(title: nil, message: "Do you want to report this profile?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
            guard let username = self.user?.username else {return}
            guard let userId = self.user?.userID else {return}
            let reportData = [userId: ["username": username]]
            REPORT_REF.document("reportedProfiles").setData(reportData, merge: true)
            self.toast = SwiftToast(text: "You have reported \(username)'s profile!")
            self.present(self.toast, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    
    private func blockUser(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = self.user?.userID else {return}
        guard let username = self.user?.username else {return}
        if isBlocked{
            blockedUsers = blockedUsers.filter(){$0 != userId}
            let value = ["blockedUsers": blockedUsers]
            USER_REF.document(currentUserId).updateData(value)
            ProgressHUD.showSuccess("You have unblocked \(username)")
        }else{
            blockedUsers.append(userId)
            let value = ["blockedUsers": blockedUsers]
            USER_REF.document(currentUserId).updateData(value)
            ProgressHUD.showError("You have blocked \(username)")
        }
        isBlocked = !isBlocked
    }
    
    private func configureBlockedUser(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = self.user?.userID else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            guard let blockedUsers = user.blockedUsers else {return}
            self.blockedUsers = blockedUsers
            if blockedUsers.contains(userId){
                self.isBlocked = true
            }else{
                self.isBlocked = false
            }
        }
    }
    
    private func fetchPosts(){
        var userId = ""
        if let user = self.user{
            userId = user.userID
        } else {
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            userId = currentUserId
        }
        
        showIndicatorView()
        self.userPosts.removeAll()
        self.documents.removeAll()
        self.hasMore = true
        query = POST_REF.limit(to: 36).whereField("userId", isEqualTo: userId)
        getPostData()
    }
    
    private func getPostData(){
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
                    let userID = data["userId"] as? String ?? ""
                    let username = data["username"] as? String ?? "username"
                    let postType = data["postType"] as? String ?? ""
                    let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
                    let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
                    let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                    let followersCount = data["followersCount"] as? Int ?? 10
                    
                    let userPosts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
                    self.userPosts.append(userPosts)
                    self.documents.append(document)
                    self.userPosts.sort { (post1, post2) -> Bool in
                        return post1.creationDate > post2.creationDate
                    }
                }
            }
            
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func paginate() {
        query = query.start(afterDocument: documents.last!)
        getPostData()
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
    
    private func followUser(userId: String, currentUserId: String){
        let currentUserData = ["\(userId)": true]
        let userData = ["\(currentUserId)": true]
        FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
            if let _ = error{
                return
            }
            FOLLOWERS_REF.document(userId).setData(userData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                NotificationService.instance.sendFollowNotification(userId: userId, didFollow: true)
            }
        }
    }
    
    private func unFollowUser(userId: String, currentUserId: String){
        let currentUserData = ["\(userId)": false]
        let userData = ["\(currentUserId)": false]
        FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
            if let _ = error{
                return
            }
            FOLLOWERS_REF.document(userId).setData(userData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                NotificationService.instance.sendFollowNotification(userId: userId, didFollow: false)
            }
        }
    }

}
