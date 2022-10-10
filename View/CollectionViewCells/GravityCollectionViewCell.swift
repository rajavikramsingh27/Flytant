//
//  GravityCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 03/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class GravityCollectionViewCell: UICollectionViewCell {
    
    let postImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 10, image: UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        postImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        postImageView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
