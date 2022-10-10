//
//  InstagramProfileCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 03/03/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

class InstagramProfileCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Views
    
    let profileIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 16, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 16)!, textAlignment: .left, textColor: UIColor.label)
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 10)!, textAlignment: .left, textColor: UIColor.label)
    let postIV = FImageView(backgroundColor: UIColor.secondarySystemBackground, cornerRadius: 0, image: UIImage())
    let likesIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "like")!)
    let commentsIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "comment")!)
    let likesLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 10)!, textAlignment: .left, textColor: UIColor.systemGray)
    let commentsLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 10)!, textAlignment: .left, textColor: UIColor.systemGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        addSubview(profileIV)
        profileIV.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileIV.topAnchor, left: profileIV.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        addSubview(timeLabel)
        timeLabel.anchor(top: usernameLabel.bottomAnchor, left: profileIV.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 16)
        addSubview(postIV)
        postIV.anchor(top: timeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
        addSubview(likesIV)
        likesIV.anchor(top: postIV.bottomAnchor, left: postIV.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        addSubview(commentsIV)
        commentsIV.anchor(top: postIV.bottomAnchor, left: likesIV.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        addSubview(likesLabel)
        likesLabel.anchor(top: likesIV.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 56, height: 20)
        addSubview(commentsLabel)
        commentsLabel.anchor(top: commentsIV.bottomAnchor, left: likesLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
    }
    
}
