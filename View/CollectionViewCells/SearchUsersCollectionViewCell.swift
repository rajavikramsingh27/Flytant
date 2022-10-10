//
//  SearchUsersCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 07/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SearchUsersCollectionViewCell: UICollectionViewCell {
    
    var user: Users? {
        didSet{
            guard let profileImageUrl = user?.profileImageURL else {return}
            profileImageView.loadImage(with: profileImageUrl)
            
            guard let username = user?.username else {return}
            usernameLabel.text = username
            
            guard let name = user?.name else {return}
            nameLabel.text = name
        }
    }
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 24, image: UIImage())
    
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
     
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: .secondaryLabel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(profileImageView)
         profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
         NSLayoutConstraint.activate([
             profileImageView.centerYAnchor.constraint(equalToSystemSpacingBelow: centerYAnchor, multiplier: 1)
         ])
        
         addSubview(usernameLabel)
         usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
         addSubview(nameLabel)
         nameLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
    }
    
    
}
