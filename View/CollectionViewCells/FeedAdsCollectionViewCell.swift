//
//  FeedAdsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 09/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit


class FeedAdsCollectionViewCell: UICollectionViewCell {
    
//    let adContentView = GADUnifiedNativeAdView()
    let iconImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage())
    let advertiserNameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
    let sponsoredLabel = FLabel(backgroundColor: UIColor.clear, text: "Sponsored", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
    lazy var threeDotButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
//    let adMediaView = GADMediaView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(adContentView)
//        adContentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        adContentView.addSubview(iconImageView)
//        iconImageView.anchor(top: adContentView.topAnchor, left: adContentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
//
//        adContentView.addSubview(advertiserNameLabel)
//        advertiserNameLabel.anchor(top: adContentView.topAnchor, left: iconImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
//
//        adContentView.addSubview(adMediaView)
//        adMediaView.anchor(top: iconImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
