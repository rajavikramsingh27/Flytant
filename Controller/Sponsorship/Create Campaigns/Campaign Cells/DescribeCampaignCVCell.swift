////
////  DescribeCampaignCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class DescribeCampaignCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var campaignDescription: UITextView!
//    @IBOutlet weak var doneButton: UIButton!
//    weak var delegate: CampaignCellDelegate?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//
//        campaignDescription.addBorder(color: .label, thickness: 1)
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if !campaignDescription.text.isEmpty {
//            delegate?.done(cellType: .description, value: campaignDescription.text)
//        } else {
//            delegate?.showErrorMeg(msg: "Please enter your campaign description")
//        }
//    }
//}
