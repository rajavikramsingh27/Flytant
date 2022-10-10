////
////  MinimumFollowersCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class MinimumFollowersCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var followersTF: UITextField!
//    @IBOutlet weak var doneButton: UIButton!
//    
//    weak var delegate: CampaignCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//        
//        followersTF.addBorder(color: .label, thickness: 1)
//    }
//    
//    
//    @IBAction func doneAction(_ sender: UIButton) {
//        if let followers = followersTF.text {
//            delegate?.done(cellType: .followers, value: followers)
//        } else {
//            delegate?.showErrorMeg(msg: "Please enter minimum followers")
//        }
//    }
//    
//}
