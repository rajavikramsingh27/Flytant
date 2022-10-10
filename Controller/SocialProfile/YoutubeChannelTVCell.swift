////
////  YoutubeChannelTVCell.swift
////  Flytant
////
////  Created by Flytant on 28/09/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//import ActiveLabel
//
//class YoutubeChannelTVCell: UITableViewCell {
//
//    @IBOutlet weak var channelImageView: RoundImageView!
//    @IBOutlet weak var channelDescriptionLabel: ActiveLabel!
//    @IBOutlet weak var username: UILabel!
//    
//    func setChannelDetails(channelDetails: Snippet?) {
//        channelImageView.set_sdWebImage(With: channelDetails?.thumbnails?.thumbnailsDefault?.url, placeHolderImage: "")
//        username.text = Helper.stringValue(channelDetails?.title)
//        channelDescriptionLabel.text = Helper.stringValue(channelDetails?.snippetDescription)
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
