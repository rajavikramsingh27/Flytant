//
//  MyCampaignCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 28/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MyCampaignCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

//    MARK: - Properties
    
    var sponsorships: Sponsorships? {
        didSet{
            guard let price = sponsorships?.price else {return}
            guard let currency = sponsorships?.currency else {return}
            guard let influencers = sponsorships?.influencers else {return}
            guard let minFollowers = sponsorships?.minFollowers else {return}
            guard let creationDate = sponsorships?.creationDate else {return}
            guard let name = sponsorships?.name else {return}
            guard let blob = sponsorships?.blob else {return}
            guard let userId = sponsorships?.userId else {return}
            guard let isApproved = sponsorships?.isApproved else {return}
            if price == 0{
                priceLabel.text = "Give Away"
            }else{
                priceLabel.text = "Price: \(currency)\(price)"
            }
            appliedLabel.text = "\(influencers.count) Applied"
            minFollowersLabel.text = "Min Followers: \(minFollowers)"
            dateLabel.text = "Posted: \(creationDate.timeAgoToDisplay())"
            titleLabel.text = name
            bgImageView.sd_setImage(with: URL(string: blob[0]["path"] ?? ""), placeholderImage: UIImage(named: ""))
            
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if currentUserId == userId{
                if isApproved{
                    statusText.setTitle("Approved", for: .normal)
                }else{
                    statusText.setTitle("In Review", for: .normal)
                }
            }else{
                reviewIV.image = UIImage()
                reviewLabel.text = ""
            }
        }
    }
        
//    MARK: - Views
    let bgView = UIView()
    let bgImageView = FImageView(backgroundColor: UIColor.systemGray2, cornerRadius: 5, image: UIImage())
    let appliedIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "appliedRibbon")!)
    let appliedLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .center, textColor: UIColor.white)
    let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!, textAlignment: .left, textColor: UIColor.label)
    var imageCollectionView = FCollectionView()
    let priceLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let minFollowersLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let dateLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 12)!, textAlignment: .right, textColor: UIColor.label)
   
    let statusText = FGradientButton(cgColors: [UIColor.secondarySystemBackground.cgColor, UIColor.secondarySystemBackground.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
   
    
    
    let reviewIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let reviewLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        
        addSubview(bgView)
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        bgView.backgroundColor = UIColor.secondarySystemBackground
        bgView.layer.cornerRadius = 10
        
        bgView.addSubview(bgImageView)
        bgImageView.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 210)
        bgImageView.layer.cornerRadius = 10
        bgView.addSubview(appliedIV)
        appliedIV.anchor(top: bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 24)
        appliedIV.addSubview(appliedLabel)
        appliedLabel.anchor(top: appliedIV.topAnchor, left: appliedIV.leftAnchor, bottom: appliedIV.bottomAnchor, right: appliedIV.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bgView.addSubview(titleLabel)
        titleLabel.anchor(top: bgImageView.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 240, height: 20)
        bgView.addSubview(priceLabel)
        priceLabel.anchor(top: titleLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 16)
        bgView.addSubview(minFollowersLabel)
        minFollowersLabel.anchor(top: titleLabel.bottomAnchor, left: priceLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 16)
        bgView.addSubview(dateLabel)
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: minFollowersLabel.rightAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
        bgView.addSubview(statusText)
        statusText.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 96, height: 32)
        statusText.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 14)
        statusText.gradientLayer.cornerRadius = 5
        statusText.setTitleColor(UIColor.label, for: .normal)
        configureImageCollectionView()
        
    }
    
    private func configureImageCollectionView(){
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(SocialPlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        imageCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        bgView.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: bgImageView.bottomAnchor, left: titleLabel.rightAnchor, bottom: dateLabel.topAnchor, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 144, height: 36)
    }
    
//    MARK: - CollectionView Delegate and DataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let platformCount = sponsorships?.platforms.count else {return 0}
        return platformCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! SocialPlatformsCollectionViewCell
        if sponsorships?.platforms[indexPath.row] == "Youtube"{
            cell.iconIV.image = UIImage(named: "youtubeicon")
        }else if sponsorships?.platforms[indexPath.row] == "Instagram"{
            cell.iconIV.image = UIImage(named: "instagramicon")
        }else if sponsorships?.platforms[indexPath.row] == "Facebook"{
            cell.iconIV.image = UIImage(named: "facebookicon")
        }else{
            cell.iconIV.image = UIImage(named: "twittericon")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        showResults()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
