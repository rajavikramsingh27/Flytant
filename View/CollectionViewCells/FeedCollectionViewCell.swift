//
//  FeedCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ActiveLabel
import ImageSlideshow
import ChameleonFramework
import FBAudienceNetwork

private let reuseIdentifier = "feedCollectionViewCell"

class FeedCollectionViewCell: UICollectionViewCell {
    
    var posts: Posts? {
        didSet{
            guard let profileImageUrl = posts?.profileImageURL else {return}
            profileImageView.loadImage(with: profileImageUrl)
            
            guard let username = posts?.username else {return}
            usernameLabel.text = username
            
            guard let imageUrls = posts?.imageUrls else {return}
            imageUrls.forEach { (url) in
                sliderImages.append(AlamofireSource(urlString: url)!)
            }
            slideShow.setImageInputs(sliderImages)
            sliderImages.removeAll()
            
            guard let creationDate = posts?.creationDate else {return}
            timeLabel.text = creationDate.timeAgoToDisplay()
            
            guard let likes = posts?.likes else {return}
            likesLabel.text = "\(likes) likes"
            
            guard let upvotes = posts?.upvotes else {return}
            upvotesLabel.text = "\(upvotes) upvotes"
            
            guard let description = posts?.description else {return}
       
            let customType = ActiveType.custom(pattern: "^\(username)\\b")
            descriptionLabel.enabledTypes = [.mention, .hashtag, customType]
            descriptionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                       
                switch type {
                    case .custom:
                        atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
                    default: ()
                }
                return atts
            }
            descriptionLabel.customize { (label) in
                
                label.text = "\(description)"
                label.customColor[customType] = .label
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .label
                label.hashtagColor = .systemPink
                label.mentionColor = .systemPink
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
            }
            
            descriptionLabel.handleCustomTap(for: customType) { (username) in
                self.handleActiveLabelUsernameTapped(username: username)
            }
            
        }
    }
    
    var sliderImages = [InputSource]()
    
    var delegate: FeedCellDelegate?
    
    var stackView: UIStackView!
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage(named:"emptyProfileIcon")!)
    
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
    
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "5 days ago", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let followButton = FButton(backgroundColor: UIColor.clear, title: "Follow", cornerRadius: 0, titleColor: UIColor(red: 246/255, green: 11/255, blue: 101/2551, alpha: 1), font: UIFont.boldSystemFont(ofSize: 14))
    
    lazy var threeDotButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
    
    lazy var likesButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))

    lazy var commentsButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
    
    lazy var upvoteButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
    
    lazy var likesLabel = FLabel(backgroundColor: UIColor.clear, text: "0 likes", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
    
    lazy var upvotesLabel = FLabel(backgroundColor: UIColor.clear, text: "0 upvotes", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: .label)
    
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
 
    let slideShow = FImageSlideShow(backgroundColor: UIColor.randomFlat())
   
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureProfileImageView()
        configureUsernameLabel()
        configureTimeLabel()
        configurefollowButton()
        configureThreeDotButton()
        configureDescriptionLabel()
        configureSlideShow()
        configureLikesButton()
        configureCommentsButton()
        configureUpvoteButton()
        configureLikesLabel()
        configureUpvoteLabel()
        configureSeparatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProfileImageView(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsername))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(tapGesture)
        
    }
    
    private func configureUsernameLabel(){
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        usernameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsername))
        tapGesture.numberOfTapsRequired = 1
        usernameLabel.addGestureRecognizer(tapGesture)
    }
    
    private func configureTimeLabel(){
        addSubview(timeLabel)
        timeLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
    }
    
    private func configurefollowButton(){
        addSubview(followButton)
        followButton.anchor(top: topAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
    }
    
    private func configureThreeDotButton(){
        addSubview(threeDotButton)
        threeDotButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        threeDotButton.setImage(UIImage(named: "horizontalThreeDot"), for: .normal)
        threeDotButton.addTarget(self, action: #selector(handleThreeDotTapped), for: .touchUpInside)
    }
    
    private func configureDescriptionLabel(){
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    private func configureSlideShow(){
        addSubview(slideShow)
        slideShow.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
        
    }
    
    private func configureLikesButton(){
        addSubview(likesButton)
        likesButton.anchor(top: slideShow.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        likesButton.setImage(UIImage(named: "dislike"), for: .normal)
        likesButton.addTarget(self, action: #selector(handleLikesTap), for: .touchUpInside)
        
    }
    
    private func configureCommentsButton(){
        addSubview(commentsButton)
        commentsButton.anchor(top: slideShow.bottomAnchor, left: likesButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        commentsButton.setImage(UIImage(named: "comment"), for: .normal)
        commentsButton.addTarget(self, action: #selector(handleCommentsTap), for: .touchUpInside)
    }
    
    private func configureUpvoteButton(){
        addSubview(upvoteButton)
        upvoteButton.anchor(top: slideShow.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 32, height: 32)
        upvoteButton.setImage(UIImage(named: "disvote"), for: .normal)
        upvoteButton.addTarget(self, action: #selector(handleUpvotesTapped), for: .touchUpInside)
        upvoteButton.isHidden =  true
    }
    
    private func configureLikesLabel(){
        addSubview(likesLabel)
        likesLabel.anchor(top: likesButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        likesLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikesLabelTap))
        tapGesture.numberOfTapsRequired = 1
        likesLabel.addGestureRecognizer(tapGesture)
    }
    
    private func configureUpvoteLabel(){
        addSubview(upvotesLabel)
        upvotesLabel.anchor(top: upvoteButton.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        upvotesLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUpvotesLabelTapped))
        tapGesture.numberOfTapsRequired = 1
        upvotesLabel.addGestureRecognizer(tapGesture)
        upvotesLabel.isHidden = true
    }
    
    private func configureSeparatorView(){
        addSubview(separatorView)
        separatorView.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 8)
        separatorView.backgroundColor = UIColor.systemGray6
    }
    
//    MARK: - Handlers
    
    @objc func didTap(){
        delegate?.handleSlideShowTapped(for: self)
    }
    
    @objc func handleFollow(){
        delegate?.handleFollow(for: self)
    }
    
    @objc func handleUsername(){
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleThreeDotTapped(){
        delegate?.handleThreeDotTapped(for: self)
    }
    
    @objc func handleLikesTap(){
        delegate?.handleLikesTapped(for: self)
    }
    
    @objc func handleCommentsTap(){
        delegate?.handleCommentsTapped(for: self)
    }
    
    @objc func handleLikesLabelTap(){
        delegate?.handleLikesLabelTapped(for: self)
    }
    
    @objc func handleUpvotesTapped(){
        delegate?.handleUpvotesTapped(for: self)
    }
    
    @objc func handleUpvotesLabelTapped(){
        delegate?.handleUpvotesLabelTapped(for: self)
    }
    
    @objc func handleDescriptionLabelTap(){
        delegate?.handleDescriptionLabelTapped(for: self)
    }
    
    @objc func handleActiveLabelUsernameTapped(username: String){
        delegate?.handleActiveLabelUsernameTapped(for: self, username: username)
    }
    
}

