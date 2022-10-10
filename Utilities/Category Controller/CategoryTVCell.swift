//
//  CategoryTVCell.swift
//  Flytant
//
//  Created by Flytant on 06/10/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

class CategoryTVCell: UITableViewCell {

    @IBOutlet weak var cateogryLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
