//
//  FImageSlideShow.swift
//  Flytant
//
//  Created by Vivek Rai on 06/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow


class FImageSlideShow: ImageSlideshow {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.zoomEnabled = true
        self.slideshowInterval = 100
        self.activityIndicator = DefaultActivityIndicator(style: .medium, color: UIColor.label)
//        self.pageIndicator = LabelPageIndicator()
        
    }
    
}
