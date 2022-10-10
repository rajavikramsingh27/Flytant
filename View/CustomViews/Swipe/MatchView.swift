//
//  MatchView.swift
//  Flytant
//
//  Created by Vivek Rai on 01/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class MatchView: UIView {
    
    var delegate: MatchViewDelegate?
    
    private let currentUser: Users
    private let matchedUser: Users
    let matchImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "matchImage")!)
    let hiLabel = FLabel(backgroundColor: UIColor.clear, text: "Let's say Hi!!", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.black)
    let sendMessageButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Send Message", cornerRadius: 5, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 16))
    let leaveItButton = FButton(backgroundColor: UIColor.clear, title: "Leave It", cornerRadius: 5, titleColor: UIColor.black, font: UIFont.boldSystemFont(ofSize: 16))
    
    init(currentUser: Users, matchedUser: Users) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        addSubview(matchImageView)
        matchImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 260)
        addSubview(hiLabel)
        hiLabel.anchor(top: matchImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        
        addSubview(sendMessageButton)
        sendMessageButton.anchor(top: hiLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        addSubview(leaveItButton)
        leaveItButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        leaveItButton.addTarget(self, action: #selector(handleLeaveIt), for: .touchUpInside)
        leaveItButton.layer.borderWidth = 1
        leaveItButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func handleSendMessage(){
        delegate?.handleMessage(for: self, user: matchedUser)
        removeFromSuperview()
    }
    
    @objc func handleLeaveIt(){
        removeFromSuperview()
    }
    
}
