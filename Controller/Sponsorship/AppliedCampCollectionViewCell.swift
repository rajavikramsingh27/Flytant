//
//  AppliedCampCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AppliedCampCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

//    MARK: - Properties
    
    var sponsorships: Sponsorships? {
        didSet{
            guard let price = sponsorships?.price else {return}
            guard let currency = sponsorships?.currency else {return}
            guard let influencers = sponsorships?.influencers else {return}
            guard let minFollowers = sponsorships?.minFollowers else {return}
            guard let creationDate = sponsorships?.creationDate else {return}
            guard let name = sponsorships?.name else {return}
            guard let gender = sponsorships?.gender else {return}
            guard let blob = sponsorships?.blob else {return}
            guard let userId = sponsorships?.userId else {return}
            guard let isApproved = sponsorships?.isApproved else {return}
            let date = creationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let stringOutput = dateFormatter.string(from: date)
          
            
            if price == 0{
                priceLabel.text = "Give Away " + "|" + " \(stringOutput)"
            }else{
                priceLabel.text = "Price: \(currency)\(price) " + "|" + " \(stringOutput)"
            }
            
            genderLabel.text = "Preferred: " + gender
            
            appliedLabel.text = "\(influencers.count) Applied"
            minFollowersLabel.text = "Min Followers: " + formatPoints(from: minFollowers)
            
          
            titleLabel.text = name
            bgImageView.sd_setImage(with: URL(string: blob[0]["path"] ?? ""), placeholderImage: UIImage(named: ""))
            
            imageCollectionView.reloadData()
            
//            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//            if currentUserId == userId{
//                if isApproved{
//                    reviewIV.image = UIImage(named: "ribbonGreen")
//                    reviewLabel.text = "Approved"
//                }else{
//                    reviewIV.image = UIImage(named: "ribbonOrange")
//                    reviewLabel.text = "In Review"
//                }
//            }else{
//                reviewIV.image = UIImage()
//                reviewLabel.text = ""
//            }
        }
    }
        
//    MARK: - Views
    let bgView = UIView()
    let bottomView = UIView()
   
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.clear
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(SocialPlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        return collection
    }()
    
    let bgImageView = FImageView(backgroundColor: UIColor.systemGray2, cornerRadius: 5, image: UIImage())
    let appliedIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "appliedRibbon")!)
    let appliedLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .center, textColor: UIColor.white)
    let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!, textAlignment: .left, textColor: UIColor.label)
    
    let priceLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 12)!, textAlignment: .left, textColor: UIColor.label)
    let genderLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 12)!, textAlignment: .left, textColor: UIColor.label)
    let minFollowersLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let dateLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 12)!, textAlignment: .right, textColor: UIColor.label)

    
    
   
    
    
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
        //bgView.backgroundColor = UIColor.secondarySystemBackground
        bgView.layer.cornerRadius = 10
        
        bgView.addSubview(bgImageView)
        bgImageView.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom:  bgView.bottomAnchor, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 0, height: 0)
        bgImageView.layer.cornerRadius = 10
        
        bgView.addSubview(appliedIV)
        appliedIV.anchor(top: bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 24)
        appliedIV.addSubview(appliedLabel)
        appliedLabel.anchor(top: appliedIV.topAnchor, left: appliedIV.leftAnchor, bottom: appliedIV.bottomAnchor, right: appliedIV.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        bgView.addSubview(bottomView)
        bottomView.backgroundColor = .systemBackground
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset =  CGSize.zero
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowRadius = 4
        bottomView.layer.cornerRadius = 15
        bottomView.anchor(top: bgImageView.bottomAnchor, left: bgView.leftAnchor, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, paddingTop: -40, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 80)
        
        
        bottomView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.anchor(top: bottomView.topAnchor, left:  bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        
        bottomView.addSubview(priceLabel)
        priceLabel.textAlignment = .center
        priceLabel.anchor(top:  titleLabel.bottomAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
//
//        bgView.addSubview(genderLabel)
//
//        genderLabel.anchor(top: priceLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 110, height: 16)
//
//        bgView.addSubview(minFollowersLabel)
//        minFollowersLabel.anchor(top: titleLabel.bottomAnchor, left: bgView.rightAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 120, height: 16)
//        bgView.addSubview(dateLabel)
//        dateLabel.anchor(top: minFollowersLabel.bottomAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
//        configureImageCollectionView()
//        addSubview(bgImageView)
//        bgImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
//        addSubview(priceLabel)
//        priceLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 0, height: 30)
//        priceLabel.gradientLayer.cornerRadius = 5
//        priceLabel.contentMode = .center
//        addSubview(appliedLabel)
//        appliedLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 8, width: 0, height: 30)
//        addSubview(minFollowersLabel)
//        minFollowersLabel.anchor(top: nil, left: leftAnchor, bottom: priceLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 8, paddingRight: 0, width: 0, height: 20)
//        addSubview(dateLabel)
//        dateLabel.anchor(top: nil, left: leftAnchor, bottom: minFollowersLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
//        addSubview(titleLabel)
//        titleLabel.anchor(top: nil, left: leftAnchor, bottom: dateLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
//        configureImageCollectionView()
//
//        bgImageView.addSubview(bgView)
//        bgView.anchor(top: bgImageView.topAnchor, left: bgImageView.leftAnchor, bottom: bgImageView.bottomAnchor, right: bgImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
//
//        bgImageView.addSubview(reviewIV)
//        reviewIV.anchor(top: bgImageView.topAnchor, left: nil, bottom: nil, right: bgImageView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 24)
//        bgImageView.addSubview(reviewLabel)
//        reviewLabel.anchor(top: reviewIV.topAnchor, left: reviewIV.leftAnchor, bottom: reviewIV.bottomAnchor, right: reviewIV.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
    }
    
    private func configureImageCollectionView(){
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        bgView.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: bgImageView.bottomAnchor, left: titleLabel.rightAnchor, bottom: minFollowersLabel.topAnchor, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 110, height: 36)
   
      
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
        print(sponsorships?.platforms,"sponsorships?.platforms")
        if sponsorships?.platforms[indexPath.row] == "Youtube"{
            cell.iconIV.image = UIImage(named: "youtubeicon")
        }else if sponsorships?.platforms[indexPath.row] == "Instagram"{
            cell.iconIV.image = UIImage(named: "instagramicon")
        }else if sponsorships?.platforms[indexPath.row] == "Facebook"{
            cell.iconIV.image = UIImage(named: "facebookicon")
        }
        else if sponsorships?.platforms[indexPath.row] == "Linkedin"{
            cell.iconIV.image = UIImage(named: "linkedin")
        }
        else{
            
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
