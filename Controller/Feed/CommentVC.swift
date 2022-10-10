//
//  CommentVC.swift
//  Flytant
//
//  Created by Vivek Rai on 05/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "commentCollectionViewCell"
private let headerIdentifier = "commentHeaderIdentifier"

class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentCellDelegate, CommentHeaderDelegate{
    
//    MARK: - Properties
    var userComments = [Comments]()
    var postId: String?
    var timeAgoToDisplay: String?
    var username: String?
    var postDescription: String?
    var profileImageUrl: String?
    var userId: String?
    var post: Posts?
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    lazy var containerView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = CommentInputAccesoryView(frame: frame)
        containerView.delegate = self
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureRefreshControl()
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func configureCollectionView(){
        self.collectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(CommentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Comments"
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
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
    
//    MARK: - CollectionView Header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CommentHeader
        header.delegate = self
        if let profileImageUrl = self.profileImageUrl, let timeAgoToDisplay = self.timeAgoToDisplay, let description = self.postDescription, let username = self.username{
            
            let customType = ActiveType.custom(pattern: "^\(username)\\b")
            header.descriptionLabel.enabledTypes = [.mention, .hashtag, customType]
            header.descriptionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                    case .custom:
                        atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
                    default: ()
                }
                return atts
            }
                               
            header.descriptionLabel.customize { (label) in
                label.text = "\(username) \(description)"
                label.customColor[customType] = .label
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .label
                label.hashtagColor = .systemPink
                label.mentionColor = .systemPink
            }
                        
            header.descriptionLabel.handleCustomTap(for: customType) { (username) in
                if let userId = self.userId{
                    DataService.instance.fetchPartnerUser(with: userId) { (user) in
                        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        profileVC.user = user
                        self.navigationController?.pushViewController(profileVC, animated: true)
                    }
                }
            }
            
            header.profileImageView.loadImage(with: profileImageUrl)
            header.timeStampLabel.text = timeAgoToDisplay
        }
        
        handleHeaderHastagTapped(for: header)
        handleHeaderMentionsTapped(for: header)
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.zero

//        if let description = self.postDescription{
//            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
//            let dummyCell = CommentHeader(frame: frame)
//            dummyCell.descriptionLabel.text = description
//            dummyCell.layoutIfNeeded()
//            let targetSize = CGSize(width: view.frame.width, height: 1000)
//            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
//            let height = max(0, estimatedSize.height)
//            return CGSize(width: view.frame.width, height: height)
//        }else{
//            return CGSize.zero
//        }

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
        let dummyCell = CommentCollectionViewCell(frame: frame)
        dummyCell.comments = userComments[indexPath.item]
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
        return userComments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCollectionViewCell
        cell.delegate = self
        if !self.userComments.isEmpty{
            cell.comments = userComments[indexPath.row]
        }
        
        handleHastagTapped(for: cell)
        
        handleMentionsTapped(for: cell)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

//    MARK: - Handlers
    
    @objc private func handleRefresh(){
        fetchComments()
    }

    func handleUsernameTapped(for cell: CommentCollectionViewCell) {
        if !userComments.isEmpty{
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            guard let userId = self.userComments[indexPath.row].userId else {return}
            DataService.instance.fetchPartnerUser(with: userId) { (user) in
                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                profileVC.user = user
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    func handleActiveLabelUsernameTapped(for cell: CommentCollectionViewCell, username: String) {
        handleUsernameTapped(for: cell)
    }
    
    private func handleHastagTapped(for cell: CommentCollectionViewCell){
        cell.descriptionLabel.handleHashtagTap { (hashtag) in
            print(hashtag)
            let hashtagVC = HashtagVC(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagVC.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagVC, animated: true)
        }
    }
    
    private func handleMentionsTapped(for cell: CommentCollectionViewCell){
        cell.descriptionLabel.handleMentionTap { (username) in
            DataService.instance.fetchUserWithUsername(with: username) { (user) in
                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                profileVC.user = user
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    func handleHeaderUsernameTapped(for cell: CommentHeader) {
        guard let userId = self.userId else {return}
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
       
    
    private func handleHeaderHastagTapped(for cell: CommentHeader){
        cell.descriptionLabel.handleHashtagTap { (hashtag) in
            print(hashtag)
            let hashtagVC = HashtagVC(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagVC.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagVC, animated: true)
        }
    }
    
    private func handleHeaderMentionsTapped(for cell: CommentHeader){
        cell.descriptionLabel.handleMentionTap { (username) in
            DataService.instance.fetchUserWithUsername(with: username) { (user) in
                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                profileVC.user = user
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
//    MARK: - API
    
    private func fetchComments(){
        showIndicatorView()
        guard let postId = self.postId else {return}
        COMMENT_REF.whereField("postId", isEqualTo: postId).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if let _ = error{
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
                return
            }
            self.userComments.removeAll()
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let username = data["username"] as? String ?? ""
                let userId = data["userId"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let commentText = data["commentText"] as? String ?? ""
                let creationDate = data["creationDate"] as? Double ?? 0
                let postId = data["postId"] as? String ?? ""
                
                let comments = Comments(postId: postId, profileImageUrl: profileImageUrl, commentText: commentText, creationDate: creationDate, username: username, userId: userId)
                self.userComments.append(comments)
                self.userComments.sort { (comment1, comment2) -> Bool in
                    comment1.creationDate > comment2.creationDate
                }
            }
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.dismissIndicatorView()
        }
    }
    
}

extension CommentVC: CommentInputAccesoryViewDelegate {
    
    func didSubmit(forComment comment: String) {
        if !comment.isEmpty{
            let commentText = comment
            let creationDate = Int(NSDate().timeIntervalSince1970)
            guard let userId = Auth.auth().currentUser?.uid else {return}
            guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
            guard let postId = self.postId else {return}
            guard let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
            let commentValue = ["commentText": commentText, "creationDate": creationDate, "userId": userId, "username": username, "postId": postId, "profileImageUrl": profileImageUrl] as [String : Any]
            
            COMMENT_REF.document().setData(commentValue, merge: true) { (error) in
                if let _ = error{
                    return
                }
                var upvoteCredits = UserDefaults.standard.integer(forKey: UPVOTE_CREDITS)
                upvoteCredits += 2
                UserDefaults.standard.set(upvoteCredits, forKey: UPVOTE_CREDITS)
      
//                guard let userId = self.userId else {return}
                guard let post = self.post else {return}
                debugPrint("here")
                NotificationService.instance.sendCommentNotification(post: post, commentText: commentText)
                debugPrint("Now Here")
            }
        }
        self.containerView.clearCommentTextView()
    }
    
}

