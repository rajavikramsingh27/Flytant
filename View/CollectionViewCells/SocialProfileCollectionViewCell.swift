//
//  SocialProfileCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 23/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class YoutubeProfileCollectionViewCell: UICollectionViewCell {
    
    let postIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let titleLabel = FLabel(backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.white)
    let viewsLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 10), textAlignment: .center, textColor: UIColor.white)
    let likesLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 10), textAlignment: .center, textColor: UIColor.white)
    let dislikesLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 10), textAlignment: .center, textColor: UIColor.white)
    let commentsLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 10), textAlignment: .center, textColor: UIColor.white)
    let viewsIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "viewsIcon")!)
    let likesIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "likesIcon")!)
    let dislikesIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "dislikesIcon")!)
    let commentsIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "commentsIcon")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        addSubview(postIV)
        postIV.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        let width = (frame.width-56)/4
        addSubview(viewsLabel)
        viewsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: width, height: 20)
        addSubview(likesLabel)
        likesLabel.anchor(top: topAnchor, left: viewsLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: width, height: 20)
        addSubview(dislikesLabel)
        dislikesLabel.anchor(top: topAnchor, left: likesLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: width, height: 20)
        addSubview(commentsLabel)
        commentsLabel.anchor(top: topAnchor, left: dislikesLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: width, height: 20)
        addSubview(viewsIV)
        viewsIV.anchor(top: viewsLabel.bottomAnchor, left: viewsLabel.leftAnchor, bottom: nil, right: viewsLabel.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        addSubview(likesIV)
        likesIV.anchor(top: likesLabel.bottomAnchor, left: likesLabel.leftAnchor, bottom: nil, right: likesLabel.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        addSubview(dislikesIV)
        dislikesIV.anchor(top: dislikesLabel.bottomAnchor, left: dislikesLabel.leftAnchor, bottom: nil, right: dislikesLabel.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        addSubview(commentsIV)
        commentsIV.anchor(top: commentsLabel.bottomAnchor, left: commentsLabel.leftAnchor, bottom: nil, right: commentsLabel.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
    
        
        viewsIV.isHidden = true
        viewsLabel.isHidden = true
        likesIV.isHidden = true
        likesLabel.isHidden = true
        dislikesIV.isHidden = true
        dislikesLabel.isHidden = true
        commentsIV.isHidden = true
        commentsLabel.isHidden = true
    }
}
