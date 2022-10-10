//
//  StoryProgressBarCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 19/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import VHProgressBar

class StoryProgressBarCollectionViewCell: UICollectionViewCell {
        
//    MARK: - Views
    
    let horizontalProgress = HorizontalProgressBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(horizontalProgress)
        horizontalProgress.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
