//
//  ProfileHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit
import Firebase

class ProfileHeader: UICollectionViewCell {
    
//    MARK: - Properties

    var delegate: ProfileHeaderDelegate?
    
//    MARK: - Views
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 50, image: UIImage())
    
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: .label)
    
    let postsLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)

    lazy var followersLabel =  FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
        
    lazy var followingLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
    
//    lazy var websiteButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Visit Website", cornerRadius: 3, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
    lazy var websiteButton = FGradientButton(cgColors:[UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    
    let bioLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .center, textColor: .label)

//    lazy var editProfileFollowButton = FButton(backgroundColor: UIColor.systemBackground, title: "Edit Profile", cornerRadius: 5, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 16))
    
    lazy var editProfileFollowButton = FGradientButton(cgColors:[UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    
             
        
// MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureProfileImageView()
        configureNameLabel()
        configureWebsiteButton()
        configureBioLabel()
        configurePostsLabel()
        configureFollowersLabel()
        configureFollowingLabel()
        configureUserStats()
        configureEditProfileFollowButton()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProfileImageView(){
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.contentMode = .scaleToFill
        //profileImageView.layer.borderWidth = 1
        //profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
    }
        
    private func configureNameLabel(){
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        nameLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
    }
    
    
    private func configureWebsiteButton(){
        addSubview(websiteButton)
        websiteButton.gradientLayer.cornerRadius = 5
        websiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        websiteButton.setTitle("Visit Website", for: .normal)
        websiteButton.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 30)
        websiteButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        websiteButton.addTarget(self, action: #selector(handleWebsiteTapped), for: .touchUpInside)
    }
    
    private func configureBioLabel(){
        bioLabel.numberOfLines = 0
        addSubview(bioLabel)
        bioLabel.anchor(top: websiteButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        bioLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        bioLabel.text = ""
    }
    
    private func configurePostsLabel(){
        postsLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
        postsLabel.attributedText = attributedText
    }
    
    private func configureFollowersLabel(){
        followersLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
        followersLabel.attributedText = attributedText
        
        // add gesture recognizer
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        followersLabel.isUserInteractionEnabled = true
        followersLabel.addGestureRecognizer(followTap)
    }
    
    private func configureFollowingLabel(){
        followingLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
        followingLabel.attributedText = attributedText
        
        // add gesture recognizer
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followTap.numberOfTapsRequired = 1
        followingLabel.isUserInteractionEnabled = true
        followingLabel.addGestureRecognizer(followTap)
    }
    
    private func configureUserStats() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: bioLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
    }
        
    private func configureEditProfileFollowButton(){
        addSubview(editProfileFollowButton)
        editProfileFollowButton.gradientLayer.cornerRadius = 5
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 40)
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        editProfileFollowButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        editProfileFollowButton.layer.borderWidth = 1
    }
    
    
    // MARK: - Handlers
    
    @objc func handleFollowersTapped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped() {
        delegate?.handleFollowingTapped(for: self)
    }

    @objc func handleEditProfileFollow() {
        delegate?.handleEditFollowTapped(for: self)
    }
    
    @objc func handleWebsiteTapped(){
        delegate?.handleWebsiteTapped(for: self)
    }
    
    func setUserStats(for user: User?) {
//        delegate?.setUserStats(for: self)
    }
}
