//
//  AnonymousView.swift
//  Flytant
//
//  Created by Vivek Rai on 22/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class AnonymousView: UIView {
    
    var delegate: AnonymousLoginViewDelegate?

    let bgView = UIView()
    let topView = UIView()
    let iconImage = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "anonymousLoginIcon")!)
    let textLabel = FLabel(backgroundColor: UIColor.clear, text: "Continue using by logging in?", font: UIFont.systemFont(ofSize: 20), textAlignment: .center, textColor: UIColor.black)
    let loginButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Login", cornerRadius: 4, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 16))
    let cancelButton = FButton(backgroundColor: UIColor.clear, title: "Cancel", cornerRadius: 4, titleColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), font: UIFont.boldSystemFont(ofSize: 16))
    
    let cancelView = UIView()
    let loginView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        addSubview(bgView)
        bgView.backgroundColor = UIColor.white

        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 320, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 200)
        
        bgView.addSubview(topView)
        topView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        topView.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        bgView.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 30),
            iconImage.widthAnchor.constraint(equalToConstant: 30),
            iconImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        
        bgView.addSubview(textLabel)
        textLabel.anchor(top: topView.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        bgView.addSubview(cancelView)
        cancelView.anchor(top: textLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 64)
        bgView.addSubview(loginView)
        loginView.anchor(top: textLabel.bottomAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 64)
        NSLayoutConstraint.activate([
            cancelView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.5),
            loginView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.5),
        ])
        
        cancelView.addSubview(cancelButton)
        cancelButton.anchor(top: cancelView.topAnchor, left: cancelView.leftAnchor, bottom: cancelView.bottomAnchor, right: cancelView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
        cancelButton.layer.borderColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        loginView.addSubview(loginButton)
        loginButton.anchor(top: loginView.topAnchor, left: loginView.leftAnchor, bottom: loginView.bottomAnchor, right: loginView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleCancel(){
        delegate?.handleCancel()
    }
    
    @objc private func handleLogin(){
        delegate?.handleLogin()
    }
}
