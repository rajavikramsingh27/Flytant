//
//  InfluencersCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 27/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//


import UIKit

class InfluencersCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let bgView = UIView()
    let influencerIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 12)!, textAlignment: .left, textColor: .label)
    var imageCollectionView = FCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBgView()
        configureInfluencerIV()
        configureUsernameLabel()
        configureImageCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureBgView(){
        addSubview(bgView)
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        bgView.backgroundColor = UIColor.systemBackground
        bgView.layer.cornerRadius = 10
    }

    private func configureInfluencerIV(){
        bgView.addSubview(influencerIV)
        influencerIV.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        influencerIV.layer.cornerRadius = 10
    }

    private func configureUsernameLabel(){
        bgView.addSubview(usernameLabel)
        usernameLabel.anchor(top: influencerIV.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 100, height: 16)
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
        imageCollectionView.anchor(top: influencerIV.bottomAnchor, left: usernameLabel.rightAnchor, bottom: usernameLabel.bottomAnchor, right: bgView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: -8, paddingRight: 2, width: 144, height: 48)
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
        return CGSize(width: 16, height: 16)
    }

}

