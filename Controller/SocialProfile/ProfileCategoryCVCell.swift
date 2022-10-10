//
//  ProfileCategoryCVCell.swift
//  Flytant
//
//  Created by Flytant on 24/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

class ProfileCategoryCVCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.layer.cornerRadius = 20
        categoryLabel.layer.masksToBounds = true
    }

}
