//
//  FeedVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit
import Firebase
import GravitySliderFlowLayout
import ActiveLabel
import SwiftToast
import SafariServices
import BadgeControl
import ProgressHUD
import FirebaseFirestore

private let reuseIdentifier = "feedCollectionViewCell"
private let adsReuseIdentifier = "feedAdsCollectionViewCell"
private let headerIdentifier = "feedHeader"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedHeaderDelegate, FeedCellDelegate, AnonymousLoginViewDelegate {
    
//    MARK: - Properties
    
    var userPosts = [Posts]()
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    var typeVC = "feed"
    var hasNoFollowers = false
    var userId: String?
    var scrollIndex: Int?
    var userFollowingIDs = [String]()
    var toast = SwiftToast()
    var category = ""
    var notificationCount = 0
    var notificationIds = [String]()
    var postCategory: String?
    var blockedUsers = [String]()
    
//    MARK: - Views
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    private var notificationBadge: BadgeController!
    private var anonymousView = AnonymousView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configureNavigationBar()
        configureCollectionView()
        configureRefreshControl()
        setFCMToken()
        fetchPosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.view.semanticContentAttribute = .forceLeftToRight
        navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        navigationController?.setNavigationBarHidden(false, animated: animated)
        fetchBlockedUsers()
        if typeVC == "feed"{
            observeNotification()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.view.semanticContentAttribute = .forceLeftToRight
        navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        if typeVC == "explore"{
            navigationItem.title = "Explore"
        }else if typeVC == "profile" || typeVC == "anonymous"{
            navigationItem.title = "Profile"
        }else if typeVC == "category"{
            guard let postCategory = self.postCategory else {return}
            navigationItem.title = postCategory
        }else{
            let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Flytant", font: UIFont(name: "Milkshake", size: 28)!, textAlignment: .center, textColor: .white)
            navigationItem.titleView = titleLabel
            navigationController?.navigationBar.barTintColor = UIColor.purple
//            navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
            navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cameraIcon"), style: .plain, target: self, action: #selector(handleCamera))

            let notificationImageView = UIImageView(image: UIImage(named: "notificationsIcon"))
            notificationImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNotifications))
            tapGesture.numberOfTapsRequired = 1
            notificationImageView.addGestureRecognizer(tapGesture)
            notificationBadge = BadgeController(for: notificationImageView, in: .upperRightCorner, badgeBackgroundColor: .systemRed, badgeTextColor: UIColor.white, badgeTextFont: UIFont.boldSystemFont(ofSize: 12), borderWidth: 0, borderColor: UIColor.clear, animation: BadgeAnimations.rolling, badgeHeight: 16, animateOnlyWhenBadgeIsNotYetPresent: true)

//            let rightBarButtonItem = UIBarButtonItem(customView: notificationImageView)
//            navigationItem.rightBarButtonItem = rightBarButtonItem
            
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "notification_bottom"), style: .done, target: self, action: #selector(handleNotifications))
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
        }
    }
        
    private func configureCollectionView(){
        self.collectionView.register(FeedAdsCollectionViewCell.self, forCellWithReuseIdentifier: adsReuseIdentifier)
        self.collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(FeedHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
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
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
    }
    
//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = FeedCollectionViewCell(frame: frame)
        dummyCell.posts = userPosts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    

//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FeedHeader
        header.delegate = self
        if let userProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL){
             header.profileImageView.loadImage(with: userProfileImageUrl)
        }else{
            header.profileImageView.loadImage(with: DEFAULT_PROFILE_IMAGE_URL)
        }
       
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if typeVC == "feed"{
            return CGSize(width: view.frame.width, height: 60)
        }else{
            return CGSize.zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        cell.delegate = self
        if !userPosts.isEmpty{
            cell.posts = userPosts[indexPath.row]
        }

        configureLikes(index: indexPath.row, cell: cell)
        
        cofigureUpvotes(index: indexPath.row, cell: cell)
        
        configureFollow(index: indexPath.row, cell: cell)

        handleHastagTapped(for: cell)

        handleMentionsTapped(for: cell)

        handleUrlTapped(for: cell)

        if typeVC == "explore" || typeVC == "category"{
            cell.followButton.isHidden = true
        }else{
//            cell.followButton.isHidden = false
            cell.followButton.isHidden = true
        }

        return cell
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var postInteractionCount = UserDefaults.standard.integer(forKey: POST_INTERACTED)
        postInteractionCount += 1
        UserDefaults.standard.set(postInteractionCount, forKey: POST_INTERACTED)
        UserDefaults.standard.synchronize()
        debugPrint(UserDefaults.standard.integer(forKey: POST_INTERACTED))
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if (indexPath.row == userPosts.count - 1) {
                if typeVC ==  "feed"{
                    paginateFeed()
                }else if typeVC == "category"{
                    paginateCategoryData()
                }
            }
        }
        
    }
    
    
