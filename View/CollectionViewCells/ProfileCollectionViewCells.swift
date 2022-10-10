//
//  ProfileCollectionViewCells.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework
import SDWebImage

class ProfileCollectionViewCell: UICollectionViewCell {
    
    var posts: Posts? {
        didSet{
            guard let imageUrls = posts?.imageUrls else {return}
            print(imageUrls)
            if imageUrls.count > 0{
//                postImageView.loadImage(with: imageUrls[0])
                postImageView.sd_setImage(with: URL(string: imageUrls[0]), placeholderImage: UIImage(named: ""))
                if imageUrls.count > 1{
                    multipleImgesIconView.image = UIImage(named: "multipleImgesIcon")
                }else{
                    multipleImgesIconView.image = UIImage()
                }
            }
        }
    }
    
    let postImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 0, image: UIImage())
    
    let multipleImgesIconView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 4, paddingRight: 2, width: 0, height: 0)
        postImageView.contentMode = .scaleAspectFit
        postImageView.layer.cornerRadius = 5
        
        addSubview(multipleImgesIconView)
        multipleImgesIconView.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 20, height: 20)
        multipleImgesIconView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
