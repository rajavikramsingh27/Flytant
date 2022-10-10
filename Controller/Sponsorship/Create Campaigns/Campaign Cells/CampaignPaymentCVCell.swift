////
////  CampaignPaymentCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//enum PaymentSelected {
//    case giveaway
//    case pay
//    case none
//}
//
//final class CampaignPaymentCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var givawayButton: UIButton!
//    @IBOutlet weak var describeGiveAway: UILabel!
//    @IBOutlet weak var giveAwayTextView: UITextView!
//    @IBOutlet weak var describeGiveAwayLabelHeightConstraint: NSLayoutConstraint! // 18
//    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint! // 100
//
//    @IBOutlet weak var payInfluencerButton: UIButton!
//    @IBOutlet weak var enterPriceLabel: UILabel!
//    @IBOutlet weak var priceTF: UITextField!
//    @IBOutlet weak var etnerThePricingHeightConstraint: NSLayoutConstraint! // 18
//    @IBOutlet weak var priceTFHeightConstraint: NSLayoutConstraint! // 35
//    var paymentOption: PaymentSelected = .none
//    weak var delegate: CampaignCellDelegate?
//
//    @IBOutlet weak var doneButton: UIButton!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//
//        payInfluencerButton.layer.cornerRadius = 5
//        payInfluencerButton.layer.masksToBounds = true
//        payInfluencerButton.addBorder(color: .label, thickness: 1)
//
//        givawayButton.layer.cornerRadius = 5
//        givawayButton.layer.masksToBounds = true
//        givawayButton.addBorder(color: .label, thickness: 1)
//
//        giveAwayTextView.layer.cornerRadius = 5
//        giveAwayTextView.layer.masksToBounds = true
//        giveAwayTextView.addBorder(color: .label, thickness: 1)
//
//        priceTF.layer.cornerRadius = 5
//        priceTF.layer.masksToBounds = true
//        priceTF.addBorder(color: .label, thickness: 1)
//
//        describeGiveAwayLabelHeightConstraint.constant = 0
//        textViewHeightConstraint.constant = 0
//
//        etnerThePricingHeightConstraint.constant = 0
//        priceTFHeightConstraint.constant = 0
//    }
//
//    @IBAction func giveAwayAction(_ sender: UIButton) {
//        paymentOption = .giveaway
//        priceTF.text = nil
//        etnerThePricingHeightConstraint.constant = 0
//        priceTFHeightConstraint.constant = 0
//
//        describeGiveAwayLabelHeightConstraint.constant = 18
//        textViewHeightConstraint.constant = 100
//
//        sender.setTitleColor(.systemBackground, for: .normal)
//        sender.backgroundColor = .label
//        payInfluencerButton.setTitleColor(.label, for: .normal)
//        payInfluencerButton.backgroundColor = .systemBackground
//        layoutIfNeeded()
//    }
//
//    @IBAction func payInfluencerAction(_ sender: UIButton) {
//        paymentOption = .pay
//        giveAwayTextView.text = nil
//        etnerThePricingHeightConstraint.constant = 18
//        priceTFHeightConstraint.constant = 35
//
//        describeGiveAwayLabelHeightConstraint.constant = 0
//        textViewHeightConstraint.constant = 0
//
//        sender.setTitleColor(.systemBackground, for: .normal)
//        sender.backgroundColor = .label
//        givawayButton.setTitleColor(.label, for: .normal)
//        givawayButton.backgroundColor = .systemBackground
//        layoutIfNeeded()
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if paymentOption == .giveaway {
//            delegate?.selectedPayment(method: .giveaway, value: giveAwayTextView.text)
//        } else if paymentOption == .pay {
//            delegate?.selectedPayment(method: .pay, value: Helper.stringValue(priceTF.text))
//        } else {
//            delegate?.showErrorMeg(msg: "Please select your payment mode")
//        }
//    }
//
//}
