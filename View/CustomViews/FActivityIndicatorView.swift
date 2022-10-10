//
//  FActivityIndicatorView.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit

class FActivityIndicatorView: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        style = .large
        color = UIColor(red: 16/255, green: 143, blue: 181/255, alpha: 1)
        startAnimating()
        
    }
}


