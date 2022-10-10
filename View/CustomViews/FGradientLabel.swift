//
//  FGradientLabel.swift
//  Flytant
//
//  Created by Flytant on 10/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FGradientLabel: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    let gradientLayer = CAGradientLayer()
    
    let label : FLabel = {
        let lbl = FLabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(cgColors : [CGColor], startPoint : CGPoint, endPoint : CGPoint, backgroundColor: UIColor, text: String, font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        layer.cornerRadius = 5
        label.backgroundColor = backgroundColor
        label.text = text
        label.font = font
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.layer.cornerRadius = 5
        self.backgroundColor = .black
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bringSubviewToFront(label)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    

}
