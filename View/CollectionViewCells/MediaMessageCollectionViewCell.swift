//
//  MediaMessageCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 15/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class MediaMessageCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Views
    let postImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 0, image: UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 4, paddingRight: 2, width: 0, height: 0)
        postImageView.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
