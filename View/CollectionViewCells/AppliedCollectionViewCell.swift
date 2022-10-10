//
//  AppliedCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 04/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import SDWebImage

class AppliedCollectionViewCell: UICollectionViewCell {
    
    var delegate: ApplieCellDelegate?
    
    var user: Users? {
        didSet{
            guard let profileImageUrl = user?.profileImageURL else {return}
            guard let username = user?.username else {return}
            profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage())
            usernameLabel.text = username
        }
    }
    
    let bgView = UIView()
    let profileImageView = FImageView(backgroundColor: UIColor.systemBackground, cornerRadius: 40, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .center, textColor: UIColor.label)
    let profileButton = FGradientButton(cgColors:[UIColor.secondarySystemBackground.cgColor, UIColor.secondarySystemBackground.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    let messageButton = FButton(backgroundColor: UIColor.systemBackground, title: "Message", cornerRadius: 5, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 12)!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(bgView)
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        bgView.backgroundColor = UIColor.secondarySystemBackground
        bgView.layer.cornerRadius = 10
        bgView.addSubview(profileImageView)
        profileImageView.anchor(top: bgView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        bgView.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        bgView.addSubview(profileButton)
        profileButton.anchor(top: usernameLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 32)
        profileButton.gradientLayer.cornerRadius = 5
        profileButton.layer.borderColor = UIColor.systemGray.cgColor
        profileButton.layer.cornerRadius = 5
        profileButton.layer.borderWidth = 1
        profileButton.setTitle("Profile", for: .normal)
        profileButton.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 12)!
        profileButton.setTitleColor(UIColor.label, for: .normal)
        profileButton.addTarget(self, action: #selector(handleProfile), for: .touchUpInside)
        bgView.addSubview(messageButton)
        messageButton.anchor(top: profileButton.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 32)
        messageButton.layer.borderColor = UIColor.systemGray.cgColor
        messageButton.layer.borderWidth = 1
        messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
    }
    
    @objc func handleMessage(){
        delegate?.handleMessage(for: self)
    }
    
    @objc func handleProfile(){
        delegate?.handleProfile(for: self)
    }
    
}
