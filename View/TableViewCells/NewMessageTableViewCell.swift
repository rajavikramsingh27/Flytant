//
//  NewMessageTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    
//    MARK: - Views
   
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 25, image: UIImage(named: "9")!)
   
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
    
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: .secondaryLabel)
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        selectionStyle = .none
       
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalToSystemSpacingBelow: centerYAnchor, multiplier: 1)
        ])
       
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        addSubview(nameLabel)
        nameLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()

    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
}



