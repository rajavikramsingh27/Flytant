//
//  ShopCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 14/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework
import SDWebImage

class ShopCollectionViewCell: UICollectionViewCell {
    
//    MARK: _ Properties

    var shopPosts: ShopPosts? {
        didSet{
            guard let imageUrls = shopPosts?.imageUrls else {return}
            if !imageUrls.isEmpty{
//                postImageView.loadImage(with: imageUrls[0])
                postImageView.sd_setImage(with: URL(string: imageUrls[0]), placeholderImage: UIImage(named: ""))
                if imageUrls.count > 1{
                    shopImageIconView.image = UIImage(named: "multipleShopBagIcon")
                }else{
                    shopImageIconView.image = UIImage(named: "shopBagIcon")
                }
            }
        }
    }
    
//    MARK: - Views
    
    let postImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 0, image: UIImage())
    
    let shopImageIconView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "shopBagIcon")!)
    
    let similarProductsButton = FButton(backgroundColor: UIColor.label, title: "Similar Products", cornerRadius: 3, titleColor: UIColor.systemBackground, font: UIFont.boldSystemFont(ofSize: 8))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 4, paddingRight: 2, width: 0, height: 0)
        postImageView.layer.cornerRadius = 5
        
        postImageView.addSubview(shopImageIconView)
        shopImageIconView.anchor(top: nil, left: nil, bottom: postImageView.bottomAnchor, right: postImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 4, width: 15, height: 15)
        shopImageIconView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
