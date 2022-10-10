//
//  SwipeSettingsHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 31/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class SwipeSettingsHeader: UIView{
   
//    MARK: - Views
    
    var buttons = [UIButton]()
    
    var delegate: SwipeSettingsHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        let button1 = createButton(index: 0)
        let button2 = createButton(index: 1)
        let button3 = createButton(index: 2)
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        
        addSubview(button1)
        button1.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(index: Int) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .secondarySystemBackground
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }
    
    @objc private func handleSelectPhoto(sender: UIButton){
        delegate?.handlePhotoPicker(for: self, didSelect: sender.tag)
    }
}
