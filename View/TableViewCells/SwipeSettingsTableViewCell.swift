//
//  SwipeSettingsTableViewCell.swift
//  Flytant
//
//  Created by Vivek Rai on 31/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class SwipeSettingsTableViewCell: UITableViewCell{
    
//    MARK: - Properties
    
    var delegate: SwipeSettingsDelegate?
    
    var viewModel: SwipeSettingsViewModel!{
        didSet{
            configure()
        }
    }
    
    lazy var inputField: UITextField = {
        let tf =  UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        let paddingView = UIView()
        paddingView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 24, height: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextField), for: .touchDown)
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(inputField)
        inputField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
    }
    
    @objc func handleTextField(sender: UITextField){
        guard let value = sender.text else {return}
        delegate?.handleUpdateUserInfo(for: self, value: value, section: viewModel.section)
        
    }
}
