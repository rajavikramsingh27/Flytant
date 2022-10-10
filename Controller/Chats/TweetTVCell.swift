////
////  TweetTVCell.swift
////  Flytantapp
////
////  Created by Vivek Singh Mehta on 02/10/21.
////
//
//import UIKit
//import ActiveLabel
//
//final class TweetTVCell: UITableViewCell {
//
//    @IBOutlet weak var retweetedView: UIView!
//    @IBOutlet weak var retweetedLabel: UILabel!
//    
//    @IBOutlet weak var tweetView: UIView!
//    @IBOutlet weak var profileImageView: RoundImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
//    
//    @IBOutlet weak var tweetLabel: ActiveLabel!
//    
//    @IBOutlet weak var tweetImageContainerView: UIView!
//    @IBOutlet weak var tweetImageView: UIImageView!
//    
//    @IBOutlet weak var tweetCountView: UIView!
//    @IBOutlet weak var retweetCount: UILabel!
//    @IBOutlet weak var favouriteCount: UILabel!
//    
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
//    func showTweets(_ model: TwitterTweetModel, profile: Profile) {
//        if model.retweetedStatus != nil {
//            if profile == .user {
//                retweetedLabel.text = "You retweeted"
//            } else {
//                retweetedLabel.text = Helper.stringValue(model.user?.name) + " retweeted"
//            }
//            retweetedView.isHidden = false
//            profileImageView.set_sdWebImage(With: model.retweetedStatus?.user?.profileImageURLHTTPS, placeHolderImage: "")
//            nameLabel.text = Helper.stringValue(model.retweetedStatus?.user?.name)
//            usernameLabel.text = "@" + Helper.stringValue(model.retweetedStatus?.user?.screenName)
//            retweetCount.text = Helper.intValue(model.retweetedStatus?.retweetCount).description
//            favouriteCount.text = Helper.intValue(model.retweetedStatus?.favoriteCount).description
//            tweetLabel.text = Helper.stringValue(model.text)
//        } else {
//            if model.extendedEntities != nil {
//                tweetImageContainerView.isHidden = false
//                tweetImageView.set_sdWebImage(With: model.extendedEntities?.media?.first?.mediaURLHTTPS, placeHolderImage: "")
//            } else {
//                tweetImageContainerView.isHidden = true
//            }
//            profileImageView.set_sdWebImage(With: model.user?.profileImageURLHTTPS, placeHolderImage: "")
//            nameLabel.text = Helper.stringValue(model.user?.name)
//            usernameLabel.text = "@" + Helper.stringValue(model.user?.screenName)
//            retweetedView.isHidden = true
//            tweetLabel.text = Helper.stringValue(model.text)
//            retweetCount.text = Helper.intValue(model.retweetCount).description
//            favouriteCount.text = Helper.intValue(model.favoriteCount).description
//        }
//    }
//    
//}
