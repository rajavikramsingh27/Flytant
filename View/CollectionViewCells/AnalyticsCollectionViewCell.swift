//
//  AnalyticsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 25/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework

class AnalyticsCollectionViewCell: UICollectionViewCell {
    
    var posts: Posts? {
        didSet{
            guard let imageUrl = posts?.imageUrls else {return}
            if !imageUrl.isEmpty{
                postImageView.loadImage(with: imageUrl[0])
                postImageView.layer.borderColor = UIColor.randomFlat()?.cgColor
                postImageView.layer.borderWidth = 4
            }
            guard let likes = posts?.likes else {return}
            likesLabel.text = "\(likes) Likes"
            guard let followersCount = posts?.followersCount else {return}
            revenueLabel.text = "Revenue - $\((Analytics.getRevenue(followersCount: followersCount, likes: likes)*100).rounded()/100)"
        }
    }
    
    
    let postImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 0, image: UIImage())
    let likesLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
    let revenueLabel = FLabel(backgroundColor: UIColor.clear, text: "Revenue - 1190.65$", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 8, paddingBottom: 32, paddingRight: 8, width: 0, height: 0)
        postImageView.layer.cornerRadius = (frame.width/2)-8
        
        addSubview(likesLabel)
        likesLabel.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 12)
        likesLabel.minimumScaleFactor = 0.8
        addSubview(revenueLabel)
        revenueLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 12)
        revenueLabel.minimumScaleFactor = 0.8
    }
    
}
