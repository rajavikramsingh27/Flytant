////
////  GenderTargetCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class GenderTargetCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var genderTF: UITextField!
//    @IBOutlet weak var doneButton: UIButton!
//
//    weak var delegate: CampaignCellDelegate?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//
//        genderTF.addBorder(color: .label, thickness: 1)
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if let gender = genderTF.text {
//            delegate?.done(cellType: .gender, value: gender)
//        } else {
//            delegate?.showErrorMeg(msg: "please select your target audiance")
//        }
//
//    }
//
//
//}
