//
//  BlockedCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 24/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class BlockedCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Views
    
    let blockedBackgroundView = UIView()
    
    let profileImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 24, image: UIImage())
    
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(blockedBackgroundView)
        blockedBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        blockedBackgroundView.backgroundColor = UIColor.secondarySystemBackground
        
        blockedBackgroundView.addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: blockedBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: blockedBackgroundView.centerYAnchor).isActive = true
        
        blockedBackgroundView.addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: blockedBackgroundView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
    }
}
