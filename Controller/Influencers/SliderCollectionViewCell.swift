

//  InfluencersCollectionViewCell.swift
//  Flytant-1
//  Created by GranzaX on 27/02/22.


import UIKit


class SliderCollectionViewCell: UICollectionViewCell {
    var imgSlider = UIImageView()
    var btnClick = UIButton()
    
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
            viewContainer.layer.shadowOpacity = 1
            viewContainer.layer.shadowRadius = 4
            viewContainer.layer.shadowOffset = CGSize (width: 0, height: 0)
            viewContainer.layer.insertSublayer(shadowLayer, at: 0)
            
            let viewBorder = UIView()
            viewBorder.layer.cornerRadius = 16
            viewBorder.clipsToBounds = true
            viewBorder.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(viewBorder)
            
            NSLayoutConstraint.activate([
                viewBorder.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
                viewBorder.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
                viewBorder.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                viewBorder.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            ])
            
            imgSlider.image = UIImage (named: "logoDefault")
            imgSlider.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(imgSlider)
            
            NSLayoutConstraint.activate([
                imgSlider.topAnchor.constraint(equalTo: viewBorder.topAnchor, constant: 0),
                imgSlider.bottomAnchor.constraint(equalTo: viewBorder.bottomAnchor, constant: 0),
                imgSlider.leftAnchor.constraint(equalTo: viewBorder.leftAnchor, constant: 0),
                imgSlider.rightAnchor.constraint(equalTo: viewBorder.rightAnchor, constant: 0),
            ])
            
            btnClick.clipsToBounds = true
            btnClick.translatesAutoresizingMaskIntoConstraints = false
            viewBorder.addSubview(btnClick)
            
            
            NSLayoutConstraint.activate([
                btnClick.topAnchor.constraint(equalTo: viewBorder.topAnchor, constant: 0),
                btnClick.bottomAnchor.constraint(equalTo: viewBorder.bottomAnchor, constant: 0),
                btnClick.leftAnchor.constraint(equalTo: viewBorder.leftAnchor, constant: 0),
                btnClick.rightAnchor.constraint(equalTo: viewBorder.rightAnchor, constant: 0),
            ])
            
            return viewContainer
        }()
        
        self.contentView.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            viewContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            viewContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            viewContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
        ])
        
    }
    
    func setData(_ dictDetails: [String: Any]) {
        imgSlider.sd_setImage(with: URL(string: "\(dictDetails["imageUrl"]!)"), placeholderImage: UIImage(named: "logoDefault"))
    }
    
    
}
