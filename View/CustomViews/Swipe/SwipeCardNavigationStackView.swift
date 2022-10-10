//
//  SwipeCardsNavigationStackView.swift
//  Flytant
//
//  Created by Vivek Rai on 29/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SwipeCardNavigationStackView: UIStackView {
    
//    MARK: - Properties
    
    var delegate: SwipeHeaderDelegate?
    
//   MARK: - Views
    
    let findUsersButton = UIButton()
    let settingsButton = UIButton()
    let iconImageView = UIImageView(image: UIImage(named: "datingTopIcon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(UIImage(named: "settingsDatingIcon"), for: .normal)
        findUsersButton.setImage(UIImage(named: "findUsersIcon"), for: .normal)
        
        [settingsButton, UIView(), iconImageView, UIView(), findUsersButton].forEach{ view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        findUsersButton.addTarget(self, action: #selector(handleFindUsers), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSettings(){
        delegate?.handleSettings()
    }
    
    @objc func handleFindUsers(){
        delegate?.handleFindUsers()
    }
}
