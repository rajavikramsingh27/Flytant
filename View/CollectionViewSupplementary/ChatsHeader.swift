//
//  ChatsHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 06/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class ChatsHeader: UICollectionViewCell {
    
    var delegate: ChatsHeaderDelegate?
    
    let searchBar = UISearchBar()
    let chatView = UIView()
    let callView = UIView()
    let contactsView = UIView()
    let settingsView = UIView()
    
    let chatImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chatViewPagerColored")!)
    let callImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "callViewPager")!)
    let contactsImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "contactsViewPager")!)
    let settingsImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "settingsViewPager")!)
    
    let chatBottomView = UIView()
    let callBottomView = UIView()
    let contactsBottomView = UIView()
    let settingsBottomView = UIView()
    
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSearchBar()
        configureContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSearchBar(){
        addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by name or username"
    }
    
    private func configureContainerView(){
        
        let oneFourthWidth = frame.width/4
        addSubview(chatView)
        chatView.anchor(top: searchBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: oneFourthWidth-16, height: oneFourthWidth-16)
        
        addSubview(callView)
        callView.anchor(top: searchBar.bottomAnchor, left: chatView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: oneFourthWidth-16, height: oneFourthWidth-16)
        
        addSubview(contactsView)
        contactsView.anchor(top: searchBar.bottomAnchor, left: callView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: oneFourthWidth-16, height: oneFourthWidth-16)
        
        addSubview(settingsView)
        settingsView.anchor(top: searchBar.bottomAnchor, left: contactsView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: oneFourthWidth-16, height: oneFourthWidth-16)
        
        chatView.addSubview(chatImageView)
        chatImageView.anchor(top: chatView.topAnchor, left: chatView.leftAnchor, bottom: chatView.bottomAnchor, right: chatView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 28, paddingRight: 16, width: 0, height: 0)
        chatImageView.isUserInteractionEnabled = true
        let chatImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleChats))
        chatImageGesture.numberOfTapsRequired = 1
        chatImageView.addGestureRecognizer(chatImageGesture)
        
        chatView.addSubview(chatBottomView)
        chatBottomView.anchor(top: chatImageView.bottomAnchor, left: chatImageView.leftAnchor, bottom: nil, right: chatImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        chatBottomView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        
        callView.addSubview(callImageView)
        callImageView.anchor(top: callView.topAnchor, left: callView.leftAnchor, bottom: callView.bottomAnchor, right: callView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 28, paddingRight: 16, width: 0, height: 0)
        callImageView.isUserInteractionEnabled = true
        let callImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleCalls))
        callImageGesture.numberOfTapsRequired = 1
        callImageView.addGestureRecognizer(callImageGesture)
        
        callView.addSubview(callBottomView)
        callBottomView.anchor(top: callImageView.bottomAnchor, left: callImageView.leftAnchor, bottom: nil, right: callImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        callBottomView.backgroundColor = UIColor.systemBackground
        
        contactsView.addSubview(contactsImageView)
        contactsImageView.anchor(top: contactsView.topAnchor, left: contactsView.leftAnchor, bottom: contactsView.bottomAnchor, right: contactsView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 28, paddingRight: 16, width: 0, height: 0)
        contactsImageView.isUserInteractionEnabled = true
        let contactsImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleContacts))
        contactsImageGesture.numberOfTapsRequired = 1
        contactsImageView.addGestureRecognizer(contactsImageGesture)
        
        contactsView.addSubview(contactsBottomView)
        contactsBottomView.anchor(top: contactsImageView.bottomAnchor, left: contactsImageView.leftAnchor, bottom: nil, right: contactsImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        contactsBottomView.backgroundColor = UIColor.systemBackground
        
        settingsView.addSubview(settingsImageView)
        settingsImageView.anchor(top: settingsView.topAnchor, left: settingsView.leftAnchor, bottom: settingsView.bottomAnchor, right: settingsView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 28, paddingRight: 16, width: 0, height: 0)
        settingsImageView.isUserInteractionEnabled = true
        let settingsImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleSettings))
        settingsImageGesture.numberOfTapsRequired = 1
        settingsImageView.addGestureRecognizer(settingsImageGesture)
        
        settingsView.addSubview(settingsBottomView)
        settingsBottomView.anchor(top: settingsImageView.bottomAnchor, left: settingsImageView.leftAnchor, bottom: nil, right: settingsImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        settingsBottomView.backgroundColor = UIColor.systemBackground
        
        addSubview(separatorView)
        separatorView.anchor(top: chatBottomView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        separatorView.backgroundColor = UIColor.systemGray3
        
    }
    
    @objc func handleChats(){
        delegate?.handleChats(for: self)
    }
    
    @objc func handleCalls(){
        delegate?.handleCalls(for: self)
    }
    
    @objc func handleContacts(){
        delegate?.handleContacts(for: self)
    }
    
    @objc func handleSettings(){
        delegate?.handleSettings(for: self)
    }
    
}
