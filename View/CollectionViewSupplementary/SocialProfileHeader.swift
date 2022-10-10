//
//  SocialProfileHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 23/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import DropDown


class SocialProfileHeader: UICollectionViewCell {

   
//    MARK: - Properties

    var delegate: SocialProfileHeaderDelegate?
    var dropDown = DropDown()
    
//    MARK: - Views
    
    let profileCardView = UIView()
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 36, image: UIImage(named: "profile_bottom")!)
    
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: .label)
    
    let additionalDescLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 12)!, textAlignment: .left, textColor: UIColor.label)
    
    let bioLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Regular", size: 12)!, textAlignment: .left, textColor: .label)

   
    let editProfileMessageButton = FButton(backgroundColor: UIColor.systemBackground, title: "", cornerRadius: 5, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 16))
    
    let socialAccountsLabel =  FLabel(backgroundColor: UIColor.clear, text: "Social Accounts", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    
    let socialScoreCardView = UIView()
    
    let socialScoreLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 14)!, textAlignment: .center, textColor: UIColor.label)

    let socialAccountButton = FButton(backgroundColor: UIColor.systemBackground, title: "   Instagram", cornerRadius: 5, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!)
    
    let dropDownIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "dropDown")!)
    
    
// MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureProfileCard()
        configureDropDown()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProfileCard(){
        addSubview(profileCardView)
        profileCardView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 160)
        profileCardView.backgroundColor = UIColor.systemBackground
        profileCardView.layer.cornerRadius = 5
        profileCardView.layer.borderColor = UIColor.label.cgColor
        profileCardView.layer.borderWidth = 1
        profileCardView.layer.shadowColor = UIColor.systemGray.cgColor
        profileCardView.layer.shadowRadius = 0.4
        
        profileCardView.addSubview(profileImageView)
        profileImageView.anchor(top: profileCardView.topAnchor, left: profileCardView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 72, height: 72)
        
        profileCardView.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        profileCardView.addSubview(additionalDescLabel)
        additionalDescLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
        
       
        profileCardView.addSubview(editProfileMessageButton)
        editProfileMessageButton.anchor(top: nil, left: profileCardView.leftAnchor, bottom: profileCardView.bottomAnchor, right: profileCardView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 40)
        editProfileMessageButton.layer.borderColor = UIColor.label.cgColor
        editProfileMessageButton.layer.borderWidth = 1
        editProfileMessageButton.addTarget(self, action: #selector(handleEditProfileMessage), for: .touchUpInside)
        
        
        profileCardView.addSubview(socialScoreCardView)
        socialScoreCardView.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 40, height: 40)
        socialScoreCardView.layer.cornerRadius = 20
        socialScoreCardView.layer.shadowColor = UIColor.systemGray.cgColor
        socialScoreCardView.layer.shadowOpacity = 1
        socialScoreCardView.backgroundColor = UIColor.systemGroupedBackground
        
        socialScoreCardView.addSubview(socialScoreLabel)
        socialScoreLabel.anchor(top: socialScoreCardView.topAnchor, left: socialScoreCardView.leftAnchor, bottom: socialScoreCardView.bottomAnchor, right: socialScoreCardView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(socialAccountsLabel)
        socialAccountsLabel.anchor(top: profileCardView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
       
        addSubview(socialAccountButton)
        socialAccountButton.anchor(top: socialAccountsLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 144, height: 36)
        socialAccountButton.layer.borderColor = UIColor.label.cgColor
        socialAccountButton.layer.borderWidth = 1
        socialAccountButton.contentHorizontalAlignment = .left
        
        socialAccountButton.addSubview(dropDownIV)
        dropDownIV.anchor(top: socialAccountButton.topAnchor, left: nil, bottom: socialAccountButton.bottomAnchor, right: socialAccountButton.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 0)
        
    }
   
    
    private func configureDropDown(){
        dropDown.anchorView = socialAccountButton
        dropDown.dataSource = ["Instagram", "Youtube"]

        dropDown.cellConfiguration = { (index, item) in
            print(item)
            return "\(item)" }
        dropDown.width = 144
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! - 10)
        dropDown.dismissMode = .automatic
        dropDown.backgroundColor = UIColor.systemBackground
        dropDown.textColor = UIColor.label
        dropDown.textFont = UIFont.systemFont(ofSize: 14)
        dropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
        dropDown.selectedTextColor = UIColor.label
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            socialAccountButton.setTitle("   \(item)", for: .normal)
            if index == 0{
                self.handleInstagram()
            }

            if index == 1{
                self.handleYoutube()
            }
        }
        socialAccountButton.addTarget(self, action: #selector(handleSocialButton), for: .touchUpInside)
    }
    
  

    
    
    // MARK: - Handlers
    
   
    @objc func handleEditProfileMessage() {
        delegate?.handleEditProfileMessageButton(for: self)
    }
    
    @objc func handleYoutubeButtonTapped(){
        delegate?.handleYoutubeButtonTapped(for: self)
    }
    
    @objc func handleWebsiteTapped(){
        delegate?.handleWebsiteTapped(for: self)
    }
    

    @objc func handleSocialButton(){
        dropDown.show()
    }
    
    @objc func handleInstagram(){
        delegate?.handleInstagram(for: self)
    }
    
    @objc func handleYoutube(){
        delegate?.handleYoutube(for: self)
    }
}

































