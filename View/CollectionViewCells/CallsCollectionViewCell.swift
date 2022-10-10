//
//  CallsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 16/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class CallsCollectionViewCell: UICollectionViewCell {

    var chatCalls: ChatCalls? {
        didSet{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            guard let callDate = chatCalls?.callDate.timeAgoToDisplay() else {return}
            timeLabel.text = callDate
            
            guard let status = chatCalls?.status else {return}
            guard let callerId = chatCalls?.callerId else {return}
            guard let withUserName = chatCalls?.withUserName else {return}
            guard let callerName = chatCalls?.callerName else {return}
            
            if callerId == currentUserId{
                statusLabel.text = "📞 Outgoing"
                nameLabel.text = withUserName
                let profileImageText = String(withUserName.prefix(1))
                profileImageLabel.text = profileImageText.capitalized
            }else{
                statusLabel.text = "📞 Incoming"
                nameLabel.text = callerName
                let profileImageText = String(callerName.prefix(1))
                profileImageLabel.text = profileImageText.capitalized
            }
            
        }
    }
    
    let profileImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 24, image: UIImage())
    
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "Come on", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "5 days ago", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let statusLabel = FLabel(backgroundColor: UIColor.clear, text: "hye", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let profileImageLabel = FLabel(backgroundColor: UIColor.clear, text: "dfg", font: UIFont.boldSystemFont(ofSize: 24), textAlignment: .center, textColor: UIColor.white)
    
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
        
        profileImageView.addSubview(profileImageLabel)
        profileImageLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
       
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        addSubview(statusLabel)
        statusLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 24, width: 0, height: 16)
        statusLabel.numberOfLines = 1
        
        addSubview(separatorView)
        separatorView.anchor(top: profileImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.4)
        separatorView.backgroundColor = UIColor.systemGray3
    }
}


