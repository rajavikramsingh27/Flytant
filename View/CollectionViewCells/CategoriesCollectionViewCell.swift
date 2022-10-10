//
//  DetailsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    //    MARK: - Properties
    
    //    MARK: - Views
    //  let categoryButton = FGradientButton(cgColors: [UIColor.secondarySystemBackground.cgColor, UIColor.secondarySystemBackground.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    
    let categoryButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.contentView.backgroundColor = .systemBackground
        self.contentView.addSubview(categoryButton)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        categoryButton.titleLabel?.font = UIFont (name: kFontBold, size: 14)
        categoryButton.setTitleColor(UIColor.label, for: .normal)
        categoryButton.backgroundColor = UIColor (hexString: "E5E5E5").withAlphaComponent(0.8)
        
        NSLayoutConstraint.activate([
            categoryButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            categoryButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            categoryButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            categoryButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
        ])
        
    }
    
}


