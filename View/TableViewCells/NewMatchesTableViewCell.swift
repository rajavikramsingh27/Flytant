//
//  NewMatchesTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 09/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class NewMatchesTableViewCell: UITableViewCell {
    
//    MARK: - Properties
    
    var swipedUser: SwipeMatches? {
        didSet{
            guard let bio = swipedUser?.bio else {return}
            guard let profileImageUrl = swipedUser?.profileImageUrl else {return}
            guard let username = swipedUser?.username else {return}
            profileImageView.loadImage(with: profileImageUrl)
            usernameLabel.text = username
            bioLabel.text = bio
        }
    }
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 24, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    let bioLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        addSubview(bioLabel)
        bioLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        bioLabel.numberOfLines = 1
        bioLabel.minimumScaleFactor = 0.8
    }

}
