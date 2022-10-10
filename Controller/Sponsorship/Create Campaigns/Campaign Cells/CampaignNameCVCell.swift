////
////  CampaignNameCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class CampaignNameCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var campaignNameTF: UITextField!
//    @IBOutlet weak var doneButton: UIButton!
//    weak var delegate: CampaignCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//        
//        campaignNameTF.addBorder(color: .label, thickness: 1)
//    }
//    
//    @IBAction func doneAction(_ sender: UIButton) {
//        if campaignNameTF.text != nil {
//            delegate?.done(cellType: .name, value: Helper.stringValue(campaignNameTF.text))
//        } else {
//            delegate?.showErrorMeg(msg: "Please enter your campaign name")
//        }
//    }
//    
//}
