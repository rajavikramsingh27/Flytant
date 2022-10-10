//
//  NotificationTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 26/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class NotificationTableViewCell: UITableViewCell {
    
//    MARK: - Properties
    
    var delegate: NotificationCellDelegate?
    
    var userFollowingIDs = [String]()
    
    var notification: Notification? {
        didSet{
            guard let profileImageUrl = notification?.senderProfileImageUrl else {return}
            profileImageView.loadImage(with: profileImageUrl)
            
            guard let username = notification?.senderUsername else {return}
            guard let type = notification?.type else {return}
            guard let postImageUrl = notification?.postImageUrl else {return}
            guard let notificationDate = getNotificationTimeStamp() else { return }
            configureFollowPosts(type: type, username: username, creationDate: notificationDate)
            postImageView.loadImage(with: postImageUrl)
        }
    }
    
//    MARK: - Views
     
    var profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage(named: "emptyProfileIcon")!)
    var notificationLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
    var followButton = FButton(backgroundColor: UIColor(red: 15/255, green: 145/255, blue: 183/255, alpha: 1), title: "Follow", cornerRadius: 3, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
    var postImageView = FImageView(backgroundColor: UIColor.secondarySystemBackground, cornerRadius: 0, image: UIImage())
//    var messageButton = FGradientButton(cgColors: [UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    var messageButton = FButton(backgroundColor: UIColor.systemBackground, title: "Message", cornerRadius: 5, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Bold", size: 14)!)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        configureViews()
    }
    
    
    private func configureViews(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 28)
        followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        addSubview(messageButton)
        messageButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 28)
        messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        messageButton.layer.borderWidth = 1
        messageButton.layer.borderColor = UIColor.label.cgColor
        messageButton.layer.shadowColor = UIColor.gray.cgColor
        messageButton.layer.shadowOpacity = 0.4
//        messageButton.setTitle("Message", for: .normal)
//        messageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        messageButton.gradientLayer.cornerRadius = 3
        
        addSubview(postImageView)
        postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
        postImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        tapGesture.numberOfTapsRequired = 1
        postImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            messageButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            postImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        
        addSubview(notificationLabel)
        notificationLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 96, width: 0, height: 0)
        
    }
    
    private func configureFollowPosts(type: Int, username: String, creationDate: String){
        if type == 0{
            messageButton.isHidden = true
            postImageView.isHidden = false
            followButton.isHidden = true
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " liked your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " \(creationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            notificationLabel.numberOfLines = 2

        }else if type == 1{
            messageButton.isHidden = true
            postImageView.isHidden = false
            followButton.isHidden = true
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " upvoted your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " \(creationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            notificationLabel.numberOfLines = 2
            
        }else if type == 2{
            messageButton.isHidden = true
            postImageView.isHidden = true
            followButton.isHidden = false
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " started following you", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " \(creationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            notificationLabel.numberOfLines = 2
            
        }else if type == 3{
            messageButton.isHidden = true
            postImageView.isHidden = false
            followButton.isHidden = true
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " commented on your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " \(creationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            notificationLabel.numberOfLines = 2
            
        }else if type == 5{
            messageButton.isHidden = false
            postImageView.isHidden = true
            followButton.isHidden = true
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " applied for your campaign", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " \(creationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            notificationLabel.numberOfLines = 2
        }
        
        
        fetchFollowingUserIDs { (success, error) in
            if success{
                if self.userFollowingIDs.contains(where: {$0 == self.notification?.senderId}){
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.backgroundColor = UIColor.systemBackground
                    self.followButton.setTitleColor(UIColor.label, for: .normal)
                    self.followButton.layer.borderColor = UIColor.label.cgColor
                    self.followButton.layer.borderWidth = 1
                }else{
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
                    self.followButton.setTitleColor(UIColor.white, for: .normal)
                    self.followButton.layer.borderColor = UIColor.clear.cgColor
                    self.followButton.layer.borderWidth = 1
                }
            }
        }
    }
    
    func getNotificationTimeStamp() -> String? {
        guard let notification = self.notification else { return nil }
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: notification.creationDate, to: now)
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
    
//    MARK: - Delegate
    
    @objc private func handlePostTapped(){
        delegate?.handlePostTapped(for: self)
    }
    
    @objc private func handleFollow(){
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc private func handleMessage(){
        delegate?.handleMessageTapped(for: self)
    }
}