//    This
    
    func cofigureUpvotes(index: Int, cell: FeedCollectionViewCell) {
        
        if !userPosts.isEmpty{
            guard let userID = Auth.auth().currentUser?.uid else {return}
            guard let postID = userPosts[index].postID else {return}
            
            POST_REF.document(postID).getDocument { (snapshot, error) in
                if let _ = error{
                    return
                }
                guard let data = snapshot?.data() else {return}
                let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                
                if !usersUpvoted.isEmpty{
                    for i in usersUpvoted{
                        if i == userID{
                            if !self.userPosts.isEmpty{
                                cell.upvoteButton.setImage(UIImage(named: "upvote"), for: .normal)
                                self.userPosts[index].didUpvote = true
                            }
                            return
                        }else{
                            if !self.userPosts.isEmpty{
                                cell.upvoteButton.setImage(UIImage(named: "disvote"), for: .normal)
                                self.userPosts[index].didUpvote = false
                            }
                        }
                    }
                }else{
                    if !self.userPosts.isEmpty{
                        cell.upvoteButton.setImage(UIImage(named: "disvote"), for: .normal)
                        self.userPosts[index].didUpvote = false
                    }
                }
            }
        }
    }
    
    
    func configureLikes(index: Int, cell: FeedCollectionViewCell){
        if !userPosts.isEmpty{
            guard let userID = Auth.auth().currentUser?.uid else {return}
            guard let postID = userPosts[index].postID else {return}
            
            POST_REF.document(postID).getDocument { (snapshot, error) in
                if let _ = error{
                    return
                }
                guard let data = snapshot?.data() else {return}
                let usersLiked = data["usersLiked"] as? [String] ?? [String]()
                
                if !usersLiked.isEmpty{
                    for i in usersLiked{
                        if i == userID{
                            if !self.userPosts.isEmpty{
                                cell.likesButton.setImage(UIImage(named: "like"), for: .normal)
                                self.userPosts[index].didLike = true
                            }
                            return
                        }else{
                            if !self.userPosts.isEmpty{
                                cell.likesButton.setImage(UIImage(named: "dislike"), for: .normal)
                                self.userPosts[index].didLike = false
                            }
                        }
                    }
                }else{
                    if !self.userPosts.isEmpty{
                        cell.likesButton.setImage(UIImage(named: "dislike"), for: .normal)
                        self.userPosts[index].didLike = false
                    }
                }
            }
        }
    }
    
//    This
    func configureFollow(index: Int, cell: FeedCollectionViewCell){
        if !userPosts.isEmpty{
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            guard let postUserID = userPosts[index].userID else {return}
            FOLLOWING_REF.document(currentUserID).getDocument { (snapshot, error) in
                if let _ = error{
                    return
                }
                guard let data = snapshot?.data() else {return}
                let postUser = data[postUserID] as? Bool ?? false
                if postUser{
                    if !self.userPosts.isEmpty{
                        self.userPosts[index].didFollow = true
                        cell.followButton.setTitle("Following", for: .normal)
                        cell.followButton.setTitleColor(.label, for: .normal)
                    }
                }else{
                    if !self.userPosts.isEmpty{
                        self.userPosts[index].didFollow = false
                        cell.followButton.setTitle("Follow", for: .normal)
                        cell.followButton.setTitleColor(.systemRed, for: .normal)
                    }
                }
                if currentUserID == postUserID{
                    cell.followButton.isHidden = true
                }else{
                    if self.typeVC != "feed"{
//                        cell.followButton.isHidden = false
                        cell.followButton.isHidden = true
                    }
                }
            }
            
        }
        cell.followButton.isHidden = true
        
    }
    
    
