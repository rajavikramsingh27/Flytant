//
//  StoryCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 19/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import ChameleonFramework

class StoryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
           
    var backgroundImageView = UIView()
    var imageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 28, image: UIImage(named: "3")!)
           
           
    func configureView(){
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        backgroundImageView.layer.cornerRadius = 32
        backgroundImageView.layer.borderColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1).cgColor
        backgroundImageView.layer.borderWidth = 2
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 0)
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
        imageView.layer.borderWidth = 0.5
    }
    
}
