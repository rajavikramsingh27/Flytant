//
//  DiscoverCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 04/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    var delegate: DiscverCellDelegate?
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 40, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: .label)
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: .secondaryLabel)
    
    let followButton = FButton(backgroundColor: UIColor.clear, title: "Follow", cornerRadius: 3, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 80, height: 80)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: centerXAnchor, multiplier: 1)
        ])
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
        
        addSubview(followButton)
        followButton.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 24)
        NSLayoutConstraint.activate([
            followButton.centerXAnchor.constraint(equalToSystemSpacingAfter: centerXAnchor, multiplier: 1)
        ])
        followButton.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        followButton.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFollowTapped(){
        delegate?.handleFollow(for: self)
    }
    
}
