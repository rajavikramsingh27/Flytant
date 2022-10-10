//
//  UploadPostCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 01/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class UploadPostCollectionViewCell: UICollectionViewCell{
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var imageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 5, image: UIImage())
    
    func setUpView(){
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 2, paddingRight: 5, width: 0, height: 0)
    }
    
}

