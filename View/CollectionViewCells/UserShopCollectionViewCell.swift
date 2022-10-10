//
//  UserShopCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 14/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework

class UserShopCollectionViewCell: UICollectionViewCell {
    
    var shopPosts: ShopPosts? {
        didSet{
            guard let imageUrls = shopPosts?.imageUrls else {return}
            if !imageUrls.isEmpty{
                postImageView.loadImage(with: imageUrls[0])
            }
        }
    }
    
    let postImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 0, image: UIImage())
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        postImageView.layer.cornerRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
