//
//  SponsorAppliedStickerLabel.swift
//  Flytant
//
//  Created by Flytant on 09/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class FSponsorAppliedStickerLabel: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let stickerImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named: "appliedSponorSticker")
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    let appliedLbl : FLabel = {
        let lbl = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.white)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        
    }
    
    private func setUpUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stickerImageView)
        addSubview(appliedLbl)
        
        stickerImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stickerImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stickerImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stickerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        appliedLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        appliedLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
