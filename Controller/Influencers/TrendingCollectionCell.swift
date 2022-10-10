//
//  TrendingCollectionViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 27/02/22.
//

import UIKit
import SDWebImage


class TrendingCollectionCell: UICollectionViewCell {

    var lblCountry = UILabel()
    var lblUserName = UILabel()
    var imgUser = UIImageView()
    var lblSocialScore = UILabel()
    
//    imgUser.image = UIImage (named: "logoDefault")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let viewContainer: UIView = {
            let viewContainer = UIView()
            viewContainer.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.backgroundColor = .systemBackground
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: viewContainer.bounds, cornerRadius: 16).cgPath
            shadowLayer.fillColor = UIColor.systemBackground.cgColor
            
            viewContainer.layer.cornerRadius = 16
            viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
            viewContainer.layer.shadowOpacity = 0.4
            viewContainer.layer.shadowRadius = 10
            viewContainer.layer.shadowOffset = CGSize (width: 0, height: 0)
            viewContainer.layer.insertSublayer(shadowLayer, at: 0)
            
            let viewBorder = UIView()
            viewBorder.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(viewBorder)
            viewBorder.layer.cornerRadius = 16
            viewBorder.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                viewBorder.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
                viewBorder.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                viewBorder.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
                viewBorder.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
            ])
            
            lblCountry.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(lblCountry)
            lblCountry.text = "Italy, 24F"
            lblCountry.textColor = UIColor("4D4C4C")
            lblCountry.font = UIFont (name: "RoundedMplus1c-Bold", size: 12)
            
            NSLayoutConstraint.activate([
                lblCountry.bottomAnchor.constraint(equalTo: viewBorder.bottomAnchor, constant: -13),
                lblCountry.leftAnchor.constraint(equalTo: viewBorder.leftAnchor, constant: 13),
                lblCountry.rightAnchor.constraint(equalTo: viewBorder.rightAnchor, constant: 0),
                lblCountry.heightAnchor.constraint(equalToConstant: 16),
            ])
            
            lblUserName.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(lblUserName)
            lblUserName.text = "@Emiley .h"
            lblUserName.textColor = .label
            lblUserName.font = UIFont (name: "RoundedMplus1c-Bold", size: 14)
//            lblUserNsme.backgroundColor = .red
            
            NSLayoutConstraint.activate([
                lblUserName.bottomAnchor.constraint(equalTo: lblCountry.topAnchor, constant: -6),
                lblUserName.leftAnchor.constraint(equalTo: lblCountry.leftAnchor, constant: 0),
                lblUserName.heightAnchor.constraint(equalToConstant: 16),
            ])
            
            let imgInsta = UIImageView()
            imgInsta.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(imgInsta)
            imgInsta.image = UIImage (named: "instagramicon")
            
            NSLayoutConstraint.activate([
                imgInsta.centerYAnchor.constraint(equalTo: lblUserName.centerYAnchor, constant: 0),
                imgInsta.rightAnchor.constraint(equalTo: viewBorder.rightAnchor, constant: -6),
                imgInsta.heightAnchor.constraint(equalToConstant: 24),
                imgInsta.widthAnchor.constraint(equalToConstant: 24),
                lblUserName.rightAnchor.constraint(equalTo: imgInsta.leftAnchor, constant: -5),
            ])
            
            
            imgUser.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(imgUser)
            imgUser.backgroundColor = .label
            imgUser.image = UIImage (named: "logoDefault")
            
            NSLayoutConstraint.activate([
                imgUser.topAnchor.constraint(equalTo: viewBorder.topAnchor, constant: 0),
                imgUser.bottomAnchor.constraint(equalTo: imgInsta.topAnchor, constant: 0),
                imgUser.leftAnchor.constraint(equalTo: viewBorder.leftAnchor, constant: 0),
                imgUser.rightAnchor.constraint(equalTo: lblCountry.rightAnchor, constant: 0),
            ])
            
            let imgSocialScoreBg = UIImageView()
            imgSocialScoreBg.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(imgSocialScoreBg)
            imgSocialScoreBg.image = UIImage (named: "socialScoreBg")
            
            NSLayoutConstraint.activate([
                imgSocialScoreBg.topAnchor.constraint(equalTo: viewBorder.topAnchor, constant: 0),
                imgSocialScoreBg.rightAnchor.constraint(equalTo: viewBorder.rightAnchor, constant: 0),
                imgSocialScoreBg.heightAnchor.constraint(equalToConstant: 34),
                imgSocialScoreBg.widthAnchor.constraint(equalToConstant: 34),
            ])
            
            lblSocialScore.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(lblSocialScore)
            lblSocialScore.textAlignment = .center
            lblSocialScore.text = "88"
            lblSocialScore.textColor = .white
            lblSocialScore.font = UIFont (name: "RoundedMplus1c-Bold", size: 16)
            
            NSLayoutConstraint.activate([
                lblSocialScore.centerYAnchor.constraint(equalTo: imgSocialScoreBg.centerYAnchor, constant: 0),
                lblSocialScore.centerXAnchor.constraint(equalTo: imgSocialScoreBg.centerXAnchor, constant: 0),
                lblSocialScore.heightAnchor.constraint(equalToConstant: 34),
                lblSocialScore.widthAnchor.constraint(equalToConstant: 34),
            ])
            
            return viewContainer
        }()
        
        self.contentView.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            viewContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            viewContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 4),
            viewContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
        ])
        
    }
    
    func setData(_ dictDetails: [String: Any]) {
        imgUser.sd_setImage(with: URL(string: "\(dictDetails["profileImageUrl"]!)"), placeholderImage: UIImage(named: "logoDefault"))
        lblSocialScore.text = "\(dictDetails["socialScore"]!)"
        lblUserName.text = "@\(dictDetails["username"]!)"        
    }
    
}

