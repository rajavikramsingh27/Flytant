////
////  InstagramPostsPicsTVCell.swift
////  Flytant
////
////  Created by Flytant on 27/09/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//import ActiveLabel
//import SDWebImage
//
//
//final class InstagramPostsPicsTVCell: UITableViewCell {
//
//    @IBOutlet weak var profileImageView: RoundImageView!
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var captionLabel: ActiveLabel!
//    @IBOutlet weak var postPicImageView: UIImageView!
//    @IBOutlet weak var likesLabel: UILabel!
//    @IBOutlet weak var commentsLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    
//    func showPosts(model: InstagramModel?, picModel: EdgeFelixVideoTimelineEdge?) {
//        profileImageView.setImage(image: model?.graphql?.instaUser?.profilePicUrl)
//        usernameLabel.text = Helper.stringValue(model?.graphql?.instaUser?.username)
//        likesLabel.text = Helper.IntToStringValue(picModel?.node?.edgeLikedBy?.count) + " Likes"
//        commentsLabel.text = Helper.IntToStringValue(picModel?.node?.edgeMediaToComment?.count) + " Comments"
//        postPicImageView.setImage(image: picModel?.node?.thumbnailResources?.last?.src)
//        timeLabel.text = Helper.timeStampToString(timeStamp: picModel?.node?.takenAtTimestamp)
//        captionLabel.text = Helper.stringValue(picModel?.node?.edgeMediaToCaption?.edges?.first?.node?.text)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//}
