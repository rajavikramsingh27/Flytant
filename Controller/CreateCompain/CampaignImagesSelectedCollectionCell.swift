//
//  CampaignImagesSelectedCollectionCell.swift
//  Flytant-1
//
//  Created by GranzaX on 03/03/22.
//


import UIKit


class CampaignImagesSelectedCollectionCell: UICollectionViewCell {
    var viewContainer: UIView!
    var imgUser: UIImageView!
    var btnCancel: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        viewContainer = {
            let view = UIView()
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            imgUser = UIImageView()
            imgUser.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imgUser)
            imgUser.backgroundColor = .label
            imgUser.image = UIImage (named: "logoDefault")
            imgUser.layer.cornerRadius = 4
            imgUser.clipsToBounds = true
            
            
            NSLayoutConstraint.activate([
                imgUser.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                imgUser.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                imgUser.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                imgUser.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            ])
            
            btnCancel = {
                let button = UIButton()
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setBackgroundImage(UIImage (named: "cancel"), for: .normal)
                
                return button
            }()
            
            NSLayoutConstraint.activate([
                btnCancel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                btnCancel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                btnCancel.heightAnchor.constraint(equalToConstant: 30),
                btnCancel.widthAnchor.constraint(equalToConstant: 30),
            ])
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            viewContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            viewContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            viewContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
        ])
        
    }
    
}
