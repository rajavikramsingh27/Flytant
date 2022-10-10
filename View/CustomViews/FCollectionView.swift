//
//  FCollectionView.swift
//  Flytant
//
//  Created by Vivek Rai on 01/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit

class FCollectionView: UICollectionView {
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        isScrollEnabled = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}

