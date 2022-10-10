//
//  ShopFeedCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 22/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ActiveLabel
import ImageSlideshow
import ChameleonFramework

class ShopFeedCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    var shopPosts: ShopPosts? {
        didSet{
            guard let shopIconUrl = shopPosts?.storeIcon else {return}
            shopProfileImageView.loadImage(with: shopIconUrl)
                 
            guard let shopName = shopPosts?.storeName else {return}
            shopNameLabel.text = shopName
                 
            guard let buttonTitle = shopPosts?.websiteButtonTitle else {return}
            websiteButton.setTitle("  \(buttonTitle)", for: .normal)
            
            guard let imageUrls = shopPosts?.imageUrls else {return}
            imageUrls.forEach { (url) in
                sliderImages.append(AlamofireSource(urlString: url)!)
            }
            slideShow.setImageInputs(sliderImages)
            sliderImages.removeAll()
                 
            guard let creationDate = shopPosts?.creationDate else {return}
            timeLabel.text = creationDate.timeAgoToDisplay()
                                  
            guard let description = shopPosts?.description else {return}
            
            let customType = ActiveType.custom(pattern: "^\(shopName)\\b")
            descriptionLabel.enabledTypes = [.mention, .hashtag, customType]
            descriptionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                            
                switch type {
                    case .custom:
                        atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 16)
                    default: ()
                }
                return atts
            }
            descriptionLabel.customize { (label) in
                
                label.text = "\(shopName): \(description)"
                label.customColor[customType] = .label
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .label
                label.hashtagColor = .systemPink
                label.mentionColor = .systemPink
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
            }
                 
            descriptionLabel.handleCustomTap(for: customType) { (shopName) in
                self.handleActiveLabelShopNameTapped(shopName: shopName)
            }
        }
    }
    
    var delegate: ShopFeedCellDelegate?
    
    var sliderImages = [InputSource]()
    
//    MARK: - Views
    
    lazy var shopProfileImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 20, image: UIImage())
    let shopNameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "5 days ago", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
    lazy var threeDotButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
    let slideShow = FImageSlideShow(backgroundColor: UIColor.randomFlat())
    let websiteButton = FButton(backgroundColor: UIColor.randomFlat(), title: "Learn More", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 16))
    let nextImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "nextIcon")!)
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(shopProfileImageView)
        shopProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        shopProfileImageView.clipsToBounds = true
        shopProfileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShopName))
        tapGesture.numberOfTapsRequired = 1
        shopProfileImageView.addGestureRecognizer(tapGesture)
        
        addSubview(shopNameLabel)
        shopNameLabel.anchor(top: topAnchor, left: shopProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        shopNameLabel.isUserInteractionEnabled = true
        let shopNameLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShopName))
        shopNameLabelTapGesture.numberOfTapsRequired = 1
        shopNameLabel.addGestureRecognizer(shopNameLabelTapGesture)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: shopNameLabel.bottomAnchor, left: shopProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        
        addSubview(threeDotButton)
        threeDotButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        threeDotButton.setImage(UIImage(named: "horizontalThreeDot"), for: .normal)
        threeDotButton.addTarget(self, action: #selector(handleThreeDotTapped), for: .touchUpInside)
        
        addSubview(slideShow)
        slideShow.anchor(top: shopProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
        
        addSubview(websiteButton)
        websiteButton.anchor(top: slideShow.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        websiteButton.contentHorizontalAlignment = .left
        websiteButton.addSubview(nextImageView)
        nextImageView.anchor(top: websiteButton.topAnchor, left: nil, bottom: websiteButton.bottomAnchor, right: websiteButton.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 30, height: 0)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: websiteButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    @objc func handleShopName(){
        delegate?.handleShopNameTapped(for: self)
    }
    
    @objc func handleThreeDotTapped(){
        delegate?.handleThreeDotTapped(for: self)
    }
    
    @objc func didTap(){
        delegate?.handleSlideShowTapped(for: self)
    }
    
    @objc func websiteButtonTapped(){
        delegate?.handleWebsiteButtonTapped(for: self)
    }
    
    @objc func handleActiveLabelShopNameTapped(shopName: String){
        delegate?.handleActiveLabelShopNameTapped(for: self, shopName: shopName)
    }
}
