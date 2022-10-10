////
////  ChooseCategoryCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class ChooseCategoryCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var categoryTF: UITextField!
//    @IBOutlet weak var doneButton: UIButton!
//
//    weak var delegate: CampaignCellDelegate?
//    var categories: String? {
//        didSet {
//            delegate?.textEntered(cellType: .category, value: Helper.stringValue(categories))
//        }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//
//        categoryTF.delegate = self
//
//        categoryTF.addBorder(color: .label, thickness: 1)
//    }
//
//    @IBAction func textDidChange(_ sender: UITextField) {
//        delegate?.textEntered(cellType: .category, value: Helper.stringValue(sender.text))
//    }
//
//    @IBAction func chooseCategoryAction(_ sender: UIButton) {
//        delegate?.openCategoryPage()
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if let choosenCategory = categoryTF.text {
//            delegate?.done(cellType: .category, value: choosenCategory)
//        } else {
//            delegate?.showErrorMeg(msg: "Please choose your product category")
//        }
//    }
//
//}
//extension ChooseCategoryCVCell: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        delegate?.textEntered(cellType: .category, value: Helper.stringValue(textField.text))
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//            print(textField.text)
////        delegate?.textEntered(cellType: .category, value: Helper.stringValue(textField.text))
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(textField.text)
//    }
//}
