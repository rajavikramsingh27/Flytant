//
//  PlatformsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 21/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class PlatformsCollectionViewCell: UICollectionViewCell{
    
    let iconButton = FGradientButton(cgColors: [UIColor.secondarySystemBackground.cgColor, UIColor.secondarySystemBackground.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    let iconIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let lblPlateformName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.contentView.addSubview(lblPlateformName)
        lblPlateformName.translatesAutoresizingMaskIntoConstraints = false
        lblPlateformName.backgroundColor = .systemBackground
        lblPlateformName.textColor = .label
        lblPlateformName.text = "facebook"
        lblPlateformName.textAlignment = .center
        lblPlateformName.font = UIFont (name: kFontMedium, size: 12)
                
        NSLayoutConstraint.activate([
            lblPlateformName.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            lblPlateformName.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            lblPlateformName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
        ])
        
        self.contentView.addSubview(iconIV)
        iconIV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            iconIV.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
//            iconIV.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            iconIV.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0),
            iconIV.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
//            iconIV.bottomAnchor.constraint(equalTo: lblPlateformName.bottomAnchor, constant: 10),
            iconIV.heightAnchor.constraint(equalToConstant: 26),
            iconIV.widthAnchor.constraint(equalToConstant: 26),
        ])
        
        
        
//        addSubview(iconButton)
//        iconButton.addSubview(iconIV)
//
//        NSLayoutConstraint.activate([
//            iconButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            iconButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            iconButton.widthAnchor.constraint(equalToConstant: 30),
//            iconButton.heightAnchor.constraint(equalToConstant: 30),
//            iconIV.centerXAnchor.constraint(equalTo: iconButton.centerXAnchor),
//            iconIV.centerYAnchor.constraint(equalTo: iconButton.centerYAnchor),
//            iconIV.widthAnchor.constraint(equalToConstant: 18),
//            iconIV.heightAnchor.constraint(equalToConstant: 18)
//        ])
//        iconButton.gradientLayer.cornerRadius = 15
    }
}

