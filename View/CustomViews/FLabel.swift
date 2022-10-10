//
//  FLabel.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, text: String, font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
        self.lineBreakMode = .byTruncatingTail
    }
    
}


