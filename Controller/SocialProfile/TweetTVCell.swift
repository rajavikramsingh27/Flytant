//
//  TweetTVCell.swift
//  Flytantapp
//
//  Created by Vivek Singh Mehta on 02/10/21.
//

import UIKit
import ActiveLabel

final class TweetTVCell: UITableViewCell {

    @IBOutlet weak var retweetedView: UIView!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    @IBOutlet weak var tweetView: UIView!
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: ActiveLabel!
    
    @IBOutlet weak var tweetImageContainerView: UIView!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    @IBOutlet weak var tweetCountView: UIView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
