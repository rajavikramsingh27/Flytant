//
//  CommentCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 05/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ActiveLabel

class CommentCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    var comments: Comments? {
        didSet{
            guard let profileImageUrl = comments?.profileImageUrl else {return}
            profileImageView.loadImage(with: profileImageUrl)
            
            guard let username = comments?.username else {return}
            guard let commentText = comments?.commentText else {return}
//            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
//            attributedText.append(NSMutableAttributedString(string: " \(commentText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label]))
//            descriptionLabel.attributedText = attributedText

            
            // look for username as pattern
            let customType = ActiveType.custom(pattern: "^\(username)\\b")
                   
            // enable username as custom type
            descriptionLabel.enabledTypes = [.mention, .hashtag, customType]
            
            // configure usnerame link attributes
            descriptionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                       
                switch type {
                    case .custom:
                        atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
                    default: ()
                }
                return atts
            }
                   
            descriptionLabel.customize { (label) in
                label.text = "\(username) \(commentText)"
                label.customColor[customType] = .label
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .label
                label.hashtagColor = .systemPink
                label.mentionColor = .systemPink
//                descriptionLabel.numberOfLines = 2
            }
            
            descriptionLabel.handleCustomTap(for: customType) { (username) in
                self.handleActiveLabelUsernameTapped(username: username)
            }
            
            
            guard let timeStamp = comments?.creationDate else {return}
            timeStampLabel.text = timeStamp.timeAgoToDisplay()
        }
    }
    
    var delegate: CommentCellDelegate?
    
//    MARK: - Views
    
    lazy var profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 16, image: UIImage())
    let timeStampLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: .secondaryLabel)
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        descriptionLabel.numberOfLines = 0
        
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: descriptionLabel.bottomAnchor, left: descriptionLabel.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsername))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUsername(){
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleActiveLabelUsernameTapped(username: String){
        delegate?.handleActiveLabelUsernameTapped(for: self, username: username)
    }
}
