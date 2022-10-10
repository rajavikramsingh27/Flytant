//
//  TrendingCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 27/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let bgView = UIView()
    let influencerIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 12)!, textAlignment: .left, textColor: .label)
    let additionalInfoLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 10)!, textAlignment: .left, textColor: .systemGray)
    let socialScoreView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "socialScoreBg")!)
    let socialScoreLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: UIColor.white)
    var imageCollectionView = FCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBgView()
        configureInfluencerIV()
        configureUsernameLabel()
        configureAdditionalInfoLabel()
        configureSocialScoreView()
        configureImageCollectionView()
    }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
           
    private func configureBgView(){
        addSubview(bgView)
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        bgView.backgroundColor = UIColor.secondarySystemBackground
        bgView.layer.cornerRadius = 10
    }
    
    private func configureInfluencerIV(){
        bgView.addSubview(influencerIV)
        influencerIV.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 160)
        influencerIV.layer.cornerRadius = 10
    }
    
    private func configureUsernameLabel(){
        bgView.addSubview(usernameLabel)
        usernameLabel.anchor(top: influencerIV.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 64, height: 16)
    }
    
    private func configureAdditionalInfoLabel(){
        bgView.addSubview(additionalInfoLabel)
        additionalInfoLabel.anchor(top: usernameLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 16)
    }
    
    private func configureSocialScoreView(){
        bgView.addSubview(socialScoreView)
        socialScoreView.anchor(top: bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        socialScoreView.addSubview(socialScoreLabel)
        NSLayoutConstraint.activate([
            socialScoreLabel.centerXAnchor.constraint(equalTo: socialScoreView.centerXAnchor),
            socialScoreLabel.centerYAnchor.constraint(equalTo: socialScoreView.centerYAnchor),
            
        ])
    }
    
    private func configureImageCollectionView(){
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(SocialPlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        imageCollectionView.layer.shadowColor = UIColor.label.cgColor
        imageCollectionView.layer.shadowOpacity = 1
        imageCollectionView.layer.shadowOffset = .zero
        imageCollectionView.layer.shadowRadius = 0
        imageCollectionView.layer.cornerRadius = 0
        imageCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        bgView.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: influencerIV.bottomAnchor, left: usernameLabel.rightAnchor, bottom: additionalInfoLabel.topAnchor, right: bgView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 180, height: 48)
//        imageCollectionView.backgroundColor = UIColor.systemRed
        
    }
    
    
//    MARK: - CollectionView Delegate and DataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! SocialPlatformsCollectionViewCell
        cell.iconIV.image = UIImage(named: "instagramicon")
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
        return CGSize(width: 12, height: 12)
    }

}
