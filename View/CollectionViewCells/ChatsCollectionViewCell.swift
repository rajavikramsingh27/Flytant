//
//  ChatsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 06/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import SDWebImage

class ChatsCollectionViewCell: UICollectionViewCell {
    
    var chat: Chats? {
        didSet{
            guard let chatImageUrl = chat?.chatImageUrl else {return}
            profileImageView.sd_setImage(with: URL(string: chatImageUrl), placeholderImage: UIImage(named: "profile_bottom"))
            
            guard let withUsername = chat?.withUsername else {return}
            usernameLabel.text = withUsername
            
            guard let creationDate = chat?.creationDate else {return}
            timeLabel.text = creationDate.timeAgoToDisplay()
            
            guard let lastMessage = chat?.lastMessage else {return}
            messageLabel.text = lastMessage
            
            guard let counter = chat?.counter else {return}
            if counter > 0{
                notificationLabel.isHidden = false
                notificationLabel.text = "\(counter)"
            }else{
                notificationLabel.isHidden = true
            }
        }
    }
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 24, image: UIImage())
    
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let messageLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let notificationLabel = FLabel(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.white)
    
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViews(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        addSubview(notificationLabel)
        notificationLabel.anchor(top: timeLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 24, height: 16)
        notificationLabel.textAlignment = .center
        notificationLabel.layer.cornerRadius = 8
        notificationLabel.layer.masksToBounds = true
        
        addSubview(messageLabel)
        messageLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: notificationLabel.leftAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 24, width: 0, height: 16)
        messageLabel.numberOfLines = 1
        
        addSubview(separatorView)
        separatorView.anchor(top: profileImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.4)
        separatorView.backgroundColor = UIColor.systemGray3
    }
}
