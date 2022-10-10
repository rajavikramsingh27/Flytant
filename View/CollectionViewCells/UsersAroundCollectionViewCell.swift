//
//  UsersAroundCollectionViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 28/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import CoreLocation

class UsersAroundCollectionViewCell: UICollectionViewCell {
    
//    MARK: - Properties
    
//    MARK: - Views
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let ageLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.systemBackground)
    let distanceLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .right, textColor: UIColor.systemBackground)
    let labelBackgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
        addSubview(labelBackgroundView)
        labelBackgroundView.backgroundColor = UIColor.secondaryLabel
        labelBackgroundView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 24)
        
        labelBackgroundView.addSubview(ageLabel)
        ageLabel.anchor(top: labelBackgroundView.topAnchor, left: labelBackgroundView.leftAnchor, bottom: labelBackgroundView.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 4, paddingBottom: 2, paddingRight: 0, width: 60, height: 0)
        
        labelBackgroundView.addSubview(distanceLabel)
        distanceLabel.anchor(top: labelBackgroundView.topAnchor, left: nil, bottom: labelBackgroundView.bottomAnchor, right: labelBackgroundView.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 4, width: 60, height: 0)
    }
    
    func loadUserData(user: Users, location: CLLocation){
        profileImageView.loadImage(with: user.profileImageURL)
    
        let userLatitude = user.geoPoint.latitude
        let userLongitude = user.geoPoint.longitude
        let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        let distanceInMiles = userLocation.distance(from: location) * (0.000621371)
        distanceLabel.text = "\(Int(distanceInMiles)) mi"
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        if let date = dateformatter.date(from: user.dateOfBirth ?? ""){
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.year], from: date, to: Date())
            ageLabel.text = "\(components.year ?? 22) yrs"
        }
        
    }
    
  
}
