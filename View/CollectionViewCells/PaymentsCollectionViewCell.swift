//
//  PaymentsCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 26/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class PaymentsCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    var payments: Payments? {
        didSet{
            guard let name = payments?.username else {return}
            nameLabel.text = name
            
            guard let paymentStatus = payments?.status else {return}
            paymentStatusLabel.text = paymentStatus
            
            guard let amount = payments?.amount else {return}
            amountLabel.text = "$\(amount)"
            
            guard let date = payments?.creationDate else {return}
            dateLabel.text = "\(date)"
            
            guard let paymentMode = payments?.paymentMode else {return}
            if paymentMode == "paypal"{
                paymentModeImageView.image = UIImage(named: "paypalIcon")
            }else{
                paymentModeImageView.image = UIImage(named: "paytmIcon")
            }
        }
    }
        
//    MARK: - Views
    
    let paymentModeImageView = FImageView(backgroundColor: UIColor.label, cornerRadius: 22, image: UIImage())
    
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
    
    let paymentStatusLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.secondaryLabel)
    
    let amountLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .right, textColor: UIColor.flatGreen())
    
    let dateLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .right, textColor: UIColor.secondaryLabel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
    
        addSubview(paymentModeImageView)
        paymentModeImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: paymentModeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
        
        addSubview(paymentStatusLabel)
        paymentStatusLabel.anchor(top: nameLabel.bottomAnchor, left: paymentModeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 16)
        
        addSubview(amountLabel)
        amountLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 200, height: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: amountLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 200, height: 16)
        
    }
}
