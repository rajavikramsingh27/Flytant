////
////  InstagramPrivateTVCell.swift
////  Flytant
////
////  Created by Flytant on 26/09/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//final class InstagramPrivateTVCell: UITableViewCell {
//
//    @IBOutlet weak var instaProfileImageView: RoundImageView!
//    @IBOutlet weak var instagramUsername: UILabel!
//    @IBOutlet weak var instagramBio: UILabel!
//    @IBOutlet weak var accountPrivateLabel: UILabel!
//
//
//    func setProfile(model: InstagramModel?) {
//        instaProfileImageView.setImage(image: model?.graphql?.instaUser?.profilePicUrl)
//        instagramUsername.text = Helper.stringValue(model?.graphql?.instaUser?.username)
//        instagramBio.text = Helper.stringValue(model?.graphql?.instaUser?.biography)
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
