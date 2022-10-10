//
//  UsersAroundHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 28/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class UsersAroundHeader: UICollectionViewCell {
    
//    MARK: - Properties
    
    var delegate: UsersAroundHeaderDelegate?
    
//    MARK: - Views

    let segmentedControl = UISegmentedControl(items: ["Male", "Female", "Both"])
    let showmapImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "locationIcon")!)
    let slider: UISlider = {
        var slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 999
        slider.isContinuous = true
        slider.value = Float(100)
        slider.tintColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        return slider
    }()
    let distanceLabel = FLabel(backgroundColor: UIColor.clear, text: "100 miles", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHeaderViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderViews(){
        addSubview(distanceLabel)
        distanceLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 60, height: 20)
        distanceLabel.isHidden = true
        
        addSubview(slider)
        slider.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: distanceLabel.leftAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        slider.addTarget(self, action: #selector(handleSlider(slider:event:)), for: .valueChanged)
                
        
        addSubview(showmapImageView)
        showmapImageView.anchor(top: distanceLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 48, height: 48)
        showmapImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleShowMap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        showmapImageView.addGestureRecognizer(tapGestureRecognizer)

        addSubview(segmentedControl)
        segmentedControl.isUserInteractionEnabled = true
        segmentedControl.anchor(top: slider.bottomAnchor, left: leftAnchor, bottom: nil, right: showmapImageView.leftAnchor, paddingTop: 16, paddingLeft: 4, paddingBottom: 0, paddingRight: 8, width: 0, height: 36)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        segmentedControl.backgroundColor = UIColor.secondarySystemBackground
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.layer.borderColor = UIColor.systemBackground.cgColor
        segmentedControl.layer.borderWidth = 2
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(sender:)), for: .valueChanged)
    }
    
    @objc func handleShowMap(){
        delegate?.handleShowmap(for: self)
    }
    
    @objc func handleSegmentedControl(sender: UISegmentedControl){
        debugPrint("Segmented")
        delegate?.handleSegmentedControl(for: self, sender: sender)
    }
    
    @objc private func handleSlider(slider: UISlider, event: UIEvent){
        delegate?.handleSlider(for: self, sender: slider, event: event)
    }
    
}
