//
//  NotificationsTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 17/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class NotificationsTableViewCell: UITableViewCell {
//
////    MARK: - Properties
//    var delegate: NotificatinCellDelegate?
//    
//    var userFollowingIDs = [String]()
//
//    var notification: Notification? {
//        didSet{
//            guard let user = notification?.user else {return}
//            guard let profileImageUrl = user.profileImageURL else {return}
//
//            configureNotificationLabel()
//            configureNotificationType()
//
//            profileImageView.loadImage(with: profileImageUrl)
//
//            if let post = notification?.post{
//                if !post.imageUrls.isEmpty{
//                    postImageView.loadImage(with: post.imageUrls[0])
//                }
//            }else{
//                print("Follow")
//            }
//        }
//    }
//
////    MARK: - Views
//
//    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage(named:"emptyProfileIcon")!)
//
//    let notificationLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
//
//    let followButton = FButton(backgroundColor: UIColor.systemRed, title: "Follow", cornerRadius: 3, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
//
//    let postImageView = FImageView(backgroundColor: UIColor.gray, cornerRadius: 0, image: UIImage())
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        selectionStyle = .none
//
//        addSubview(profileImageView)
//        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
//        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configureNotificationLabel(){
//        guard let notification = self.notification else {return}
//        guard let user = notification.user else {return}
//        guard let username = user.username else {return}
//        guard let notificationDate = getNotificationTimeStamp() else { return }
//        let notificationMessage = notification.notificationType.description
//
//        let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
//        attributedText.append(NSAttributedString(string: "\(notificationMessage) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
//        attributedText.append(NSAttributedString(string: "\(notificationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//        notificationLabel.attributedText = attributedText
//        notificationLabel.numberOfLines = 2
//    }
//
//    private func configureNotificationType(){
//        guard let notification = self.notification else {return}
//        guard let user = notification.user else {return}
////        var anchor: NSLayoutXAxisAnchor!
//        if notification.notificationType != .Follow{
//            followButton.isHidden = true
//            postImageView.isHidden = false
//            addSubview(postImageView)
//            postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
//            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////            anchor = postImageView.leftAnchor
//            postImageView.isUserInteractionEnabled = true
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
//            tapGesture.numberOfTapsRequired = 1
//            postImageView.addGestureRecognizer(tapGesture)
//        }else{
//            followButton.isHidden = false
//            postImageView.isHidden = true
//            addSubview(followButton)
//            followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 28)
//            followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////            anchor = followButton.leftAnchor
//            followButton.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
//            fetchFollowingUserIDs { (success, error) in
//                if success{
//                    if self.userFollowingIDs.contains(where: {$0 == user.userID}){
//                        self.followButton.setTitle("Following", for: .normal)
//                        self.followButton.backgroundColor = UIColor.systemBackground
//                        self.followButton.setTitleColor(UIColor.label, for: .normal)
//                        self.followButton.layer.borderColor = UIColor.label.cgColor
//                        self.followButton.layer.borderWidth = 1
//                    }else{
//                        self.followButton.setTitle("Follow", for: .normal)
//                        self.followButton.backgroundColor = UIColor.systemRed
//                        self.followButton.setTitleColor(UIColor.white, for: .normal)
//                        self.followButton.layer.borderColor = UIColor.label.cgColor
//                        self.followButton.layer.borderWidth = 1
//                    }
//                }
//            }
//        }
//
//        addSubview(notificationLabel)
//         notificationLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
//
//    }
//
//    private func fetchFollowingUserIDs(fetchComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
//        guard let userID = Auth.auth().currentUser?.uid else {return}
//        FOLLOWING_REF.document(userID).getDocument { (snapshot, error) in
//            if let _ = error{
//                fetchComplete(false, error)
//                return
//            }
//            if let data = snapshot?.data(){
//                for (i,j) in data{
//                    if (j as? Bool ?? false){
//                        self.userFollowingIDs.append(i)
//                    }
//                }
//                fetchComplete(true, nil)
//            }else{
//                fetchComplete(true, nil)
//            }
//        }
//    }
//
//    func getNotificationTimeStamp() -> String? {
//        guard let notification = self.notification else { return nil }
//
//        let dateFormatter = DateComponentsFormatter()
//        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
//        dateFormatter.maximumUnitCount = 1
//        dateFormatter.unitsStyle = .abbreviated
//        let now = Date()
//        return dateFormatter.string(from: notification.creationDate, to: now)
//    }
//
////    MARK: - Handlers
//
//    @objc private func handleFollowTapped(){
//        delegate?.handleFollowTapped(for: self)
//    }
//
//    @objc private func handlePostTapped(){
//        delegate?.handlePostTapped(for: self)
//    }
}
