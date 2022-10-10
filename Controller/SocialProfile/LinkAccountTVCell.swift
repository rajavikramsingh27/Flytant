////
////  LinkYoutubeAccountTVCell.swift
////  Flytant
////
////  Created by Flytant on 24/09/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//final class LinkAccountTVCell: UITableViewCell {
//
//    
//    @IBOutlet private weak var accountImageView: UIImageView!
//    @IBOutlet private weak var accountDescription: UILabel!
//    
//    func setAccountText(for account: SocialAccount) {
//        if account == .instagram {
//            
//            accountDescription.text = "Click here to link your Instagram account"
//            accountImageView.image = UIImage(named: "instagramicon")
//        } else if account == .youtube {
//            accountDescription.text = "Click here to link your Youtube account"
//            accountImageView.image = UIImage(named: "youtubeicon")
//        } else {
//            accountDescription.text = "Click here to link your Twitter account"
//            accountImageView.image = UIImage(named: "twittericon")
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//}
