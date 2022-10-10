//
//  CampaignImageCVCell.swift
//  Flytant
//
//  Created by Flytant on 07/10/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

protocol CampaignImageDelegate: AnyObject {
    func deleteTheImage(index: Int)
}

class CampaignImageCVCell: UICollectionViewCell {

    
    @IBOutlet weak var mainImageView: UIImageView!
    weak var delegate: CampaignImageDelegate?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func DeleteTheImage(_ sender: UIButton) {
        delegate?.deleteTheImage(index: index)
    }
    
}
