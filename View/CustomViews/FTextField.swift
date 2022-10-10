//
//  FTextField.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, borderStyle: UITextField.BorderStyle, contentType: UITextContentType, keyboardType: UIKeyboardType, textAlignment: NSTextAlignment, placeholder: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        self.textContentType = contentType
        self.keyboardType = keyboardType
        self.textAlignment = textAlignment
        self.placeholder = placeholder
    }
    
}

