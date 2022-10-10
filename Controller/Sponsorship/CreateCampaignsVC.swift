////
////  CreateCampaignVC.swift
////  Flytant
////
////  Created by Vivek Rai on 17/12/20.
////  Copyright © 2020 Vivek Rai. All rights reserved.
////
//
//import UIKit
//import DropDown
//import SwiftToast
//import YPImagePicker
//
//private let reuseIdentifier = "imageCollectionViewCell"
//
//class CreateCampaignsVC: UIViewController {
//    
//    //    MARK: - Properties
//    var toast = SwiftToast()
//    var selectedItems = [YPMediaItem]()
//    var selectedImages = [UIImage]()
//    var selectedImageUrls = [String]()
//    var selectedPlatforms = [String]()
//    var genderData = ["Select Gender", "Female", "Male", "Any"]
//    var categoryData = [String]()
//    var isInstagramButtonSelected = false
//    var isYoutubeButtonSelected = false
//    var isFacebookSelected = false
//    var isTwitterSelected = false
//    var isBarter = false
//    var isPaymentTypeChoosen = false
//    
//    //    MARK: - Views
//    
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    let genderPicker = UIPickerView()
//    let categoryPicker = UIPickerView()
//    let campaignNameTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Your Campaign Name")
//    var dropDown = DropDown()
//    let sponsorshipTypeButon = FButton(backgroundColor: UIColor.secondarySystemBackground, title: "  Choose Payment Type", cornerRadius: 5, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!)
//    let dropDownIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "dropDown")!)
//    let descriptionTextView: UITextView = {
//        let tv = UITextView()
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.font = UIFont.systemFont(ofSize: 18)
//        tv.textColor = UIColor.label
//        tv.backgroundColor = UIColor.systemBackground
//        tv.layer.cornerRadius = 5
//        tv.layer.borderWidth = 1
//        tv.layer.borderColor = UIColor.systemGray3.cgColor
//        tv.layer.masksToBounds = true
//        return tv
//    }()
//    let placeholderLabel = FLabel(backgroundColor: UIColor.clear, text: "Describe your campaign", font: UIFont.systemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.systemGray)
//    let selectImageLabel = FLabel(backgroundColor: UIColor.clear, text: "Please select images for your campaign", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    let selectImageButton = FButton(backgroundColor: UIColor.systemGray6, title: "", cornerRadius: 5, titleColor: UIColor.label, font: UIFont.systemFont(ofSize: 12))
//    var imageCollectionView = FCollectionView()
//    let pricingTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .username, keyboardType: .default, textAlignment: .left, placeholder: "Enter the amount you are offering ($)")
//    let selectPlatformLabel = FLabel(backgroundColor: UIColor.clear, text: "Please select Platforms for sponsorship", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    let instagramButton = FGradientButton(cgColors: [], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
//    let youtubeButton = FGradientButton(cgColors: [], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
//    let facebookButton = FGradientButton(cgColors: [], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
//    let twitterButton = FGradientButton(cgColors: [], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
//    let minFollowersLabel = FLabel(backgroundColor: UIColor.clear, text: "Minimum Followers Required", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    let minFollowersTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter the min followers you are looking for")
//    let genderLabel = FLabel(backgroundColor: UIColor.clear, text: "Please choose your target Gender", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    let genderTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Select Gender")
//    let categoryLabel = FLabel(backgroundColor: UIColor.clear, text: "Please select Category of your Product", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    let categoryTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Select Category")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        categoryData = RemoteConfigManager.getExploreCategoryData(for: "explore_category")[0]
//        configureNavigationBar()
//        setupScrollView()
//        configureViews()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//      tabBarController?.tabBar.isHidden = false
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//      tabBarController?.tabBar.isHidden = false
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        if touch?.view != descriptionTextView{
//            view.endEditing(true)
//        }
//    }
//    
//    //    MARK: - Configure Views
//    
//    
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.label
//        navigationController?.navigationBar.tintColor = UIColor.label
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationItem.title = "Create Campaign"
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
//        let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
//        navigationItem.rightBarButtonItem = rightBarButtonItem
//        
//        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
//        navigationItem.leftBarButtonItem = leftBarButton
//        
//    }
//    
//    
//    @objc private func handleCancel(){
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    private func setupScrollView(){
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        
//        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//    }
//    
//    private func configureViews(){
//        view.backgroundColor = UIColor.systemBackground
//        contentView.backgroundColor = UIColor.systemBackground
//        
//        contentView.addSubview(campaignNameTF)
//        campaignNameTF.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 48, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
//        campaignNameTF.delegate = self
//        descriptionTextView.delegate = self
//        contentView.addSubview(descriptionTextView)
//        descriptionTextView.anchor(top: campaignNameTF.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 200)
//        descriptionTextView.addSubview(placeholderLabel)
//        placeholderLabel.anchor(top: descriptionTextView.topAnchor, left: descriptionTextView.leftAnchor, bottom: nil, right: descriptionTextView.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
//        contentView.addSubview(selectImageLabel)
//        selectImageLabel.anchor(top: descriptionTextView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//        contentView.addSubview(selectImageButton)
//        selectImageButton.anchor(top: selectImageLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
//        selectImageButton.setImage(UIImage(named: "addIcon"), for: .normal)
//        selectImageButton.addTarget(self, action: #selector(handleSelectImages), for: .touchUpInside)
//        configureImageCollectionView()
//        contentView.addSubview(sponsorshipTypeButon)
//        sponsorshipTypeButon.anchor(top: selectImageButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 184, height: 32)
//        sponsorshipTypeButon.layer.borderColor = UIColor.secondaryLabel.cgColor
//        sponsorshipTypeButon.layer.borderWidth = 1
//        sponsorshipTypeButon.contentHorizontalAlignment = .left
//        sponsorshipTypeButon.addTarget(self, action: #selector(handleDropDown), for: .touchUpInside)
//        sponsorshipTypeButon.addSubview(dropDownIV)
//        dropDownIV.anchor(top: sponsorshipTypeButon.topAnchor, left: nil, bottom: sponsorshipTypeButon.bottomAnchor, right: sponsorshipTypeButon.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 0)
//        configureDropDown()
//        contentView.addSubview(pricingTF)
//        pricingTF.anchor(top: sponsorshipTypeButon.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
//        pricingTF.delegate = self
//        contentView.addSubview(selectPlatformLabel)
//        selectPlatformLabel.anchor(top: pricingTF.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//        contentView.addSubview(instagramButton)
//        instagramButton.anchor(top: selectPlatformLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 32)
//        instagramButton.addTarget(self, action: #selector(handleInstagramButton), for: .touchUpInside)
//        contentView.addSubview(youtubeButton)
//        youtubeButton.anchor(top: instagramButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 32)
//        youtubeButton.addTarget(self, action: #selector(handleYoutubeButton), for: .touchUpInside)
//        contentView.addSubview(facebookButton)
//        facebookButton.anchor(top: youtubeButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 32)
//        facebookButton.addTarget(self, action: #selector(handleFacebookButton), for: .touchUpInside)
//        contentView.addSubview(twitterButton)
//        twitterButton.anchor(top: facebookButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 32)
//        twitterButton.addTarget(self, action: #selector(handleTwitterButton), for: .touchUpInside)
//        instagramButton.setTitle("Instagram", for: .normal)
//        youtubeButton.setTitle("Youtube", for: .normal)
//        facebookButton.setTitle("Facebook", for: .normal)
//        twitterButton.setTitle("Twitter", for: .normal)
//        instagramButton.layer.borderColor = UIColor.systemBlue.cgColor
//        instagramButton.layer.borderWidth = 1
//        instagramButton.layer.cornerRadius = 5
//        instagramButton.setTitleColor(UIColor.systemBlue, for: .normal)
//        instagramButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        youtubeButton.layer.borderColor = UIColor.systemBlue.cgColor
//        youtubeButton.layer.borderWidth = 1
//        youtubeButton.layer.cornerRadius = 5
//        youtubeButton.setTitleColor(UIColor.systemBlue, for: .normal)
//        youtubeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        facebookButton.layer.borderColor = UIColor.systemBlue.cgColor
//        facebookButton.layer.borderWidth = 1
//        facebookButton.layer.cornerRadius = 5
//        facebookButton.setTitleColor(UIColor.systemBlue, for: .normal)
//        facebookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        twitterButton.layer.borderColor = UIColor.systemBlue.cgColor
//        twitterButton.layer.borderWidth = 1
//        twitterButton.layer.cornerRadius = 5
//        twitterButton.setTitleColor(UIColor.systemBlue, for: .normal)
//        twitterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        
//        contentView.addSubview(minFollowersLabel)
//        minFollowersLabel.anchor(top: twitterButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//        contentView.addSubview(minFollowersTF)
//        minFollowersTF.anchor(top: minFollowersLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
//        contentView.addSubview(genderLabel)
//        genderLabel.anchor(top: minFollowersTF.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//        minFollowersTF.delegate = self
//        contentView.addSubview(genderTF)
//        genderTF.anchor(top: genderLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
//        genderTF.inputView = genderPicker
//        contentView.addSubview(categoryLabel)
//        categoryLabel.anchor(top: genderTF.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
//        contentView.addSubview(categoryTF)
//        categoryTF.anchor(top: categoryLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 48, paddingRight: 16, width: 0, height: 50)
//        categoryTF.inputView = categoryPicker
//        configurePickerViews()
//        
//    }
//    
//    private func configureImageCollectionView(){
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
//        imageCollectionView.backgroundColor = .clear
//        imageCollectionView.register(UploadPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        imageCollectionView.layer.shadowColor = UIColor.label.cgColor
//        imageCollectionView.layer.shadowOpacity = 1
//        imageCollectionView.layer.shadowOffset = .zero
//        imageCollectionView.layer.shadowRadius = 3
//        imageCollectionView.layer.cornerRadius = 10
//        contentView.addSubview(imageCollectionView)
//        imageCollectionView.anchor(top: selectImageLabel.bottomAnchor, left: selectImageButton.rightAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
//    }
//    
//    private func configurePickerViews(){
//        
//        genderPicker.delegate = self
//        genderPicker.dataSource = self
//        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor.systemBlue
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
//        toolBar.setItems([doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        
//        genderTF.inputAccessoryView = toolBar
//        
//        configureCategoryPicker()
//    }
//    
//    
//    private func configureCategoryPicker(){
//        
//        
//        categoryPicker.delegate = self
//        categoryPicker.dataSource = self
//        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor.systemBlue
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
//        toolBar.setItems([doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        categoryTF.inputAccessoryView = toolBar
//    }
//    
//    private func configureDropDown(){
//        dropDown.anchorView = sponsorshipTypeButon
//        dropDown.dataSource = ["Paid Collaboration", "Barter Collaboration"]
//        
//        dropDown.cellConfiguration = { (index, item) in
//            print(item)
//            return "\(item)" }
//        dropDown.width = 160
//        dropDown.direction = .bottom
//        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! - 10)
//        dropDown.dismissMode = .automatic
//        dropDown.backgroundColor = UIColor.systemBackground
//        dropDown.textColor = UIColor.label
//        dropDown.textFont = UIFont(name: "RoundedMplus1c-Medium", size: 14)!
//        dropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
//        dropDown.selectedTextColor = UIColor.label
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index == 0{
//                isBarter = false
//                isPaymentTypeChoosen = true
//                pricingTF.placeholder = "Enter the amount you are offering ($)"
//            }else{
//                isBarter = true
//                isPaymentTypeChoosen = true
//                pricingTF.placeholder = "Enter the barter description"
//            }
//            sponsorshipTypeButon.setTitle("  \(item)", for: .normal)
//        }
//    }
//    //    MARK: - Handlers
//    
//    @objc private func handleDropDown(){
//        dropDown.show()
//    }
//    
//    @objc private func handleSelectImages(){
//        showPicker()
//    }
//    
//    @objc func donePicker(){
//        genderTF.resignFirstResponder()
//        categoryTF.resignFirstResponder()
//    }
//    
//    @objc func handleInstagramButton(){
//        if !isInstagramButtonSelected{
//            instagramButton.gradientLayer.cornerRadius = 5
//            instagramButton.gradientLayer.backgroundColor = UIColor.systemBlue.cgColor
//            instagramButton.setTitleColor(UIColor.white, for: .normal)
//            selectedPlatforms.append("Instagram")
//            print(selectedPlatforms)
//        }else{
//            instagramButton.gradientLayer.backgroundColor = UIColor.white.cgColor
//            instagramButton.setTitleColor(UIColor.systemBlue, for: .normal)
//            selectedPlatforms = selectedPlatforms.filter { $0 != "Instagram" }
//        }
//        isInstagramButtonSelected = !isInstagramButtonSelected
//    }
//    
//    @objc func handleYoutubeButton(){
//        if !isYoutubeButtonSelected{
//            youtubeButton.gradientLayer.cornerRadius = 5
//            youtubeButton.gradientLayer.backgroundColor = UIColor.systemBlue.cgColor
//            youtubeButton.setTitleColor(UIColor.white, for: .normal)
//            selectedPlatforms.append("Youtube")
//        }else{
//            youtubeButton.gradientLayer.backgroundColor = UIColor.white.cgColor
//            youtubeButton.setTitleColor(UIColor.systemBlue, for: .normal)
//            selectedPlatforms = selectedPlatforms.filter { $0 != "Youtube" }
//        }
//        isYoutubeButtonSelected = !isYoutubeButtonSelected
//    }
//    
//    @objc func handleFacebookButton(){
//        if !isFacebookSelected{
//            facebookButton.gradientLayer.cornerRadius = 5
//            facebookButton.gradientLayer.backgroundColor = UIColor.systemBlue.cgColor
//            facebookButton.setTitleColor(UIColor.white, for: .normal)
//            selectedPlatforms.append("Facebook")
//        }else{
//            facebookButton.gradientLayer.backgroundColor = UIColor.white.cgColor
//            facebookButton.setTitleColor(UIColor.systemBlue, for: .normal)
//            selectedPlatforms = selectedPlatforms.filter { $0 != "Facebook" }
//        }
//        isFacebookSelected = !isFacebookSelected
//    }
//    
//    @objc func handleTwitterButton(){
//        if !isTwitterSelected{
//            twitterButton.gradientLayer.cornerRadius = 5
//            twitterButton.gradientLayer.backgroundColor = UIColor.systemBlue.cgColor
//            twitterButton.setTitleColor(UIColor.white, for: .normal)
//            selectedPlatforms.append("Twitter")
//        }else{
//            twitterButton.gradientLayer.backgroundColor = UIColor.white.cgColor
//            twitterButton.setTitleColor(UIColor.systemBlue, for: .normal)
//            selectedPlatforms = selectedPlatforms.filter { $0 != "Twitter" }
//        }
//        isTwitterSelected = !isTwitterSelected
//    }
//    
//    @objc private func handleNext(){
//        if !campaignNameTF.text!.isEmpty{
//            if !descriptionTextView.text.isEmpty{
//                if !selectedImages.isEmpty{
//                    if !pricingTF.text!.isEmpty{
//                        if !selectedPlatforms.isEmpty{
//                            if !minFollowersTF.text!.isEmpty{
//                                if !genderTF.text!.isEmpty{
//                                    if !categoryTF.text!.isEmpty{
//                                        if isPaymentTypeChoosen{
//                                            guard let campaignName = campaignNameTF.text else {return}
//                                            guard let description = descriptionTextView.text else {return}
//                                            guard let price = pricingTF.text else {return}
//                                            guard let minFollowers = minFollowersTF.text else {return}
//                                            guard let gender = genderTF.text else {return}
//                                            guard let category = categoryTF.text else {return}
//                                            var cmapaignPrice = price
//                                            let detailsVC = DetailsVC()
//                                            let backButton = UIBarButtonItem()
//                                            backButton.title = ""
//                                            navigationItem.backBarButtonItem = backButton
//                                            if isBarter{
//                                                cmapaignPrice = "0"
//                                            }
//                                            detailsVC.sponsorship = Sponsorships(userId: "", price: Int(cmapaignPrice)!, platforms: self.selectedPlatforms, name: campaignName, gender: gender, minFollowers: Int(minFollowers)!, description: description, currency: "$", creationDate: 0, influencers: [String](), categories: [category], campaignId: "", isApproved: false, selectedUsers: [""], blob: [Dictionary<String, String>]())
//                                            detailsVC.isPreview = true
//                                            detailsVC.isBarter = self.isBarter
//                                            detailsVC.selectedImages = selectedImages
//                                            navigationController?.pushViewController(detailsVC, animated: true)
//                                        }else{
//                                            self.toast = SwiftToast(text: "Please choose Payment Type.")
//                                            present(self.toast, animated: true)
//                                        }
//                                    }else{
//                                        self.toast = SwiftToast(text: "Please choose category of your product.")
//                                        present(self.toast, animated: true)
//                                    }
//                                }else{
//                                    self.toast = SwiftToast(text: "Please enter your preferred gender for your product.")
//                                    present(self.toast, animated: true)
//                                }
//                            }else{
//                                self.toast = SwiftToast(text: "Please enter the minimum followers you are expecting.")
//                                present(self.toast, animated: true)
//                            }
//                        }else{
//                            self.toast = SwiftToast(text: "Please select the platforms where you want to post your campaign.")
//                            present(self.toast, animated: true)
//                        }
//                    }else{
//                        self.toast = SwiftToast(text: "Please enter how much you will pay to the influencer.")
//                        present(self.toast, animated: true)
//                    }
//                }else{
//                    self.toast = SwiftToast(text: "Please choose images for your campaign.")
//                    present(self.toast, animated: true)
//                }
//            }else{
//                self.toast = SwiftToast(text: "Please enter your campaign description.")
//                present(self.toast, animated: true)
//            }
//        }else{
//            self.toast = SwiftToast(text: "Please enter your campaign name.")
//            present(self.toast, animated: true)
//        }
//    }
//    
//    @objc func showPicker() {
//        selectedImages.removeAll()
//        var config = YPImagePickerConfiguration()
//        config.library.mediaType = .photo
//        config.shouldSaveNewPicturesToAlbum = false
//        config.startOnScreen = .library
//        config.screens = [.library]
//        config.wordings.libraryTitle = "Gallery"
//        config.hidesStatusBar = true
//        config.hidesBottomBar = true
//        config.library.maxNumberOfItems = 5
//        config.gallery.hidesRemoveButton = false
//        config.library.preselectedItems = selectedItems
//        
//        let picker = YPImagePicker(configuration: config)
//        
//        /* Multiple media implementation */
//        picker.didFinishPicking { [unowned picker] items, cancelled in
//            
//            if cancelled {
//                print("Picker was canceled")
//                picker.dismiss(animated: true, completion: nil)
//                return
//            }
//            _ = items.map { print("🧀 \($0)") }
//            
//            self.selectedItems = items
//            for item in items{
//                switch item {
//                case .photo(p: let photo):
//                    self.selectedImages.append(photo.image)
//                default:
//                    print("Default statement")
//                }
//                picker.dismiss(animated: true) {
//                    self.imageCollectionView.reloadData()
//                }
//            }
//        }
//        
//        //  Configure Picker NavBar
//        picker.navigationBar.barTintColor = UIColor.label
//        picker.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
//        picker.navigationBar.titleTextAttributes = textAttributes
//        picker.navigationBar.tintColor = UIColor.label
//        let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Gallery", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .center, textColor: .label)
//        picker.navigationItem.titleView = titleLabel
//        present(picker, animated: true, completion: nil)
//    }
//}
//
//
//extension CreateCampaignsVC: UIPickerViewDelegate, UIPickerViewDataSource{
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == genderPicker{
//            return genderData.count
//        }else if pickerView == categoryPicker{
//            return categoryData.count
//        } else{
//            return 0
//        }
//    }
//    
//    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == genderPicker{
//            return genderData[row]
//        }else if pickerView == categoryPicker{
//            return categoryData[row]
//        }
//        return ""
//    }
//    
//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == genderPicker{
//            if row != 0{
//                genderTF.text = genderData[row]
//            }
//        }
//        if pickerView == categoryPicker{
//            categoryTF.text = categoryData[row]
//        }
//    }
//    
//}
//
//
//extension CreateCampaignsVC: UITextViewDelegate, UITextFieldDelegate{
//    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.isEmpty{
//            placeholderLabel.isHidden = false
//        }
//        if textView.text.count > 0 {
//            placeholderLabel.isHidden = true
//        }
//        if textView.text.count > 120{
//            textView.font = UIFont.systemFont(ofSize: 16)
//        }
//        if textView.text.count > 240{
//            textView.font = UIFont.systemFont(ofSize: 14)
//        }
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        keyboardWillHide(notification: NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil) )
//        removeKeyboardObservers()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        campaignNameTF.resignFirstResponder()
//        pricingTF.resignFirstResponder()
//        minFollowersTF.resignFirstResponder()
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == pricingTF || textField == minFollowersTF{
//            addKeyboardObservers()
//        }
//        if textField == campaignNameTF || textField == genderTF || textField == categoryTF{
//            keyboardWillHide(notification: NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil) )
//            removeKeyboardObservers()
//        }
//    }
//    
//    private func addKeyboardObservers(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    private func removeKeyboardObservers(){
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
//    
//}
//
//
//
//extension CreateCampaignsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return selectedImages.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UploadPostCollectionViewCell
//        if !selectedImages.isEmpty{
//            cell.imageView.image = selectedImages[indexPath.row]
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //        showResults()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: self.imageCollectionView.bounds.height)
//    }
//    
//}
