//
//  FGradientButton.swift
//  Flytant
//
//  Created by Flytant on 11/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FGradientButton: UIButton {

    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cgColors : [CGColor], startPoint : CGPoint, endPoint : CGPoint) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}
