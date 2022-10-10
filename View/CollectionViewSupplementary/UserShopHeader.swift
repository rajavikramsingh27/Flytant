//
//  UserShopHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 14/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class UserShopHeader: UICollectionViewCell {
     
//    MARK: - Properties
    var delegate: ShopHeaderDeleagte?
    
    
//    MARK: - Views
    
    let headerImageView = FImageView(backgroundColor: UIColor.gray, cornerRadius: 0, image: UIImage(named: "defaultShopHeader")!)
    let shopIconImageView = FImageView(backgroundColor: UIColor.gray, cornerRadius: 50, image: UIImage(named: "defaultShopIcon")!)
    let editShopWebsiteButton = FButton(backgroundColor: UIColor.clear, title: "Edit Shop", cornerRadius: 5, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImageView)
        headerImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 100)
        headerImageView.layer.cornerRadius = 10
        
        addSubview(shopIconImageView)
        shopIconImageView.anchor(top: headerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        shopIconImageView.layer.borderColor = UIColor.systemBackground.cgColor
        shopIconImageView.layer.borderWidth = 2
        shopIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(editShopWebsiteButton)
        editShopWebsiteButton.anchor(top: shopIconImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        editShopWebsiteButton.layer.borderWidth = 1
        editShopWebsiteButton.layer.borderColor = UIColor.label.cgColor
        editShopWebsiteButton.addTarget(self, action: #selector(handleEditShopWebsite), for: .touchUpInside)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditShopWebsite(){
        delegate?.handleEditShopWebsite(for: self)
    }
}
