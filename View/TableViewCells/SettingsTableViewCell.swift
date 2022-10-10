//
//  SettingsTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 07/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell{
    
//    MARK: - Properties

//    MARK: - Views
        
    let iconImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let contentLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    let arrowImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "arrowRight")!)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        selectionStyle = .none
        addSubview(iconImageView)
        iconImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
            
        addSubview(contentLabel)
        contentLabel.anchor(top: iconImageView.topAnchor, left: iconImageView.rightAnchor, bottom: iconImageView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 0, width: 200, height: 40)
        
        addSubview(arrowImageView)
        arrowImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 16, width: 20, height: 20)
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
