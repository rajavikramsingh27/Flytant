//
//  ExploreTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
//    MARK: - Properties
    var user: Users? {
        didSet{
            guard let profileImageUrl = user?.profileImageURL else {return}
            profileImageView.loadImage(with: profileImageUrl)
            guard let username = user?.username else {return}
            usernameLabel.text = username
            guard let name = user?.name else {return}
            nameLabel.text = name
        }
    }
    
//    MARK: - Views
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.secondaryLabel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil
            , right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
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
