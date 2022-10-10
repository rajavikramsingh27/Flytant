//
//  SocialPlatformsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 27/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation

class SocialPlatformsCollectionViewCell: UICollectionViewCell{
    
    
   let iconIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setUpView(){
        addSubview(iconIV)
        iconIV.tintColor = .label
        iconIV.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
    }
}