//class SocialProfileHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//
////    MARK: - Properties
//
//    var delegate: SocialProfileHeaderDelegate?
//    var dropDown = DropDown()
//
////    MARK: - Views
//
//    let profileCardView = UIView()
//
//    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 32, image: UIImage(named: "profile_bottom")!)
//
//    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: .label)
//
//    let additionalDescLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.label)
//
//    let bioLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: .label)
//
//    let categoriesLabel = FLabel(backgroundColor: UIColor.clear, text: "Categories", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
//
//    var imageCollectionView = FCollectionView()
//
//    let editProfileMessageButton = FButton(backgroundColor: UIColor.systemBackground, title: "", cornerRadius: 5, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 16))
//
//    let socialLabel =  FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
//
//    let socialAccountButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 3, titleColor: UIColor.label, font: UIFont.systemFont(ofSize: 14))
//
//    let youtubeButton = FGradientButton(cgColors: [UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
//    let youtubeIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "youtubeLight")!)
//    let youtubeTextLabel = FLabel(backgroundColor: UIColor.clear, text: "Click to link Youtube Account", font: UIFont.systemFont(ofSize: 14), textAlignment: .center, textColor: UIColor.label)
//
//    let dropDownIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "dropDown")!)
//
//    let firstDataView = UIView()
//
//    let secondDataView = UIView()
//
//    let thirdDataView = UIView()
//
//    let fourthDataView = UIView()
//
//    let firstNumLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
//
//    let secondNumLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
//
//    let thirdNumLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
//
//    let fourthNumLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
//
//    let firstDataLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
//
//    let secondDataLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
//
//    let thirdDataLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
//
//    let fourthDataLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
//
//    let contentLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.label)
//
//// MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureProfileCard()
//        configureDropDown()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configureProfileCard(){
//        addSubview(profileCardView)
//        profileCardView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 248)
//        profileCardView.backgroundColor = UIColor.systemBackground
//        profileCardView.layer.cornerRadius = 5
//        profileCardView.layer.borderColor = UIColor.label.cgColor
//        profileCardView.layer.borderWidth = 1
//
//        profileCardView.addSubview(profileImageView)
//        profileImageView.anchor(top: profileCardView.topAnchor, left: profileCardView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 64, height: 64)
//
//        profileCardView.addSubview(usernameLabel)
//        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
//
//        profileCardView.addSubview(additionalDescLabel)
//        additionalDescLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
//
//        profileCardView.addSubview(bioLabel)
//        bioLabel.anchor(top: profileImageView.bottomAnchor, left: profileCardView.leftAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 24)
//        bioLabel.numberOfLines = 3
//
//        profileCardView.addSubview(categoriesLabel)
//        categoriesLabel.anchor(top: bioLabel.bottomAnchor, left: profileCardView.leftAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//
//        configureImageCollectionView()
//
//        profileCardView.addSubview(editProfileMessageButton)
//        editProfileMessageButton.anchor(top: bioLabel.bottomAnchor, left: profileCardView.leftAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
//        editProfileMessageButton.layer.borderColor = UIColor.label.cgColor
//        editProfileMessageButton.layer.borderWidth = 1
//        editProfileMessageButton.addTarget(self, action: #selector(handleEditProfileMessage), for: .touchUpInside)
//
//        let profileCardViewHeight = NSAttributedString(string: bioLabel.text ?? "").size().height
//        profileCardView.heightAnchor.constraint(equalToConstant: profileCardViewHeight + 160).isActive = true
//
//        addSubview(socialLabel)
//        socialLabel.anchor(top: profileCardView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//
//        addSubview(socialAccountButton)
//        socialAccountButton.anchor(top: socialLabel.bottomAnchor, left: socialLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 144, height: 36)
//        socialAccountButton.layer.borderColor = UIColor.label.cgColor
//        socialAccountButton.layer.borderWidth = 1
//        socialAccountButton.contentHorizontalAlignment = .left
//
//        socialAccountButton.addSubview(dropDownIV)
//        dropDownIV.anchor(top: socialAccountButton.topAnchor, left: nil, bottom: socialAccountButton.bottomAnchor, right: socialAccountButton.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 12, paddingRight: 4, width: 16, height: 0)
//
//        addSubview(youtubeButton)
//        youtubeButton.anchor(top: socialAccountButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 64, height: 64)
//        youtubeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        youtubeButton.gradientLayer.cornerRadius = 32
//        youtubeButton.addTarget(self, action: #selector(handleYoutubeButtonTapped), for: .touchUpInside)
//        youtubeButton.addSubview(youtubeIV)
//        youtubeIV.anchor(top: youtubeButton.topAnchor, left: youtubeButton.leftAnchor, bottom: youtubeButton.bottomAnchor, right: youtubeButton.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
//        addSubview(youtubeTextLabel)
//        youtubeTextLabel.anchor(top: youtubeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//
//        let dataViewSide = (frame.width - 56)/4
//
//        addSubview(firstDataView)
//        firstDataView.anchor(top: socialAccountButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: dataViewSide, height: dataViewSide)
//        firstDataView.backgroundColor = UIColor.systemBackground
//        firstDataView.layer.cornerRadius = dataViewSide/2
//
//        addSubview(secondDataView)
//        secondDataView.anchor(top: socialAccountButton.bottomAnchor, left: firstDataView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: dataViewSide, height: dataViewSide)
//        secondDataView.backgroundColor = UIColor.systemBackground
//        secondDataView.layer.cornerRadius = dataViewSide/2
//
//        addSubview(thirdDataView)
//        thirdDataView.anchor(top: socialAccountButton.bottomAnchor, left: secondDataView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: dataViewSide, height: dataViewSide)
//        thirdDataView.backgroundColor = UIColor.systemBackground
//        thirdDataView.layer.cornerRadius = dataViewSide/2
//
//        addSubview(fourthDataView)
//        fourthDataView.anchor(top: socialAccountButton.bottomAnchor, left: thirdDataView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: dataViewSide, height: dataViewSide)
//        fourthDataView.backgroundColor = UIColor.systemBackground
//        fourthDataView.layer.cornerRadius = dataViewSide/2
//
//        addSubview(firstNumLabel)
//        firstNumLabel.anchor(top: firstDataView.topAnchor, left: firstDataView.leftAnchor, bottom: firstDataView.bottomAnchor, right: firstDataView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(secondNumLabel)
//        secondNumLabel.anchor(top: secondDataView.topAnchor, left: secondDataView.leftAnchor, bottom: secondDataView.bottomAnchor, right: secondDataView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(thirdNumLabel)
//        thirdNumLabel.anchor(top: thirdDataView.topAnchor, left: thirdDataView.leftAnchor, bottom: thirdDataView.bottomAnchor, right: thirdDataView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(fourthNumLabel)
//        fourthNumLabel.anchor(top: fourthDataView.topAnchor, left: fourthDataView.leftAnchor, bottom: fourthDataView.bottomAnchor, right: fourthDataView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(firstDataLabel)
//        firstDataLabel.anchor(top: firstDataView.bottomAnchor, left: firstDataView.leftAnchor, bottom: nil, right: firstDataView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
//
//        addSubview(secondDataLabel)
//        secondDataLabel.anchor(top: secondDataView.bottomAnchor, left: secondDataView.leftAnchor, bottom: nil, right: secondDataView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
//
//        addSubview(thirdDataLabel)
//        thirdDataLabel.anchor(top: thirdDataView.bottomAnchor, left: thirdDataView.leftAnchor, bottom: nil, right: thirdDataView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
//
//        addSubview(fourthDataLabel)
//        fourthDataLabel.anchor(top: fourthDataView.bottomAnchor, left: fourthDataView.leftAnchor, bottom: nil, right: fourthDataView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
//
//        addSubview(contentLabel)
//        contentLabel.anchor(top: firstDataLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 24, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//
//        guard let categories = UserDefaults.standard.array(forKey: CATEGORIES) else {return}
//        guard let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID) else {return}
//        if youtubeId.isEmpty || youtubeId == ""{
//            contentLabel.isHidden = true
//
//            firstDataView.isHidden = true
//            firstNumLabel.isHidden = true
//            firstDataLabel.isHidden = true
//
//            secondDataView.isHidden = true
//            secondNumLabel.isHidden = true
//            secondDataLabel.isHidden = true
//
//            thirdDataView.isHidden = true
//            thirdNumLabel.isHidden = true
//            thirdDataLabel.isHidden = true
//
//            fourthDataView.isHidden = true
//            fourthNumLabel.isHidden = true
//            fourthDataLabel.isHidden = true
//
//        }else{
//            youtubeButton.isHidden = true
//            youtubeTextLabel.isHidden = true
//        }
//
//
//        imageCollectionView.isHidden = true
//        categoriesLabel.isHidden = true
//
//    }
//
//    private func configureImageCollectionView(){
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
//        imageCollectionView.backgroundColor = .clear
//        imageCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
//        imageCollectionView.layer.cornerRadius = 10
//        profileCardView.addSubview(imageCollectionView)
//        imageCollectionView.anchor(top: categoriesLabel.bottomAnchor, left: profileCardView.leftAnchor, bottom: nil, right: profileCardView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 32)
//    }
//
//    private func configureDropDown(){
//        dropDown.anchorView = socialAccountButton
//        dropDown.dataSource = ["Youtube", "Instagram"]
//
//        dropDown.cellConfiguration = { (index, item) in
//            print(item)
//            return "\(item)" }
//        dropDown.width = 144
//        dropDown.direction = .bottom
//        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! - 10)
//        dropDown.dismissMode = .automatic
//        dropDown.backgroundColor = UIColor.systemBackground
//        dropDown.textColor = UIColor.label
//        dropDown.textFont = UIFont.systemFont(ofSize: 14)
//        dropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
//        dropDown.selectedTextColor = UIColor(red: 14/255, green: 143/255, blue: 183/255, alpha: 1)
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index == 0{
//                print("Youtube")
//            }
//
//            if index == 1{
//                self.handleInstagram()
//            }
//        }
//        socialAccountButton.addTarget(self, action: #selector(handleSocialButton), for: .touchUpInside)
//    }
//
//
////    MARK: - CollectionView Delegate and DataSource
//
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let categories = UserDefaults.standard.array(forKey: CATEGORIES) else {return 0}
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! CategoriesCollectionViewCell
//        delegate?.addCategoriesData(for: cell, indexPath: indexPath)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let categories = UserDefaults.standard.array(forKey: CATEGORIES) else {return CGSize.zero}
//        let text = NSAttributedString(string: categories[indexPath.row] as! String)
//        return CGSize(width: text.size().width + 36, height: imageCollectionView.bounds.height)
//
//    }
//
//
//
//    // MARK: - Handlers
//
//    @objc func handleFollowersTapped() {
//        delegate?.handleFollowersTapped(for: self)
//    }
//
//    @objc func handleFollowingTapped() {
//        delegate?.handleFollowingTapped(for: self)
//    }
//
//    @objc func handleEditProfileMessage() {
//        delegate?.handleEditProfileMessageButton(for: self)
//    }
//
//    @objc func handleYoutubeButtonTapped(){
//        delegate?.handleYoutubeButtonTapped(for: self)
//    }
//
//    @objc func handleWebsiteTapped(){
//        delegate?.handleWebsiteTapped(for: self)
//    }
//
//
//    @objc func handleSocialButton(){
//        dropDown.show()
//    }
//
//    @objc func handleInstagram(){
//        delegate?.handleInstagram(for: self)
//    }
//}
//
