//
//  SponsorPlatformCVCell.swift
//  Flytant
//
//  Created by Flytant on 11/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SponsorPlatformCVCell: UICollectionViewCell {
    
    let imageView : FImageView = {
        let imgv = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named:"emptyProfileIcon")!)
        return imgv
    }()
    
    let platformLbl : FLabel = {
        let lbl = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: UIColor.label)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(platformLbl)
        
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        platformLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        platformLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        platformLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
    
    func addValue(platform : String) {
        platformLbl.text = platform
        if platform == "Twitter" {
            imageView.image = UIImage(named: "twittericon")
        } else if platform == "Facebook" {
            imageView.image = UIImage(named: "facebookicon")
        } else if platform == "Youtube" {
            imageView.image = UIImage(named: "youtubeicon")
        } else if platform == "Instagram" {
            imageView.image = UIImage(named: "instagramicon")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        platformLbl.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