//    MARK: - Handlers
    
    @objc private func handleRefresh(){
        fetchPosts()
    }
    
    @objc func handleNotifications(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            //setNotificationsChecked()
            //notificationBadge.remove(animated: true)
            let notificationsVC = NotificationVC()
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(notificationsVC, animated: true)
        }
        
    }
    
    @objc func handleCamera(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let cameraVC = CameraVC()
            navigationController?.view.semanticContentAttribute = .forceRightToLeft
            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
            navigationController?.pushViewController(cameraVC, animated: true)
        }
    }
    
    func handleUserProfile(for header: FeedHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let currentuserId = Auth.auth().currentUser?.uid else {return}
            DataService.instance.fetchPartnerUser(with: currentuserId) { (user) in
                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                profileVC.user = user
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
        
    }
    
    func handlePost(for header: FeedHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let postVC = UploadPostVC()
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(postVC, animated: false)
        }
    }
    
    func handleOpenGallery(for header: FeedHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let postVC = UploadPostVC()
            postVC.isGalleryOpen = true
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(postVC, animated: false)
        }
        
    }
    
    func handleLikesTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            cell.likesButton.isEnabled = false
            guard let indexPath = collectionView.indexPath(for: cell) else {return}

            if !userPosts[indexPath.row].didLike{
                userPosts[indexPath.row].likes += 1
                cell.likesLabel.text = "\((userPosts[indexPath.row].likes) ?? 0) likes"
                cell.likesButton.setImage(UIImage(named: "like"), for: .normal)
                updateLikes(index: indexPath.row)
                cell.likesButton.isEnabled = true
                return
            }else{
                userPosts[indexPath.row].likes -= 1
                cell.likesLabel.text = "\((userPosts[indexPath.row].likes) ?? 0 ) likes"
                cell.likesButton.setImage(UIImage(named: "dislike"), for: .normal)
                updateLikes(index: indexPath.row)
                cell.likesButton.isEnabled = true
                return
            }
        }
    }
    
    func handleUpvotesTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let upvoteCredits = UserDefaults.standard.integer(forKey: UPVOTE_CREDITS)
            if upvoteCredits >= 20{
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                cell.upvoteButton.isEnabled = false
                guard let indexPath = collectionView.indexPath(for: cell) else {return}
                
                if !userPosts[indexPath.row].didUpvote{
                    userPosts[indexPath.row].upvotes += 1
                    cell.upvotesLabel.text = "\((userPosts[indexPath.row].upvotes) ?? 0) upvotes"
                    cell.upvoteButton.setImage(UIImage(named: "upvote"), for: .normal)
                    updateUpvotes(index: indexPath.row)
                    cell.upvoteButton.isEnabled = true
                    return
                }else{
                    userPosts[indexPath.row].upvotes -= 1
                    cell.upvotesLabel.text = "\((userPosts[indexPath.row].upvotes) ?? 0 ) upvotes"
                    cell.upvoteButton.setImage(UIImage(named: "disvote"), for: .normal)
                    updateUpvotes(index: indexPath.row)
                    cell.upvoteButton.isEnabled = true
                    return
                }
            }else{
                ProgressHUD.showError("Not Enough Credits! Try using the app more to earn upvote credits.")
            }
            
        }
    }
    
    func handleUpvotesLabelTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            let likesVC = LikesVC(collectionViewLayout: UICollectionViewFlowLayout())
            likesVC.usersLiked = userPosts[indexPath.row].usersUpvoted
            likesVC.selectedPost = userPosts[indexPath.row]
            likesVC.isUpvote = true
            navigationController?.pushViewController(likesVC, animated: true)
        }
    }
    
    private func handleHastagTapped(for cell: FeedCollectionViewCell){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            cell.descriptionLabel.handleHashtagTap { (hashtag) in
                print(hashtag)
                let hashtagVC = HashtagVC(collectionViewLayout: UICollectionViewFlowLayout())
                hashtagVC.hashtag = hashtag
                self.navigationController?.pushViewController(hashtagVC, animated: true)
            }
        }
    }
    
    private func handleMentionsTapped(for cell: FeedCollectionViewCell){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            cell.descriptionLabel.handleMentionTap { (username) in
                DataService.instance.fetchUserWithUsername(with: username) { (user) in
                    let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                    profileVC.user = user
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
        
    }
    
    func handleCommentsTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
            commentVC.postId = userPosts[indexPath.row].postID
            commentVC.timeAgoToDisplay = userPosts[indexPath.row].creationDate.timeAgoToDisplay()
            commentVC.username = userPosts[indexPath.row].username
            commentVC.postDescription = userPosts[indexPath.row].description
            commentVC.profileImageUrl = userPosts[indexPath.row].profileImageURL
            commentVC.userId = userPosts[indexPath.row].userID
            commentVC.post = userPosts[indexPath.row]
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(commentVC, animated: true)
        }
        
    }
    
    func handleUsernameTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            if !userPosts.isEmpty{
                guard let indexPath = collectionView.indexPath(for: cell) else {return}
                guard let userId = self.userPosts[indexPath.row].userID else {return}
                DataService.instance.fetchPartnerUser(with: userId) { (user) in
                    let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                    profileVC.user = user
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }
       
    func handleFollow(for cell: FeedCollectionViewCell) {
        
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            if !userPosts[indexPath.row].didFollow{
                cell.followButton.setTitle("Following", for: .normal)
                cell.followButton.setTitleColor(.label, for: .normal)
                self.updateFollowing(index: indexPath.row)
            }else{
                cell.followButton.setTitle("Follow", for: .normal)
                cell.followButton.setTitleColor(.systemRed, for: .normal)
                self.updateFollowing(index: indexPath.row)
            }
        }
    }
    
    func handleThreeDotTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            guard let userdId = self.userPosts[indexPath.row ].userID else {return}
           guard let currentUserId = Auth.auth().currentUser?.uid else  {return}
           
           if userdId == currentUserId{
               showAlertForCurrentUser(index: indexPath.row)
           }else{
               showAlertForOtherUser(index: indexPath.row)
           }
        }
     }
    
    private func handleUrlTapped(for cell: FeedCollectionViewCell){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            cell.descriptionLabel.handleURLTap { (url) in
                if UIApplication.shared.canOpenURL(url){
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
                    return
                }else{
                    self.toast = SwiftToast(text: "Invalid website url found.")
                    self.present(self.toast, animated: true)
                    return
                }
            }
        }
    }
    
    func handleActiveLabelUsernameTapped(for cell: FeedCollectionViewCell, username: String){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            handleUsernameTapped(for: cell)
        }
    }
     
    func handleLikesLabelTapped(for cell: FeedCollectionViewCell) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            let likesVC = LikesVC(collectionViewLayout: UICollectionViewFlowLayout())
            likesVC.usersLiked = userPosts[indexPath.row].usersLiked
            likesVC.selectedPost = userPosts[indexPath.row]
            navigationController?.pushViewController(likesVC, animated: true)
        }
    }
    
    func handleDescriptionLabelTapped(for cell: FeedCollectionViewCell) {
      
    }
    
    func handleSlideShowTapped(for cell: FeedCollectionViewCell) {
        cell.slideShow.presentFullScreenController(from: self)
    }
    
    func handleStory(for cell: StoryCollectionViewCell, indexPath: IndexPath) {
        debugPrint(indexPath)
        if indexPath.row == 0{
            let createStoryVC = CreateStoryVC()
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(createStoryVC, animated: false)
        }else{
            let storyVC = StoryVC()
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(storyVC, animated: false)
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
    
    private func showAlertForCurrentUser(index: Int){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (action) in
            let editPostVC = EditPostVC()
            editPostVC.postId = self.userPosts[index].postID
            self.present(editPostVC, animated: true)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (action) in
            let alertVCInside = UIAlertController(title: "Delete", message: "Do you want to delete this post?", preferredStyle: .alert)
            alertVCInside.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                self.showIndicatorView()
                self.deletePost(index: index)

            }))
            alertVCInside.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertVCInside, animated: true, completion: nil)
            
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showAlertForOtherUser(index: Int){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { (action) in
            let alertVC = UIAlertController(title: nil, message: "Do you want to report this Post?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
                guard let username = self.userPosts[index].username else {return}
                guard let postId = self.userPosts[index].postID else {return}
                let reportData = [DataService.instance.randomString(length: 20) :["username": username, "postId": postId, "creationDate": self.userPosts[index].creationDate.timeIntervalSince1970]]
                
                REPORT_REF.document("reportedPosts").setData(reportData, merge: true)
                self.toast = SwiftToast(text: "You have reported \(username)'s post!")
                self.present(self.toast, animated: true)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertVC, animated: true)
            
            
            
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
//    MARK: - API
    
    private func fetchPosts(){
        print(typeVC)
        if typeVC == "feed"{
            fetchFeedPosts()
        }else if typeVC == "explore"{
            fetchExplorePosts()
        }else if typeVC == "profile"{
            fetchProfilePosts()
        }else if typeVC == "category"{
            fetchCategoryPosts()
        }else{
            guard let userId = self.userId else {return}
            fetchAnonymousPosts(userId: userId)
        }
    }
    
    private func fetchExplorePosts(){
//        guard let scrollIndex = self.scrollIndex else {return}
//        self.collectionView.reloadData()
//        self.collectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: .top, animated: false)
//        self.collectionView.refreshControl?.endRefreshing()
        
//        userPosts.removeAll()
//        documents.removeAll()
//        showIndicatorView()
        
        POST_REF.whereField("category", isEqualTo: self.category).limit(to: 20).order(by: "creationDate", descending: true).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                return
            }

            guard let snapshot = snapshot else {return}
            if snapshot.documents.isEmpty{
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
                    let userID = data["userId"] as? String ?? "userID"
                    let username = data["username"] as? String ?? "username"
                    let postType = data["postType"] as? String ?? ""
                    let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
                    let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
                    let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
                    let followersCount = data["followersCount"] as? Int ?? 10
                    
                    let posts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
                    if !self.blockedUsers.contains(userID){
                        if self.userPosts.first?.postID != postID{
                            self.userPosts.append(posts)
                        }
                    }
                }
            }
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            self.collectionView.refreshControl?.endRefreshing()
        }
        
    }
    
    
    private func fetchProfilePosts(){
        guard let scrollIndex = self.scrollIndex else {return}
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: .top, animated: false)
        self.collectionView.refreshControl?.endRefreshing()

    }
    
    private func fetchFeedPosts(){
        userPosts.removeAll()
        userFollowingIDs.removeAll()
        documents.removeAll()
        self.hasMore = true
        showIndicatorView()
        query = POST_REF.limit(to: 20).order(by: "creationDate", descending: true)
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        self.userFollowingIDs.append(currentUserId)
//        fetchFollowingUserIDs { (success, error) in
//            if success{
//                if self.userFollowingIDs.count > 1{
//                    self.getFeedPosts()
//                }else{
//                    self.hasNoFollowers = true
//                    self.getFeedPosts()
//                }
//            }
//        }
        
        self.hasNoFollowers = true
        self.getFeedPosts() 
    }
    
    func getFeedPosts() {
        query.whereField("username", in: userFollowingIDs)
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
                    if !self.blockedUsers.contains(userID){
                        if self.hasNoFollowers{
                            self.documents.append(document)
                            self.userPosts.append(posts)
                            self.userPosts.sort { (post1, post2) -> Bool in
                                return post1.creationDate > post2.creationDate
                            }
                        }else{
                            if self.userFollowingIDs.contains(where: {$0 == userID}) {
                                self.documents.append(document)
                                self.userPosts.append(posts)
                                self.userPosts.sort { (post1, post2) -> Bool in
                                    return post1.creationDate > post2.creationDate
                                }
                            }
                        }
                    }
                    
                }
            }
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func paginateFeed() {
        query = query.start(afterDocument: documents.last!)
        getFeedPosts()
    }
    
    private func fetchAnonymousPosts(userId: String){
        userPosts.removeAll()
        POST_REF.whereField("userId", isEqualTo: "\(userId)").getDocuments { (snapshot, error) in
            if let error = error{
                self.collectionView.refreshControl?.endRefreshing()
                self.toast = SwiftToast(text: "An error Occured. Error description: \n \(error.localizedDescription)")
                self.present(self.toast, animated: true)
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
                
                if !self.blockedUsers.contains(userID){
                    self.userPosts.append(posts)
                    self.userPosts.sort { (post1, post2) -> Bool in
                        post1.creationDate > post2.creationDate
                    }
                }
                
            }
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            guard let scrollIndex = self.scrollIndex else {return}
            self.collectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: .top, animated: false)
        }
    }
    
    private func fetchCategoryPosts(){
        guard let postCategory = self.postCategory else {return}
        showIndicatorView()
        userPosts.removeAll()
        documents.removeAll()
        self.hasMore = true
        query = POST_REF.limit(to: 20).whereField("category", isEqualTo: postCategory)
        getCategoryData()
    }
    
    private func getCategoryData(){
        query.getDocuments { (snapshot, error) in
            if let _ = error{
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            if snapshot.documents.isEmpty{
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                self.hasMore = false
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
    
                    if !self.blockedUsers.contains(userID){
                        self.documents.append(document)
                        self.userPosts.append(posts)
                        self.userPosts.sort { (post1, post2) -> Bool in
                            post1.creationDate > post2.creationDate
                        }
                    }
                    
                }
            }
            
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.dismissIndicatorView()
        }
    }
    
    private func paginateCategoryData(){
        query = query.start(afterDocument: documents.last!)
        getCategoryData()
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
    
    private func updateLikes(index: Int){
        guard let usersLiked = userPosts[index].usersLiked else {return}
        var newusersLikes = usersLiked
        if !userPosts[index].didLike{
            newusersLikes.append(Auth.auth().currentUser?.uid ?? "")
            let likeData = ["likes": FieldValue.increment(Int64(1)), "usersLiked":  newusersLikes] as [String : Any]
            POST_REF.document(userPosts[index].postID).updateData(likeData) { (error) in
                if let _ = error{
                    return
                }
                self.userPosts[index].didLike = !self.userPosts[index].didLike
                NotificationService.instance.sendLikeNotification(post: self.userPosts[index], didLike: true)
                return
            }
        }else{
            newusersLikes = newusersLikes.filter{$0 != Auth.auth().currentUser?.uid ?? ""}
            let likeData = ["likes": FieldValue.increment(Int64(-1)), "usersLiked":  newusersLikes] as [String : Any]
            POST_REF.document(userPosts[index].postID).updateData(likeData) { (error) in
                if let _ = error{
                    return
                }
                self.userPosts[index].didLike = !self.userPosts[index].didLike
                NotificationService.instance.sendLikeNotification(post: self.userPosts[index], didLike: false)
                return
            }
            
        }
        
    }
    
    private func fetchBlockedUsers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            guard let blockedUsers = user.blockedUsers else {return}
            self.blockedUsers = blockedUsers
        }
    }
    
    private func updateUpvotes(index: Int){
        guard let usersUpvoted = userPosts[index].usersUpvoted else {return}
        var newusersUpvoted = usersUpvoted
        if !userPosts[index].didUpvote{
            newusersUpvoted.append(Auth.auth().currentUser?.uid ?? "")
            let upvoteData = ["upvotes": FieldValue.increment(Int64(1)), "usersUpvoted":  newusersUpvoted] as [String : Any]
            POST_REF.document(userPosts[index].postID).updateData(upvoteData) { (error) in
                if let _ = error{
                    return
                }
                let upvoteCredits = UserDefaults.standard.integer(forKey: UPVOTE_CREDITS)
                let newCredits = upvoteCredits - 20
                UserDefaults.standard.set(newCredits, forKey: UPVOTE_CREDITS)
                UserDefaults.standard.synchronize()
                ProgressHUD.showSuccess("You have \(newCredits) upvote credits remaining!")
                self.userPosts[index].didUpvote = !self.userPosts[index].didUpvote
                NotificationService.instance.sendUpvoteNotification(post: self.userPosts[index], didUpvote: true)
                return
            }
        }else{
            newusersUpvoted = newusersUpvoted.filter{$0 != Auth.auth().currentUser?.uid ?? ""}
            let upvoteData = ["upvotes": FieldValue.increment(Int64(-1)), "usersUpvoted":  newusersUpvoted] as [String : Any]
            POST_REF.document(userPosts[index].postID).updateData(upvoteData) { (error) in
                if let _ = error{
                    return
                }
                self.userPosts[index].didUpvote = !self.userPosts[index].didUpvote
                NotificationService.instance.sendUpvoteNotification(post: self.userPosts[index], didUpvote: false)
                return
            }
            
        }
    }
    
    private func updateFollowing(index: Int){
        if !userPosts[index].didFollow{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            guard let postUserId = userPosts[index].userID else {return}
            let currentUserData = ["\(postUserId)": true]
            let postUserData = ["\(currentUserId)": true]
            FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                FOLLOWERS_REF.document(postUserId).setData(postUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    self.userPosts[index].didFollow = !self.userPosts[index].didFollow
                    NotificationService.instance.sendFollowNotification(userId: postUserId, didFollow: true)
                }
            }
            
        }else{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            guard let postUserId = userPosts[index].userID else {return}
            let currentUserData = ["\(postUserId)": false]
            let postUserData = ["\(currentUserId)": false]
            FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                if let _ = error{
                    return
                }
                FOLLOWERS_REF.document(postUserId).setData(postUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    self.userPosts[index].didFollow = !self.userPosts[index].didFollow
                    NotificationService.instance.sendFollowNotification(userId: postUserId, didFollow: false)
                }
            }
        }
        
    }
    
    private func observeNotification(){
//        self.notificationCount = 0
//        self.notificationIds.removeAll()
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//        NOTIFICATIONS_REF.child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
//
//            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
//
//            allObjects.forEach { (snapshot) in
//                let notificationId = snapshot.key
//                NOTIFICATIONS_REF.child(currentUserId).child(notificationId).child("checked").observeSingleEvent(of: .value) { (snapshot) in
//
//                    guard let checked = snapshot.value as? Int else {return}
//                    if checked == 0{
//                        self.notificationIds.append(notificationId)
//                        self.notificationCount += 1
//                        self.notificationBadge.addOrReplaceCurrent(with: "\(self.notificationCount)", animated: true)
//                    }else{
//
//                    }
//                }
//            }
//        }
//        if self.notificationCount == 0{
//            self.notificationBadge.remove(animated: true)
//        }
//    }
//
//    private func setNotificationsChecked(){
//        if !notificationIds.isEmpty{
//            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//            for notificationId in notificationIds{
////                NOTIFICATIONS_REF.child(currentUserId).child(notificationId).child("checked").setValue(1)
//            }
//        }
        
    }
    
    private func deletePost(index: Int){
        showIndicatorView()
        guard let postId = self.userPosts[index].postID else {return}
        guard let imageUrls = self.userPosts[index].imageUrls else {return}
        POST_REF.document(postId).delete { (error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            REPORT_POST_REF.whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
                if let _ = error{
                    self.dismissIndicatorView()
                    return
                }
                guard let snapshot = snapshot else {
                    self.dismissIndicatorView()
                    return
                    
                }
                for document in snapshot.documents{
                    let documentId = document.documentID
                    
                    REPORT_POST_REF.document(documentId).delete()
                }
                
                COMMENT_REF.whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
                    if let _ = error{
                        self.dismissIndicatorView()
                        return
                    }
                    guard let snapshot = snapshot else {
                        self.dismissIndicatorView()
                        return
                        
                    }
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        COMMENT_REF.document(documentId).delete()
                    }
                    
                    HASHTAG_POST_REF.whereField(postId, isEqualTo: "postId").getDocuments { (snapshot, error) in
                        if let _ = error{
                            self.dismissIndicatorView()
                            return
                        }
                        guard let snapshot = snapshot else {
                            self.dismissIndicatorView()
                            return
                        }
                        for document in snapshot.documents{
                            let documentId = document.documentID
                            HASHTAG_POST_REF.document(documentId).updateData([postId: FieldValue.delete()]){ error in
                                if let _ = error {
                                    self.dismissIndicatorView()
                                    return
                                } else {
                                    imageUrls.forEach { (url) in
                                        Storage.storage().reference(forURL: url).delete(completion: nil)
                                    }
                                    self.userPosts.remove(at: index)
                                    self.toast = SwiftToast(text: "Your post has been deleted successfully.")
                                    self.present(self.toast, animated: true)
                                    self.collectionView.reloadData()
                                    self.dismissIndicatorView()
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    
    private func setFCMToken(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let fcmToken = Messaging.messaging().fcmToken else {return}
        let values = ["fcmToken": fcmToken]
        USER_REF.document(currentUserId).updateData(values)
    }

    
    
   
}


 
