//
//  ChatHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 20/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class ChatHeader: UICollectionViewCell {
    
//    MARK: - Properties

    var delegate: ProfileHeaderDelegate?
    
//    MARK: - Views
    
    let cimageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chat_bottom")!)
    let searchBar = UISearchBar()
        
// MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSearchBar()
    
//        searchBar.sizeToFit()
////        searchBar.delegate = self
//        searchBar.placeholder = "Search"
//        searchBar.barTintColor = UIColor.systemBackground
//        searchBar.tintColor = .white
//        searchBar.layer.cornerRadius = 10
//        addSubview(searchBar)
//        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = .white
//        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
//        textFieldInsideSearchBarLabel?.textColor = .label
//
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSearchBar(){
        addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search by name or username"
    }
    
  
}
