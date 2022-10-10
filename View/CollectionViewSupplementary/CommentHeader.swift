//
//  CommentHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 05/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ActiveLabel

private let reuseIdentifier = "commentHeader"

class CommentHeader: UICollectionViewCell {

    var delegate: CommentHeaderDelegate?

    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 16, image: UIImage())
    
    let timeStampLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: .secondaryLabel)
    
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)

        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        descriptionLabel.numberOfLines = 0

        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: descriptionLabel.bottomAnchor, left: descriptionLabel.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)

        addSubview(separatorView)
        separatorView.anchor(top: timeStampLabel.bottomAnchor, left: timeStampLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: -8, paddingBottom: 16, paddingRight: 8, width: 0, height: 0.5)
        separatorView.backgroundColor = UIColor.secondaryLabel
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsername))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUsername(){
        delegate?.handleHeaderUsernameTapped(for: self)
    }
}
