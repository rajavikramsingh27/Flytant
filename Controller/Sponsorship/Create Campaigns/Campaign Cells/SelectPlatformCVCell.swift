////
////  SelectPlatformCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//final class SelectPlatformCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var facebookButton: UIButton!
//    @IBOutlet weak var youtubeButton: UIButton!
//    @IBOutlet weak var instagramButton: UIButton!
//    @IBOutlet weak var twitterButton: UIButton!
//    @IBOutlet weak var linkedInButton: UIButton!
//    @IBOutlet weak var doneButton: UIButton!
//
//    weak var delegate: CampaignCellDelegate?
//    var platform = [String]()
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//
//        facebookButton.layer.cornerRadius = 6
//        facebookButton.layer.masksToBounds = true
//        facebookButton.addBorder(color: .label, thickness: 1)
//
//        youtubeButton.layer.cornerRadius = 6
//        youtubeButton.layer.masksToBounds = true
//        youtubeButton.addBorder(color: .label, thickness: 1)
//
//        instagramButton.layer.cornerRadius = 6
//        instagramButton.layer.masksToBounds = true
//        instagramButton.addBorder(color: .label, thickness: 1)
//
//        twitterButton.layer.cornerRadius = 6
//        twitterButton.layer.masksToBounds = true
//        twitterButton.addBorder(color: .label, thickness: 1)
//
//        linkedInButton.layer.cornerRadius = 6
//        linkedInButton.layer.masksToBounds = true
//        linkedInButton.addBorder(color: .label, thickness: 1)
//    }
//
//    @IBAction func facebookAction(_ sender: UIButton) {
//        if platform.contains("facebook") {
//            sender.setTitleColor(.label, for: .normal)
//            sender.backgroundColor = .systemBackground
//           if let index = platform.firstIndex(where: { $0 == "facebook" }) {
//                platform.remove(at: index)
//            }
//        } else {
//            sender.setTitleColor(.systemBackground, for: .normal)
//            sender.backgroundColor = .label
//            platform.append("facebook")
//        }
//    }
//
//    @IBAction func youtubeAction(_ sender: UIButton) {
//        if platform.contains("youtube") {
//            sender.setTitleColor(.label, for: .normal)
//            sender.backgroundColor = .systemBackground
//           if let index = platform.firstIndex(where: { $0 == "youtube" }) {
//                platform.remove(at: index)
//            }
//        } else {
//            sender.setTitleColor(.systemBackground, for: .normal)
//            sender.backgroundColor = .label
//            platform.append("youtube")
//        }
//    }
//
//    @IBAction func instagramButton(_ sender: UIButton) {
//        if platform.contains("instagram") {
//            sender.setTitleColor(.label, for: .normal)
//            sender.backgroundColor = .systemBackground
//           if let index = platform.firstIndex(where: { $0 == "instagram" }) {
//                platform.remove(at: index)
//            }
//        } else {
//            sender.setTitleColor(.systemBackground, for: .normal)
//            sender.backgroundColor = .label
//            platform.append("instagram")
//        }
//    }
//
//    @IBAction func twitterAction(_ sender: UIButton) {
//        if platform.contains("twitter") {
//            sender.setTitleColor(.label, for: .normal)
//            sender.backgroundColor = .systemBackground
//           if let index = platform.firstIndex(where: { $0 == "twitter" }) {
//                platform.remove(at: index)
//            }
//        } else {
//            sender.setTitleColor(.systemBackground, for: .normal)
//            sender.backgroundColor = .label
//            platform.append("twitter")
//        }
//    }
//
//    @IBAction func linkedInButton(_ sender: UIButton) {
//        if platform.contains("linkedIn") {
//            sender.setTitleColor(.label, for: .normal)
//            sender.backgroundColor = .systemBackground
//           if let index = platform.firstIndex(where: { $0 == "linkedIn" }) {
//                platform.remove(at: index)
//            }
//        } else {
//            sender.setTitleColor(.systemBackground, for: .normal)
//            sender.backgroundColor = .label
//            platform.append("linkedIn")
//        }
//    }
//
//    @IBAction func doneAction(_ sender: UIButton) {
//        if platform.isEmpty {
//            delegate?.showErrorMeg(msg: "Please select your desired platform")
//        } else {
//            delegate?.done(cellType: .platform, value: platform.joined(separator: ", "))
//        }
//    }
//
//}
