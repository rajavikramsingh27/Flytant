//
//  SinglePostVC.swift
//  Flytant
//
//  Created by Vivek Rai on 02/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow
import ActiveLabel
import ChameleonFramework
import Firebase

class SinglePostVC: UIViewController {
    
//   MARK: - Properties
    var post: Posts?
    var sliderImages = [InputSource]()
    
//   MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let imageSlideshow = FImageSlideShow(backgroundColor: UIColor.clear)
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage(named:"emptyProfileIcon")!)
       
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "username", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
       
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "1 sec ago", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
       
    lazy var threeDotButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
       
    lazy var likesButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))

    lazy var commentsButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
       
    lazy var likesLabel = FLabel(backgroundColor: UIColor.clear, text: "0 likes", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
       
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        
        configureViews()
        configureLikes()
        setPostData()
        
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
    
//    MARK: - ConfigureViews
    
    private func configureNavigationBar(){
        navigationItem.title = "Post"
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func configureViews(){
        contentView.addSubview(profileImageView)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileTapped))
        profileTapGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(profileTapGesture)
        contentView.addSubview(usernameLabel)
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        let usernameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileTapped))
        usernameTapGesture.numberOfTapsRequired = 1
        usernameLabel.addGestureRecognizer(usernameTapGesture)
        contentView.addSubview(timeLabel)
        timeLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.minimumScaleFactor = 1
        
        contentView.addSubview(imageSlideshow)
        imageSlideshow.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        let slideShowGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideShowTapped))
        imageSlideshow.addGestureRecognizer(slideShowGestureRecognizer)
        contentView.addSubview(likesButton)
        likesButton.anchor(top: imageSlideshow.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        likesButton.setImage(UIImage(named: "dislike"), for: .normal)
        contentView.addSubview(commentsButton)
        commentsButton.anchor(top: imageSlideshow.bottomAnchor, left: likesButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        commentsButton.setImage(UIImage(named: "comment"), for: .normal)
        commentsButton.addTarget(self, action: #selector(commentsTapped), for: .touchUpInside)
        contentView.addSubview(likesLabel)
        likesLabel.isUserInteractionEnabled = true
        likesLabel.anchor(top: likesButton.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        let likestapGesture = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapped))
        likestapGesture.numberOfTapsRequired = 1
        likesLabel.addGestureRecognizer(likestapGesture)
        likesButton.addTarget(self, action: #selector(likesTapped), for: .touchUpInside)
//        contentView.addSubview(threeDotButton)
//        threeDotButton.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
//        threeDotButton.setImage(UIImage(named: "horizontalThreeDot"), for: .normal)
    
    }
    
    private func configureLikes(){
        guard let post = self.post else {return}
        POST_REF.document(post.postID).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let data = snapshot?.data() else {return}
            let likedUsers = data["usersLiked"] as? [String] ?? [String]()
            
            for i in likedUsers{
                if i == post.userID{
                    self.likesButton.setImage(UIImage(named: "like"), for: .normal)
                    post.didLike = true
                }
            }
        }
    }
    
    private func setPostData(){
        guard let post = self.post else {return}
        
        post.imageUrls.forEach { (url) in
            sliderImages.append(AlamofireSource(urlString: url)!)
        }
        imageSlideshow.setImageInputs(sliderImages)
        
        usernameLabel.text = post.username
        profileImageView.loadImage(with: post.profileImageURL)
        timeLabel.text = post.creationDate.timeAgoToDisplay()
        likesLabel.text = "\(post.likes ?? 0) likes"
        
        descriptionLabel.customize { (label) in
            label.text = post.description ?? ""
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .label
            label.hashtagColor = .systemPink
            label.mentionColor = .systemPink
        }
        
    }
    
    @objc private func likesTapped(){
        guard let post = self.post else {return}
        likesButton.isEnabled = false
        if !post.didLike{
            post.likes += 1
            likesLabel.text = "\((post.likes) ?? 0) likes"
            likesButton.setImage(UIImage(named: "like"), for: .normal)
            updateLikes()
            likesButton.isEnabled = true
            return
        }else{
            post.likes -= 1
            likesLabel.text = "\((post.likes) ?? 0 ) likes"
            likesButton.setImage(UIImage(named: "dislike"), for: .normal)
            updateLikes()
            likesButton.isEnabled = true
            return
        }
    }

    @objc private func commentsTapped(){
        guard let post = self.post else {return}
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.postId = post.postID
        commentVC.post = post
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    @objc private func handleProfileTapped(){
        guard let post = self.post else {return}
        DataService.instance.fetchPartnerUser(with: post.userID) { (user) in
            let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc private func slideShowTapped(){
        imageSlideshow.presentFullScreenController(from: self)
    }
    
    @objc private func likesLabelTapped(){
        guard let post = self.post else {return}
        let likesVC = LikesVC(collectionViewLayout: UICollectionViewFlowLayout())
        likesVC.usersLiked = post.usersLiked
        likesVC.selectedPost = post
        navigationController?.pushViewController(likesVC, animated: true)
    }
    
    private func updateLikes(){
        guard let post = self.post else {return}
        guard let usersLiked = post.usersLiked else {return}
        var newusersLikes = usersLiked
        if !post.didLike{
            newusersLikes.append(Auth.auth().currentUser?.uid ?? "")
            let likeData = ["likes": FieldValue.increment(Int64(1)), "usersLiked":  newusersLikes] as [String : Any]
            POST_REF.document(post.postID).updateData(likeData) { (error) in
                if let _ = error{
                    return
                }
                post.didLike = !post.didLike
                return
            }
        }else{
            newusersLikes = newusersLikes.filter{$0 != Auth.auth().currentUser?.uid ?? ""}
            let likeData = ["likes": FieldValue.increment(Int64(-1)), "usersLiked":  newusersLikes] as [String : Any]
            POST_REF.document(post.postID).updateData(likeData) { (error) in
                if let _ = error{
                    return
                }
                post.didLike = !post.didLike
                return
            }
        }
    }
    
}
