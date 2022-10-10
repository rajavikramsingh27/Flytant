//
//  MessageTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell{
    
//    MARK: - Properties
    
    var delegate: MessageCellDelegate?
    
    var message: Message? {
        
        didSet{
            guard let message = self.message else { return }
            guard let messageText = message.messageText else {return}
            nameLabel.text = messageText
            setUserData(userId: message.getChatPartnerId())
            configureTimestamp(forMessage: message)
//            delegate?.configureUserData(for: self)
        }
    }
    
//    MARK: - Views
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 25, image: UIImage())
    
    let timeStampLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: .secondaryLabel)
    
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
        
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
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
    
//    MARK: - Handlers
    
    private func setUserData(userId: String){
        
        USER_REF.document(userId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}

            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            self.profileImageView.loadImage(with: profileImageURL)
            self.usernameLabel.text = username
        }
    }
    
    private func configureUserData(){
        guard let chatPartnerId = message?.getChatPartnerId() else {return}
        
        USER_REF.document(chatPartnerId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            self.profileImageView.loadImage(with: profileImageURL)
            self.usernameLabel.text = username
        }
    }
    
    private func configureTimestamp(forMessage message: Message) {
        if let seconds = message.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timeStampLabel.text = dateFormatter.string(from: seconds)
        }
    }
    
    
}
