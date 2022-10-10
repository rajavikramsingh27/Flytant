////
////  PreviewCampaignCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class PreviewCampaignCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var previewButton: UIButton!
//    @IBOutlet weak var submitButton: UIButton!
//    
//    weak var delegate: CampaignCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        previewButton.layer.cornerRadius = 5
//        previewButton.layer.masksToBounds = true
//        
//        
//        submitButton.layer.cornerRadius = 5
//        submitButton.layer.masksToBounds = true
//    }
//    
//    
//    @IBAction func submitAction(_ sender: UIButton) {
//        delegate?.previewCampaign()
//    }
//    
//    
//    @IBAction func previewAction(_ sender: UIButton) {
//        delegate?.submitCampaign()
//    }
//    
//}
