//
//  SubscriptionCollectionViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 20/02/22.
//

import Foundation
import UIKit
import SDWebImage


class SubscriptionCollectionViewCell: UICollectionViewCell {
    
    var viewNoPlanActive: UIView!
    
    var btnChoosePlan:UIButton!
    var btnTermsOfUse: UIButton!
    
    var index = 0
    
    var imgSubscriber1:UIImageView!
    var imgSubscriber2:UIImageView!
    var imgSubscriber3:UIImageView!
    var imgSubscriber4:UIImageView!
    
    var btnBasic:UIButton!
    var lblPrice:UILabel!
    var lblPerMonth: UILabel!
    var lblPerMonthDisable:UILabel!
    var lblPriceDisable:UILabel!
    var lblRSDisable:UILabel!
    var lblGetOff:UILabel!
    
    var imgCheck:UIImageView!
    var lblHigherVisibilty:UILabel!
    
    var imgCheck2:UIImageView!
    var lblApplyCampgains:UILabel!
    
    var imgCheck3:UIImageView!
    var lblGetDirectMessagesCredit:UILabel!
    
    var imgCheck4:UIImageView!
    var lblProfileRecommendation:UILabel!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundView?.backgroundColor = UIColor.yellow
        
        
        addViews()
    }
    
    func showImage() {
        imgSubscriber1.sd_setImage(with: URL(string:arrUserSubscribed[0+index]), placeholderImage: nil)
        imgSubscriber2.sd_setImage(with: URL(string:arrUserSubscribed[1+index]), placeholderImage: nil)
        imgSubscriber3.sd_setImage(with: URL(string:arrUserSubscribed[2+index]), placeholderImage: nil)
        imgSubscriber4.sd_setImage(with: URL(string:arrUserSubscribed[3+index]), placeholderImage: nil)
    }
    
    func addViews() {
        let sizeCollCell = self.contentView.frame.size
        viewNoPlanActive = UIView (frame: CGRect(x: 0, y: 5, width: sizeCollCell.width-10, height: sizeCollCell.height-10))
        
        viewNoPlanActive.backgroundColor = .systemBackground
        
        viewNoPlanActive.defaultShadow()
        
        self.contentView.addSubview(viewNoPlanActive)
        
        setUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrice(_ prices: Double, _ dictDetails:[String: Any]) {
//        lblPrice.text = String(format: "%.02f", 3.32323242)
        lblPrice.text = String(format: "%.02f", prices)
        lblPrice.frame.size.width = lblPrice.text!.textSize(UIFont (name: kFontBold, size: 24)!).width+4
        lblPerMonth.frame.origin.x = lblPrice.frame.size.width+lblPrice.frame.origin.x
        
        let offPrice = (prices*Double("\(dictDetails["inPercentageOff"] ?? "0")")!)/100
        
        let dblUSStrikePrice = Double(prices)+Double(offPrice)
        let attributedTextPrice = NSAttributedString(
            string: String(format: "%.02f", dblUSStrikePrice),
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        lblPriceDisable.attributedText = attributedTextPrice
        lblPriceDisable.frame.size.width = lblPriceDisable.text!.textSize(UIFont (name: kFontBold, size: 24)!).width
        lblPerMonthDisable.frame.origin.x = lblPriceDisable.frame.size.width+lblPriceDisable.frame.origin.x
        
        let attributedTextRS = NSAttributedString(
            string: kCurrencySymbol,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        lblRSDisable.attributedText = attributedTextRS
        lblRSDisable.frame.size.width = kCurrencySymbol.textSize(UIFont (name: kFontBold, size: 20)!).width
    }
    
    func setData(_ dictDetails:[String: Any]) {
        btnBasic.setTitle("\(dictDetails["name"] ?? "Wrong ...")", for: .normal)
        btnBasic.frame.size.width = btnBasic.titleLabel!.text!.textSize(UIFont (name: kFontBold, size: 24)!).width+10
        
        lblGetOff.text = "Get \(dictDetails["inPercentageOff"] ?? "Wrong ...")% Off"
        
        let arrFeatures = dictDetails["features"] as! [[String: Any]]
        
        let isActiveFirst = arrFeatures[0]["active"] as! Bool
        imgCheck.image = UIImage (named: isActiveFirst ? "check.png" : "cancel.png")
        lblHigherVisibilty.text = "\(arrFeatures[0]["title"]!)"
        lblHigherVisibilty.textColor = isActiveFirst ? .label : UIColor.init("7E7E7E")
        
        let isActiveSecond = arrFeatures[1]["active"] as! Bool
        imgCheck2.image = UIImage (named: isActiveSecond ? "check.png" : "cancel.png")
        lblApplyCampgains.text = "\(arrFeatures[1]["title"]!)"
        lblApplyCampgains.textColor = isActiveSecond ? .label : UIColor.init("7E7E7E")
        
        let isActiveThird = arrFeatures[2]["active"] as! Bool
        imgCheck3.image = UIImage (named: isActiveThird ? "check.png" : "cancel.png")
        lblGetDirectMessagesCredit.text = "\(arrFeatures[2]["title"]!)"
        lblGetDirectMessagesCredit.textColor = isActiveThird ? .label : UIColor.init("7E7E7E")
        
        let isActiveFourth = arrFeatures[3]["active"] as! Bool
        imgCheck4.image = UIImage (named: isActiveFourth ? "check.png" : "cancel.png")
        lblProfileRecommendation.text = "\(arrFeatures[3]["title"]!)"
        lblProfileRecommendation.textColor = isActiveFourth ? .label : UIColor.init("7E7E7E")
    }
    
    func setUI() {
        btnBasic = UIButton (frame: CGRect (x: 30, y: 30, width: 76, height: 34))
        btnBasic.backgroundColor = .systemBackground
        
        btnBasic.titleLabel?.font = UIFont (name: kFontMedium, size: 16)
        btnBasic.setTitleColor(.systemBackground, for: .normal)
        btnBasic.backgroundColor = .label
        
        btnBasic.layer.cornerRadius = 2
        btnBasic.clipsToBounds = true
        
        viewNoPlanActive.addSubview(btnBasic)
        
        
        imgSubscriber1 = UIImageView (frame: CGRect (x: 233, y: 26,
                                                     width: 30, height: 30))
        imgSubscriber1.backgroundColor = .systemBackground
        imgSubscriber1.layer.cornerRadius = imgSubscriber1.frame.size.height/2
        imgSubscriber1.clipsToBounds = true
        
        viewNoPlanActive.addSubview(imgSubscriber1)
        
        imgSubscriber2 = UIImageView (frame: CGRect (x: 245, y: 26,
                                                     width: 30, height: 30))
        imgSubscriber2.backgroundColor = .systemBackground
        imgSubscriber2.layer.cornerRadius = imgSubscriber2.frame.size.height/2
        imgSubscriber2.clipsToBounds = true
        
        viewNoPlanActive.addSubview(imgSubscriber2)
        
        imgSubscriber3 = UIImageView (frame: CGRect (x: 257, y: 26,
                                                     width: 30, height: 30))
        imgSubscriber3.backgroundColor = .systemBackground
        imgSubscriber3.layer.cornerRadius = imgSubscriber3.frame.size.height/2
        imgSubscriber3.clipsToBounds = true
        
        viewNoPlanActive.addSubview(imgSubscriber3)
        
        imgSubscriber4 = UIImageView (frame: CGRect (x: 269, y: 26,
                                                     width: 30, height: 30))
        imgSubscriber4.backgroundColor = .systemBackground
        imgSubscriber4.layer.cornerRadius = imgSubscriber4.frame.size.height/2
        imgSubscriber4.clipsToBounds = true
        
        viewNoPlanActive.addSubview(imgSubscriber4)
        
        let lblSubscriber = UILabel (frame: CGRect (x: 233, y: 53,
                                                    width: 100, height: 30))
        lblSubscriber.text = "Subscribers"
        lblSubscriber.textColor = UIColor.init("7E7E7E")
        lblSubscriber.font = UIFont (name: kFontMedium, size: 10)
        viewNoPlanActive.addSubview(lblSubscriber)
        
        let lblRS = UILabel (frame: CGRect (x: 30, y: 83,
                                            width: 20, height: 30))
        lblRS.text = kCurrencySymbol
        lblRS.textColor = .label
        lblRS.font = UIFont (name: kFontMedium, size: 20)
        viewNoPlanActive.addSubview(lblRS)
        
        lblPrice = UILabel (frame: CGRect (
                                x: lblRS.frame.size.width+lblRS.frame.origin.x,
                                y: 83,
                                width: 100,
                                height: 36))
        
        lblPrice.textColor = .label
        lblPrice.font = UIFont (name: kFontBold, size: 24)
        viewNoPlanActive.addSubview(lblPrice)
        
        lblPerMonth = UILabel (frame: CGRect (x: lblPrice.frame.size.width+lblPrice.frame.origin.x+5, y: 88,
                                                  width: 60, height: 36))

        lblPerMonth.text = "/ month"
        lblPerMonth.textColor = UIColor.init("606060")
        lblPerMonth.font = UIFont (name: kFontBold, size: 14)
        viewNoPlanActive.addSubview(lblPerMonth)
        
        
        lblRSDisable = UILabel (frame: CGRect (x: 30, y: 117,
                                               width: 20, height: 30))
        lblRSDisable.textColor = UIColor.init("979797")
        lblRSDisable.font = UIFont (name: kFontMedium, size: 20)
        viewNoPlanActive.addSubview(lblRSDisable)
        
        
        lblPriceDisable = UILabel (frame: CGRect (x: lblRSDisable.frame.size.width+lblRSDisable.frame.origin.x,
                                                  y:115,
                                                  width: 40,
                                                  height: 36))
        
        lblPriceDisable.textColor = UIColor.init("979797")
        lblPriceDisable.font = UIFont (name: kFontBold, size: 24)
        viewNoPlanActive.addSubview(lblPriceDisable)
        
        let attributedTextMonth = NSAttributedString(
            string: " / month",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        lblPerMonthDisable = UILabel (frame: CGRect (x: lblPriceDisable.frame.size.width+lblPriceDisable.frame.origin.x, y: 117,
                                                         width: 60, height: 36))
        
        lblPerMonthDisable.attributedText = attributedTextMonth
        lblPerMonthDisable.textColor = UIColor.init("979797")
        lblPerMonthDisable.font = UIFont (name: kFontBold, size: 14)
        viewNoPlanActive.addSubview(lblPerMonthDisable)
        
        lblGetOff = UILabel (frame: CGRect (
                                x: lblPerMonthDisable.frame.size.width+lblPerMonthDisable.frame.origin.x+23,
                                y: 117,
                                width: 114,
                                height: 36))
        
        lblGetOff.textColor = .label
        lblGetOff.textAlignment = .right
        lblGetOff.font = UIFont (name: kFontBold, size: 12)
        viewNoPlanActive.addSubview(lblGetOff)
        
        let lblPlanFeature = UILabel (frame: CGRect (
                                        x: 42,
                                        y: 150,
                                        width: 130,
                                        height: 36))
        lblPlanFeature.text = "Plan Features"
        lblPlanFeature.textColor = .label
        lblPlanFeature.font = UIFont (name: kFontBold, size: 16)
        viewNoPlanActive.addSubview(lblPlanFeature)
        
        imgCheck = UIImageView (frame: CGRect(x: 30, y: 200,
                                              width: 18,
                                              height: 18))
        
        viewNoPlanActive.addSubview(imgCheck)
        
        lblHigherVisibilty = UILabel (frame: CGRect (
                                        x: imgCheck.frame.origin.x+imgCheck.frame.size.width+10,
                                        y: 194,
                                        width: viewNoPlanActive.frame.size.width-70,
                                        height: 30))
        lblHigherVisibilty.textAlignment = .left
        lblHigherVisibilty.textColor = .label
        lblHigherVisibilty.font = UIFont(name: kFontBold, size: 14)
        
        viewNoPlanActive.addSubview(lblHigherVisibilty)
        
        imgCheck2 = UIImageView (frame: CGRect(x: 30, y: 247,
                                               width: 18,
                                               height: 18))
        
        viewNoPlanActive.addSubview(imgCheck2)
        
        
        lblApplyCampgains = UILabel (frame: CGRect (
                                        x: imgCheck2.frame.origin.x+imgCheck2.frame.size.width+10,
                                        y: 242,
                                        width: viewNoPlanActive.frame.size.width-70,
                                        height: 30))
        lblApplyCampgains.textAlignment = .left
        lblApplyCampgains.textColor = .label
        lblApplyCampgains.font = UIFont(name: kFontBold, size: 14)
        
        viewNoPlanActive.addSubview(lblApplyCampgains)
        
        imgCheck3 = UIImageView (frame: CGRect(x: 30, y: 296,
                                               width: 18,
                                               height: 18))
        
        
        viewNoPlanActive.addSubview(imgCheck3)
        
        lblGetDirectMessagesCredit = UILabel (frame: CGRect (
                                                x: imgCheck3.frame.origin.x+imgCheck3.frame.size.width+10,
                                                y: 291,
                                                width: viewNoPlanActive.frame.size.width-70,
                                                height: 30))
        lblGetDirectMessagesCredit.textAlignment = .left
        lblGetDirectMessagesCredit.textColor = .label
        lblGetDirectMessagesCredit.font = UIFont(name: kFontBold, size: 14)
        
        viewNoPlanActive.addSubview(lblGetDirectMessagesCredit)
        
        
        imgCheck4 = UIImageView (frame: CGRect(x: 30, y: 342,
                                               width: 18,
                                               height: 18))
        
        viewNoPlanActive.addSubview(imgCheck4)
        
        lblProfileRecommendation = UILabel (frame: CGRect (
                                                x: imgCheck4.frame.origin.x+imgCheck4.frame.size.width+10,
                                                y: 337,
                                                width: viewNoPlanActive.frame.size.width-70,
                                                height: 30))
        lblProfileRecommendation.textAlignment = .left
        lblProfileRecommendation.textColor = UIColor.init("7E7E7E")
        lblProfileRecommendation.font = UIFont(name: kFontBold, size: 14)
        
        viewNoPlanActive.addSubview(lblProfileRecommendation)
        
        btnChoosePlan = UIButton (frame: CGRect (x: viewNoPlanActive.frame.size.width/2-(186/2), y: 390, width: 186, height: 44))
        btnChoosePlan.setTitle("Choose Plan", for: .normal)
        btnChoosePlan.titleLabel?.font = UIFont (name: kFontMedium, size: 16)
        btnChoosePlan.setTitleColor(.systemBackground, for: .normal)
        btnChoosePlan.backgroundColor = .label
        btnChoosePlan.layer.cornerRadius = 2
        btnChoosePlan.clipsToBounds = true
        
        viewNoPlanActive.addSubview(btnChoosePlan)
        
        btnTermsOfUse = UIButton (frame: CGRect (x: viewNoPlanActive.frame.size.width/2-(186/2), y: 430, width: 186, height: 44))
        btnTermsOfUse.setTitleColor(UIColor.init("706C6C"), for: .normal)
        btnTermsOfUse.setTitle("Terms of use", for: .normal)
        
        viewNoPlanActive.addSubview(btnTermsOfUse)
    }
    
    
}


