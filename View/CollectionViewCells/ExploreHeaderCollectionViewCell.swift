//
//  ExploreHeaderCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework

class ExploreHeaderCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
           
    var imageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 5, image: UIImage())
           
           
    func configureView(){
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }
}
