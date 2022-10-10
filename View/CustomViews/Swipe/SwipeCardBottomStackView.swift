//
//  SwipeCardBottomStackView.swift
//  Flytant
//
//  Created by Vivek Rai on 29/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SwipeCardBottomStackView: UIStackView {
    
//    MARK: - Properties
    
    var delegate: SwipeBottomDelegate?

//   MARK: - Views
    
    let refreshButton = UIButton()
    let dislikeButton = UIButton()
    let superLikeButton = UIButton()
    let likesButton = UIButton()
    let boostButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        refreshButton.setImage(UIImage(), for: .normal)
        dislikeButton.setImage(UIImage(named: "dismiss_circle"), for: .normal)
        superLikeButton.setImage(UIImage(), for: .normal)
        likesButton.setImage(UIImage(named: "like_circle"), for: .normal)
        boostButton.setImage(UIImage(), for: .normal)
        
        [refreshButton, dislikeButton, superLikeButton, likesButton, boostButton].forEach{ view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        dislikeButton.addTarget(self, action: #selector(handleDisike), for: .touchUpInside)
        likesButton.addTarget(self, action: #selector(handlelike), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleDisike(){
        delegate?.handleDislike()
    }
    
    @objc private func handlelike(){
        delegate?.handleLike()
    }
    
}
