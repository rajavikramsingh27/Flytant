//
//  FButton.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String, cornerRadius: CGFloat, titleColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

