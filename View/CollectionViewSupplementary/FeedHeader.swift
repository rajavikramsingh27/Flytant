//
//  FeedHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "feedHeader"

class FeedHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var delegate: FeedHeaderDelegate?
    
    
//    MARK: - Views
    
    var storyCollectionView: UICollectionView!
    
    let topSeparatorView = UIView()
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 15, image: UIImage(named: "avatarPlaceholder")!)
    
    let whatsNewButton = FButton(backgroundColor: UIColor.systemGray6, title: "   What's new?", cornerRadius: 10, titleColor: UIColor.secondaryLabel, font: UIFont.systemFont(ofSize: 16))
    
    let imagePickerImageView = FImageView(backgroundColor: UIColor.systemBackground, cornerRadius: 0, image: UIImage(named: "imagePickerImage")!)
    
    let bottomSeparatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //configureStoryCollectionView()
        
        addSubview(topSeparatorView)
        topSeparatorView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        topSeparatorView.backgroundColor = UIColor.systemGray6
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topSeparatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        profileImageView.isUserInteractionEnabled = true
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenProfile))
        profileImageViewTapGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        
        addSubview(imagePickerImageView)
        imagePickerImageView.anchor(top: topSeparatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 36, height: 36)
        imagePickerImageView.contentMode = .scaleAspectFill
        imagePickerImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenGallery))
        tapGesture.numberOfTapsRequired = 1
        imagePickerImageView.addGestureRecognizer(tapGesture)
        
        addSubview(whatsNewButton)
        whatsNewButton.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: imagePickerImageView.leftAnchor, paddingTop: -3, paddingLeft: 8, paddingBottom: -3, paddingRight: 8, width: 0, height: 0)
        whatsNewButton.contentHorizontalAlignment = .left
        whatsNewButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        
        addSubview(bottomSeparatorView)
        bottomSeparatorView.anchor(top: whatsNewButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        bottomSeparatorView.backgroundColor = UIColor.systemGray6
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStoryCollectionView(){
        storyCollectionView = UICollectionView(frame: frame, collectionViewLayout: UIHelper.createSingleRowFlowLayout(in: self))
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyCollectionView.backgroundColor = .clear
        storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storyCollectionView.showsHorizontalScrollIndicator = false
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier ?? "feedHeader")
        addSubview(storyCollectionView)
        storyCollectionView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 80)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "feedHeader", for: indexPath) as! StoryCollectionViewCell
        //delegate?.handleSelectedCategory(for: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "feedHeader", for: indexPath) as! StoryCollectionViewCell
        delegate?.handleStory(for: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc func handleOpenProfile(){
        delegate?.handleUserProfile(for: self)
    }
    
    @objc func handlePost(){
        delegate?.handlePost(for: self)
    }
    
    @objc func handleOpenGallery(){
        delegate?.handleOpenGallery(for: self)
    }
    
}
