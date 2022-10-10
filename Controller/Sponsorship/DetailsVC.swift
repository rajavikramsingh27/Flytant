

//  DetailsVC.swift
//  Flytant
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.


import UIKit
import Firebase
import SwiftToast
import ImageSlideshow

var strCampaignName = ""
var strCampaignDescription = ""
var strCampaignGiveAwayPay = ""
var strCampaignPlateform = ""
var strCampaignMinFollowers = ""
var strCampaignGender = ""
var strCampaignCategory = ""


private let categoreiesReuseIdentifier = "categoreiesReuseIdentifier"


class DetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var navBar: UIView!

//    MARK: - Properties
    var index = 0
    var toast = SwiftToast()
    var isPreview = false
    var isBarter = false
    var selectedImages = [UIImage]()
    var blob = [[String: String]]()
    var sliderImages = [InputSource]()
    var sponsorshipData = [String: Any]()
    
//    MARK: - Views
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageSlideShow = FImageSlideShow(backgroundColor: UIColor.lightGray)
    let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.label)
    let dateLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
        
    let priceLabel = FLabel(
        backgroundColor: UIColor.clear,
        text: "",
        font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!,
        textAlignment: .left,
        textColor: UIColor.label
    )
    
    let descriptionLabel = FLabel(backgroundColor: UIColor.clear, text: "Description", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.systemGray)
    let descriptionTextLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let categoriesLabel = FLabel(backgroundColor: UIColor.clear, text: "Categories", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.systemGray)
    var categoriesCollectionView = FCollectionView()
    let genderLabel = FLabel(backgroundColor: UIColor.clear, text: "Preferred Gender", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.systemGray)
    let genderTextLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let followersLabel = FLabel(backgroundColor: UIColor.clear, text: "Min Followers", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.systemGray)
    let followersTextLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 14)!, textAlignment: .left, textColor: UIColor.label)
    let platformsLabel = FLabel(backgroundColor: UIColor.clear, text: "Platforms", font: UIFont(name: "RoundedMplus1c-Bold", size: 16)!, textAlignment: .left, textColor: UIColor.systemGray)
    var platformsCollectionView = FCollectionView()
    
