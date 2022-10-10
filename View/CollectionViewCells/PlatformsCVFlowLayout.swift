//
//  PlatformsCVFlowLayout.swift
//  Flytant
//
//  Created by Flytant on 09/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class PlatformsCVFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        itemSize = CGSize(width: 24, height: 24)
        scrollDirection = .horizontal
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
