//
//  PlatformCVCell.swift
//  Flytant
//
//  Created by Flytant on 09/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class PlatformCVCell: UICollectionViewCell {
    
    let platformBtn : FButton = {
        let btn = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 12, titleColor: .clear, font: .systemFont(ofSize: 0))
        return btn
    }()
    
    let cgColor1 = UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor
    let cgColor2 = UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        gradientLayer.colors = [cgColor1, cgColor2]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.cornerRadius = 12
        gradientLayer.frame = bounds
        contentView.layer.addSublayer(gradientLayer)
        
        contentView.addSubview(platformBtn)
        platformBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        platformBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        platformBtn.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        platformBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    func addValues(platform : String) {
        
        if platform == "Twitter" {
            platformBtn.setImage(UIImage(named: "twittericon_pdf"), for: .normal)
        } else if platform == "Facebook" {
            platformBtn.setImage(UIImage(named: "facebookicon_pdf"), for: .normal)
        } else if platform == "Youtube" {
            platformBtn.setImage(UIImage(named: "youtubeicon_pdf"), for: .normal)
        } else if platform == "Instagram" {
            platformBtn.setImage(UIImage(named: "instagramicon_pdf"), for: .normal)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        contentView.bringSubviewToFront(platformBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