//    let applyButton = FGradientButton(cgColors:[UIColor.secondarySystemBackground.cgColor, UIColor.secondarySystemBackground.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    
    let applyButton = UIButton()
    
    var arrCategory = [String]()
    var arrPlateform = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        setupScrollView()
        configureViews()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar() {
        let screenSize = UIScreen.main.bounds
        
        let viewUpperNav: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(viewUpperNav)
        
        NSLayoutConstraint.activate([
            viewUpperNav.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            viewUpperNav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            viewUpperNav.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            viewUpperNav.heightAnchor.constraint(equalToConstant: CGFloat(sageAreaHeight()))
        ])
        
        
        navBar = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTitle = UILabel()
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelTitle.text = "Create Campaign"
            labelTitle.textColor =  .label
            labelTitle.font = UIFont (name: kFontBold, size: 20)

            view.addSubview(labelTitle)
            
            NSLayoutConstraint.activate([
                labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                labelTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
            
            let btnBack: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .systemBackground
                button.setImage(UIImage (named: "back_subscription"), for: .normal)
                button.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)

                return button
            }()

            view.addSubview(btnBack)

            NSLayoutConstraint.activate([
                btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                btnBack.widthAnchor.constraint(equalToConstant: 44),
                btnBack.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            return view
        }()
        
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: viewUpperNav.leftAnchor, constant: 0),
            navBar.topAnchor.constraint(equalTo: viewUpperNav.bottomAnchor, constant: 0),
            navBar.widthAnchor.constraint(equalToConstant: screenSize.width),
            navBar.heightAnchor.constraint(equalToConstant: CGFloat(44)),
        ])
    }
    
    private func configureApplyButton() {
        view.addSubview(applyButton)
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        applyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        NSLayoutConstraint.activate([
            applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            applyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        applyButton.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        
        applyButton.titleLabel?.font = UIFont (name: kFontBold, size: 16)
        applyButton.setTitleColor(.systemBackground, for: .normal)
        applyButton.backgroundColor = .label
        applyButton.setTitle("Apply", for: .normal)
    }
    
    private func setupScrollView() {
        configureApplyButton()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: applyButton.topAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func showIndicatorView() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
    
    
    private func configureViews(){
        view.backgroundColor = UIColor.systemBackground
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(imageSlideShow)
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: imageSlideShow.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        contentView.addSubview(dateLabel)
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 16)
        contentView.addSubview(priceLabel)
        
        priceLabel.anchor(
            top: dateLabel.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: nil,
            paddingTop: 8,
            paddingLeft: 12,
            paddingBottom: 0,
            paddingRight: 0,
            width: 0,
            height: 30
        )
        
        priceLabel.textAlignment = .center
        priceLabel.layer.borderWidth = 1
        priceLabel.layer.borderColor = UIColor.label.cgColor
        priceLabel.layer.cornerRadius = 3
        priceLabel.clipsToBounds = true
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: priceLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        contentView.addSubview(descriptionTextLabel)
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        contentView.addSubview(categoriesLabel)
        categoriesLabel.anchor(top: descriptionTextLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 20)
        configureCategoriesCollectionView()
        contentView.addSubview(genderLabel)
        genderLabel.anchor(top: categoriesCollectionView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        contentView.addSubview(genderTextLabel)
        genderTextLabel.anchor(top: genderLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 16)
        contentView.addSubview(followersLabel)
        followersLabel.anchor(top: genderTextLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        contentView.addSubview(followersTextLabel)
        followersTextLabel.anchor(top: followersLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 16)
        contentView.addSubview(platformsLabel)
        platformsLabel.anchor(top: followersTextLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 12, width: 0, height: 20)
        configurePlatformsCollectionView()
    }
    
    private func configureCategoriesCollectionView(){
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoreiesReuseIdentifier")
        contentView.addSubview(categoriesCollectionView)
        
        
        
        categoriesCollectionView.anchor(top: categoriesLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
    }
    
    private func configurePlatformsCollectionView(){
        platformsCollectionView.delegate = self
        platformsCollectionView.dataSource = self
        platformsCollectionView.backgroundColor = .clear
        platformsCollectionView.register(PlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "platformsCollectionView")
        platformsCollectionView.backgroundColor = UIColor.clear
        contentView.addSubview(platformsCollectionView)
        platformsCollectionView.anchor(top: platformsLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 40)
    }

    
    
//    MARK: - Handlers
    
    @objc private func didTap(){
        imageSlideShow.presentFullScreenController(from: self)
    }
    
    @objc private func handleApply() {
        
        if isPreview{
            self.uploadCampaign(forIndex: self.index)
        } else {

        }
    }
    
    @IBAction func btnBack (_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func uploadCampaign(forIndex index: Int) {
        let loader = showLoader()
        PresenterCreateCampaign.arrImages = selectedImages
        PresenterCreateCampaign.createCampaign { (error) in
            DispatchQueue.main.async {
                loader.removeFromSuperview()
                if error == nil {
                    self.showAlert(msg: error.localizedDescription)
                } else {
                    self.showToast("Your campaign is in review.")
                    arrImagesCampaign.removeAll()
                    arrSelectedCategoryStore.removeAll()
                    
                    let viewController = self.navigationController?.viewControllers.first { $0 is MainTabVC }
                    guard let destinationVC = viewController else { return }
                    self.navigationController?.popToViewController(destinationVC, animated: true)
                }
            }
        }
    }
    
    private func uploadImages(userDataUploadComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        self.showIndicatorView()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
                
        let storagePostName = NSUUID().uuidString
        guard let uploadData = self.selectedImages[index].jpegData(compressionQuality: 0.4) else { return }
        let filename = NSUUID().uuidString
        STORAGE_REF_CAMPAIGN_IMAGES.child(storagePostName).child(currentUserId+filename).putData(uploadData, metadata: nil) { (metaData, error) in

            if let error = error{
                self.dismissIndicatorView()
                self.toast = SwiftToast(text: "An error occured while uploading, Error description: \n\(error.localizedDescription)")
                self.present(self.toast, animated: true)
                userDataUploadComplete(false, error)
                return
            }
            STORAGE_REF_CAMPAIGN_IMAGES.child(storagePostName).child(currentUserId+filename).downloadURL { (url, error) in
                if let error = error{
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "An error occured while uploading, Error description: \n\(error.localizedDescription)")
                    self.present(self.toast, animated: true)
                    userDataUploadComplete(false, error)
                    return
                }
                guard let imageUrl = url?.absoluteString else {return}
                let imageDict = ["path": imageUrl, "type": "image"]
                self.blob.append(imageDict)
                self.sponsorshipData["blob"] = self.blob
                self.dismissIndicatorView()
                userDataUploadComplete(true, nil)
            }
        }
    }
    
//    MARK: - Set Data
    private func setData() {
        imageSlideShow.setImageInputs(sliderImages)
        
        selectedImages.forEach { (image) in
            sliderImages.append(ImageSource(image: image))
        }
        imageSlideShow.setImageInputs(sliderImages)
        
        titleLabel.text = strCampaignName
        dateLabel.text = "Posted: " + "Now"
        priceLabel.text = strCampaignGiveAwayPay
        
        NSLayoutConstraint.activate([
            priceLabel.widthAnchor.constraint(equalToConstant: priceLabel.text!.textSize(UIFont (name: kFontMedium, size: 14)!).width+20)
        ])
        
        descriptionTextLabel.text = strCampaignDescription
        genderTextLabel.text = strCampaignGender
        followersTextLabel.text = strCampaignMinFollowers
        
        applyButton.setTitle("Post Campaign", for: .normal)
        
        arrCategory = strCampaignCategory.components(separatedBy: ",")
        arrPlateform = strCampaignPlateform.components(separatedBy: ",")
        
        categoriesCollectionView.reloadData()
        platformsCollectionView.reloadData()
    }
    
//    MARK: - CollectionView Dlelegate and Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView{
            return arrCategory.count
        }
        if collectionView == platformsCollectionView{
            return arrPlateform.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoreiesReuseIdentifier", for: indexPath) as! CategoriesCollectionViewCell
            
            cell.categoryButton.setTitle(arrCategory[indexPath.row], for: .normal)
            cell.categoryButton.layer.cornerRadius = 16
            cell.categoryButton.clipsToBounds = true
            
            return cell
        }
        
        if collectionView == platformsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "platformsCollectionView", for: indexPath) as! PlatformsCollectionViewCell
            if arrPlateform[indexPath.row].lowercased() == "Youtube".lowercased() {
                cell.iconIV.image = UIImage(named: "youtubeicon")
            } else if arrPlateform[indexPath.row].lowercased() == "Instagram".lowercased() {
                cell.iconIV.image = UIImage(named: "instagramicon")
            } else if arrPlateform[indexPath.row].lowercased() == "Facebook".lowercased() {
                cell.iconIV.image = UIImage(named: "facebookicon")
            } else if arrPlateform[indexPath.row].lowercased() == "Twitter".lowercased() {
                cell.iconIV.image = UIImage(named: "twittericon")
            } else {
                cell.iconIV.image = UIImage(named: "linkedin")
            }
            
            cell.lblPlateformName.text = arrPlateform[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
//            return CGSize (width: 100, height: 36)
//            let text = NSAttributedString(string: arrCategory[indexPath.row])
//            return CGSize(width: text.size().width + 36, height: categoriesCollectionView.bounds.height)
            
            return CGSize(
                width: arrCategory[indexPath.row].textSize(UIFont (name: kFontMedium, size: 14)!).width+40,
                height: categoriesCollectionView.bounds.height
            )
            
        }
        
        if collectionView == platformsCollectionView {
//            return CGSize(width: 54, height: platformsCollectionView.bounds.height)
//            let text = NSAttributedString(string: arrPlateform[indexPath.row])
//            return CGSize(width: text.size().width, height: platformsCollectionView.bounds.height)
            
            return CGSize(
                width: arrPlateform[indexPath.row].textSize(UIFont (name: kFontMedium, size: 14)!).width,
                height: platformsCollectionView.bounds.height
            )
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoriesCollectionView {
            return 10
        } else if collectionView == platformsCollectionView {
            return 4
        }  else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoriesCollectionView {
            return 10
        }  else if collectionView == platformsCollectionView {
            return 4
        }  else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoriesCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
}
