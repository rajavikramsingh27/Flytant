//
//  YoutubeVideoTVCell.swift
//  Flytant
//
//  Created by Flytant on 29/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

final class YoutubeVideoTVCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var blur: UIVisualEffectView!
    
    var stats: Statistics? {
        didSet {
            viewsLabel.text = Helper.stringValue(stats?.viewCount)
            likeLabel.text = Helper.stringValue(stats?.likeCount)
            dislikeLabel.text = Helper.stringValue(stats?.dislikeCount)
            CommentLabel.text = Helper.stringValue(stats?.commentCount)
        }
    }
    
    var showStats: Bool = false {
        didSet {
            if showStats {
                showBlur()
            } else {
                hideBlur()
            }
        }
    }
    
    
    func setVideoDetails(title: String?, thumbnail: String?) {
        videoTitle.text = Helper.stringValue(title)
        thumbnailImageView.set_sdWebImage(With: thumbnail, placeHolderImage: "")
    }
    
    func hideBlur() {
        blur.isHidden = true
    }
    
    func showBlur() {
        blur.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideBlur()
        blur.layer.cornerRadius = 5
        blur.layer.masksToBounds = true
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
