//
//  PreviewVC.swift
//  Flytant
//
//  Created by Vivek Rai on 10/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow
import ActiveLabel

class PreviewVC: UIViewController {
    
//    MARK: - Properties
    var selectedImages = [UIImage]()
    var sliderImages = [InputSource]()
    var postDescription = ""
    
//    MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
//    let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "navBarImage")!)
    
    let doneButton = FButton(backgroundColor: UIColor.clear, title: "Done", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
    
    private let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Preview", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .center, textColor: UIColor.white)
    
    let imageSlideshow = FImageSlideShow(backgroundColor: UIColor.clear)
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage(named:"emptyProfileIcon")!)
       
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "username", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
       
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "1 sec ago", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
       
    lazy var threeDotButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
       
    lazy var likesButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))

    lazy var commentsButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
       
    lazy var likesLabel = FLabel(backgroundColor: UIColor.clear, text: "0 likes", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: .label)
       
    lazy var descriptionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        contentView.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        
//        configureTopViews()
        configureViews()
        setPreviewData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
    }
//    MARK: - ConfigureViews
    
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
//    private func configureTopViews(){
//        contentView.addSubview(topImageView)
//        topImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
//        topImageView.contentMode = .scaleAspectFill
//        topImageView.isUserInteractionEnabled = true
//
//        topImageView.addSubview(doneButton)
//        doneButton.anchor(top: topImageView.topAnchor, left: nil, bottom: nil, right: topImageView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 30)
//        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
//
//        topImageView.addSubview(titleLabel)
//        titleLabel.anchor(top: topImageView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 30)
//        titleLabel.centerXAnchor.constraint(equalTo: topImageView.centerXAnchor).isActive = true
//    }
//
    private func configureViews(){
        contentView.addSubview(profileImageView)
        profileImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        contentView.addSubview(usernameLabel)
        usernameLabel.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        contentView.addSubview(timeLabel)
        timeLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.minimumScaleFactor = 1
        
        contentView.addSubview(imageSlideshow)
        imageSlideshow.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        contentView.addSubview(likesButton)
        likesButton.anchor(top: imageSlideshow.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        likesButton.setImage(UIImage(named: "dislike"), for: .normal)
        contentView.addSubview(commentsButton)
        commentsButton.anchor(top: imageSlideshow.bottomAnchor, left: likesButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        commentsButton.setImage(UIImage(named: "comment"), for: .normal)
        contentView.addSubview(likesLabel)
        likesLabel.anchor(top: likesButton.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        contentView.addSubview(threeDotButton)
        threeDotButton.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 30, height: 30)
        threeDotButton.setImage(UIImage(named: "horizontalThreeDot"), for: .normal)
        
    
    }

    
//    MARK: - Handlers
    
    @objc func handleDone(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setPreviewData(){
        let username = UserDefaults.standard.string(forKey: USERNAME) ?? "username"
        let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) ?? DEFAULT_PROFILE_IMAGE_URL
        usernameLabel.text = username
        profileImageView.loadImage(with: profileImageUrl)
        selectedImages.forEach { (image) in
            sliderImages.append(ImageSource(image: image))
        }
        imageSlideshow.setImageInputs(sliderImages)
        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        descriptionLabel.enabledTypes = [.mention, .hashtag, customType]
        descriptionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
                case .custom:
                    atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
                default: ()
            }
            return atts
        }
               
        descriptionLabel.customize { (label) in
            label.text = "\(postDescription)"
            label.customColor[customType] = .label
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .label
            label.hashtagColor = .systemPurple
            label.mentionColor = .systemPurple
        }
        
    }
}
