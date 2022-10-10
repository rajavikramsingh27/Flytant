//
//  GrowthCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 09/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class GrowthCollectionViewCell: UICollectionViewCell {
    
    let backgroundImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        backgroundImageView.contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
