//
//  FCircularSlider.swift
//  Flytant
//
//  Created by Vivek Rai on 08/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import HGCircularSlider


class FCircularSlider: CircularSlider {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        backtrackLineWidth = 5
        diskColor = UIColor(red: 81/255, green: 80/255, blue: 73/255, alpha: 1)
        diskFillColor = UIColor(red: 72/255, green: 200/255, blue: 27/255, alpha: 1)
        trackColor = .clear
        lineWidth = 5
        trackColor = .systemGray
        tintColor = UIColor.systemGreen
        endThumbTintColor = .systemGreen
        trackShadowColor = .systemGreen
        endThumbStrokeColor = .red
        endThumbImage = UIImage()
    }
    
}



