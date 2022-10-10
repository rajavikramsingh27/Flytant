//
//  ContactsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 16/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class ContactsCollectionViewCell: UICollectionViewCell {
    
    var chatContacts: ChatContacts? {
        didSet{
            guard let firstName = chatContacts?.firstName else {return}
            guard let lastName = chatContacts?.lastName else {return}
            guard let contactNumber = chatContacts?.contactNumber else {return}
            nameLabel.text = "\(firstName) \(lastName)"
            numberLabel.text = contactNumber
            if let firstLetter = firstName.first, let secondLetter = lastName.first{
                profileImageLabel.text = "\(firstLetter)".capitalized + "\(secondLetter)".capitalized
            }
        }
    }
    
    let profileImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 24, image: UIImage())
    let profileImageLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 24), textAlignment: .center, textColor: UIColor.white)
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    
    let numberLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViews(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        profileImageView.addSubview(profileImageLabel)
        profileImageLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        
        addSubview(numberLabel)
        numberLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 24, width: 0, height: 16)
        numberLabel.numberOfLines = 1
        
        addSubview(separatorView)
        separatorView.anchor(top: profileImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.4)
        separatorView.backgroundColor = UIColor.systemGray3
    }
}


