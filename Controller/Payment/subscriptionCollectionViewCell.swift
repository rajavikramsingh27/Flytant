//
//  subscriptionCollectionViewCell.swift
//  Flytant
//
//  Created by Nitish Kumar on 08/02/22.
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import UIKit

class subscriptionCollectionViewCell: UICollectionViewCell {
    
    let bgView = UIView()
    
    let subsTypeLabel = UILabel()
    let priceLabel = UILabel()
    let priceMonthLabel = UILabel()
    let imageCollection = UIView()
    let planFeatureLabel = UILabel()
    
    let image1 = UIImageView()
    let image2 = UIImageView()
    let image3 = UIImageView()
    let image4 = UIImageView()
    let subscriberLabel = UILabel()
    
    
    let chooseButton = UIButton()
    let termOfUseButton = UIButton()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
     
        addSubview(bgView)
        updateConstraints()
    }
    
    override func updateConstraints() {
        
   
        bgView.backgroundColor = .secondarySystemBackground
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 15
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right:rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        bgView.addSubview(subsTypeLabel)
        subsTypeLabel.backgroundColor = .systemBackground
        subsTypeLabel.text = "    Basic    "
        subsTypeLabel.layer.cornerRadius = 10
        subsTypeLabel.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)

        bgView.addSubview(priceLabel)
        priceLabel.text = "$99"
        priceLabel.font = AppFont.font(type: .Bold, size: 18)
        priceLabel.anchor(top: subsTypeLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)


        bgView.addSubview(priceMonthLabel)
        priceMonthLabel.text = "/month"
        priceMonthLabel.font = AppFont.font(type: .Medium, size: 14)
        priceMonthLabel.textColor = .darkGray
        priceMonthLabel.anchor(top: subsTypeLabel.bottomAnchor, left: priceLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        bgView.addSubview(planFeatureLabel)
        planFeatureLabel.text = "Plan Features"
        planFeatureLabel.font = AppFont.font(type: .Medium, size: 16)
        planFeatureLabel.anchor(top: priceLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        bgView.addSubview(imageCollection)
       // imageCollection.backgroundColor = .red
        imageCollection.anchor(top: bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 10, width: 100, height: 40)

        image1.image = #imageLiteral(resourceName: "dummmy")
        imageCollection.addSubview(image1)
        //
        image1.anchor(top: imageCollection.topAnchor, left: imageCollection.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 2, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        //image1.roundCorners([.allCorners], radius: 15)
        image1.ImageViewRounded(cornerRadius:15)

        image2.image = #imageLiteral(resourceName: "grow2")
        imageCollection.addSubview(image2)
       //
        image2.anchor(top: imageCollection.topAnchor, left: image1.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        image2.ImageViewRounded(cornerRadius:15)


        image3.image = #imageLiteral(resourceName: "grow3")
        imageCollection.addSubview(image3)
       // image2.roundCorners([.allCorners], radius: 15)
        //
        image3.anchor(top: imageCollection.topAnchor, left: image2.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
       // image3.roundCorners([.allCorners], radius: 15)
        image3.ImageViewRounded(cornerRadius:15)

        image4.image = #imageLiteral(resourceName: "grow4")
        imageCollection.addSubview(image4)
       //
        image4.anchor(top: imageCollection.topAnchor, left: image3.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        //image4.roundCorners([.allCorners], radius: 15)
        image4.ImageViewRounded(cornerRadius:15)


        bgView.addSubview(subscriberLabel)
        subscriberLabel.text = "Subscribers"
        subscriberLabel.textAlignment = .center
        subscriberLabel.font = AppFont.font(type: .Medium, size: 14)
        subscriberLabel.anchor(top: imageCollection.bottomAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 100, height: 40)




        bgView.addSubview(chooseButton)
        chooseButton.setTitle("Choose Plan", for: .normal)
        chooseButton.backgroundColor = .systemBackground
        chooseButton.layer.cornerRadius = 15
        chooseButton.setTitleColor(.label, for: .normal)
        chooseButton.anchor(top: nil, left: bgView.leftAnchor, bottom: bgView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: frame.width/2-70, paddingBottom: 60, paddingRight: 0, width: 140, height: 60)


        bgView.addSubview(termOfUseButton)
        termOfUseButton.setTitle("Term of use", for: .normal)
        termOfUseButton.setTitleColor(.label, for: .normal)
        termOfUseButton.anchor(top: nil, left: bgView.leftAnchor, bottom: bgView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: frame.width/2-60, paddingBottom: 20, paddingRight: 0, width: 120, height: 30)


        super.updateConstraints()
    
    }
    
    
   
}
