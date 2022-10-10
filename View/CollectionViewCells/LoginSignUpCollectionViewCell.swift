//
//  LoginSignUpCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class LoginSignUpCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var imageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 8, image: UIImage())
        
    func configureView(){
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 2, paddingRight: 3, width: 300, height: imageView.frame.height)
    }
}
