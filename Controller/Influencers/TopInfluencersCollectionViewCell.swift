//
//  TopInfluencersCollectionViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 27/02/22.
//

import UIKit

class TopInfluencersCollectionViewCell: UICollectionViewCell {
    var lblUserName = UILabel()
    var imgUser = UIImageView()
    
    
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
//            viewContainer.backgroundColor = .red
                        
            lblUserName.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(lblUserName)
            lblUserName.text = "Emiley helson"
            lblUserName.textColor = .label
            lblUserName.font = UIFont (name: "RoundedMplus1c-Bold", size: 16)
            
            NSLayoutConstraint.activate([
                lblUserName.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -6),
                lblUserName.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                lblUserName.heightAnchor.constraint(equalToConstant: 24),
            ])
            
            let imgInsta = UIImageView()
            imgInsta.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(imgInsta)
            imgInsta.image = UIImage (named: "instagramicon")
                        
            NSLayoutConstraint.activate([
                imgInsta.centerYAnchor.constraint(equalTo: lblUserName.centerYAnchor, constant: 0),
                imgInsta.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -6),
                imgInsta.heightAnchor.constraint(equalToConstant: 24),
                imgInsta.widthAnchor.constraint(equalToConstant: 24),
            ])
            
            imgUser.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(imgUser)
            imgUser.backgroundColor = .label
            imgUser.image = UIImage (named: "logoDefault")
            imgUser.layer.cornerRadius = 16
            imgUser.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                imgUser.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
                imgUser.bottomAnchor.constraint(equalTo: imgInsta.topAnchor, constant: -10),
                imgUser.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                imgUser.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            ])
            
            return viewContainer
        }()
        
        self.contentView.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
//            viewContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
//            viewContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
//            viewContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 4),
//            viewContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            
            
            viewContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            viewContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            viewContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            viewContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
        ])
        
    }
    
    func setData(_ dictDetails: [String: Any]) {
        imgUser.sd_setImage(with: URL(string: "\(dictDetails["profileImageUrl"]!)"), placeholderImage: UIImage(named: "logoDefault"))
        lblUserName.text = "\(dictDetails["username"]!)"
    }
    
}
