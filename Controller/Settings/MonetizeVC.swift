//
//  MonetizeVC.swift
//  Flytant
//
//  Created by Vivek Rai on 08/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import HGCircularSlider
import ChameleonFramework
import Firebase

class MonetizeVC: UIViewController {
    
//    MARK: - Properties
    var likesCount = 0
    var followersCount = 0
//    MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let logoImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "monetizeImage")!)
    let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 22), textAlignment: .center, textColor: .label)
    let subtitleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: .secondaryLabel)
    let descriptionLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: .secondaryLabel)
    let monetizationLabel = FLabel(backgroundColor: UIColor.clear, text: "Enable Monetization", font: UIFont.systemFont(ofSize: 14), textAlignment: .center, textColor: UIColor.secondaryLabel)
    let monetizationSwitch = UISwitch()
    let likesContainerView = UIView()
    let likesLabel = FLabel(backgroundColor: UIColor.clear, text: "Likes", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: .secondaryLabel)
    let followersContainerView = UIView()
    let followersLabel = FLabel(backgroundColor: UIColor.clear, text: "Followers", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: .secondaryLabel)
    let likesProgress = FCircularSlider()
    let followersProgress = FCircularSlider()
    
    let likesCountLabel = FLabel(backgroundColor: UIColor.clear, text: "0 Likes", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
    
    let followersCountLabel = FLabel(backgroundColor: UIColor.clear, text: "0 Followers", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
    
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        configureViews()
        configureContainerViews()
        configureBottomViews()
        fetchTotalLikes()
        fetchTotalFollowers()
        
        checkMonetizationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
        
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Monetize"
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
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
    
    private func configureViews(){
        contentView.addSubview(logoImageView)
        logoImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: logoImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        titleLabel.text = "Grow with Flytant"
        
        contentView.addSubview(monetizationSwitch)
        monetizationSwitch.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 24)
        monetizationSwitch.addTarget(self, action: #selector(monetizationStateChanged), for: .valueChanged)
        monetizationSwitch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        monetizationSwitch.isUserInteractionEnabled = false
        
        contentView.addSubview(monetizationLabel)
        monetizationLabel.anchor(top: monetizationSwitch.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.anchor(top: monetizationLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        subtitleLabel.text = "As a Flytant patner you will be able to earn money from your content, get support and eligible for many more features."
        subtitleLabel.numberOfLines = 0
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: subtitleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        descriptionLabel.text = "To get into the Flytant Partner Programme, your account needs to have atleast 1,000 followers and 10,000 or more cumulative likes. Your account will also be reviewed to ensure that it follows Flytant monetization policies."
        descriptionLabel.numberOfLines = 0
    }
    
    private func configureContainerViews(){
        likesContainerView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        likesContainerView.layer.shadowOpacity = 1
        likesContainerView.layer.shadowOffset = .zero
//        likesContainerView.layer.shadowRadius = 5
        followersContainerView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        followersContainerView.layer.shadowOpacity = 1
        followersContainerView.layer.shadowOffset = .zero
//        followersContainerView.layer.shadowRadius = 5
        
        likesContainerView.backgroundColor = UIColor.secondarySystemBackground
        followersContainerView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(likesContainerView)
        contentView.addSubview(followersContainerView)
        let width = (view.frame.width - 64)/2
    
        likesContainerView.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: width, height: width)
        followersContainerView.anchor(top: descriptionLabel.bottomAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: width, height: width)
        
        likesContainerView.addSubview(likesLabel)
        likesLabel.anchor(top: likesContainerView.topAnchor, left: likesContainerView.leftAnchor, bottom: nil, right: likesContainerView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        followersContainerView.addSubview(followersLabel)
        followersLabel.anchor(top: followersContainerView.topAnchor, left: followersContainerView.leftAnchor, bottom: nil, right: followersContainerView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        
        configureProgressSliders()
        
    }
    
    private func configureBottomViews(){
        contentView.addSubview(likesCountLabel)
        likesCountLabel.anchor(top: likesContainerView.bottomAnchor, left: likesContainerView.leftAnchor, bottom: contentView.bottomAnchor, right: likesContainerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        contentView.addSubview(followersCountLabel)
        followersCountLabel.anchor(top: followersContainerView.bottomAnchor, left: followersContainerView.leftAnchor, bottom: contentView.bottomAnchor, right: followersContainerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
    }
    
    private func configureProgressSliders(){
        likesContainerView.addSubview(likesProgress)
        likesProgress.anchor(top: likesContainerView.topAnchor, left: likesContainerView.leftAnchor, bottom: likesContainerView.bottomAnchor, right: likesContainerView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        likesProgress.maximumValue = 10000
        likesProgress.minimumValue = 0
        likesProgress.trackFillColor = UIColor.flatGreenColorDark()
        likesProgress.diskFillColor = UIColor.flatGreen()
        likesProgress.isUserInteractionEnabled = false
        
        followersContainerView.addSubview(followersProgress)
        followersProgress.anchor(top: followersContainerView.topAnchor, left: followersContainerView.leftAnchor, bottom: followersContainerView.bottomAnchor, right: followersContainerView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        followersProgress.maximumValue = 1000
        followersProgress.minimumValue = 0
        followersProgress.trackFillColor = UIColor.flatGreenColorDark()
        followersProgress.diskFillColor = UIColor.flatGreen()
        followersProgress.isUserInteractionEnabled = false
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
    
    private func fetchTotalLikes(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        showIndicatorView()
        POST_REF.whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let likes = data["likes"] as? Int ?? 0
                self.likesCount += likes
            }
            if self.followersCount >= 1000 && self.likesCount >= 10000{
                self.monetizationSwitch.isUserInteractionEnabled = true
            }
            self.likesCountLabel.text = "\(self.likesCount) Likes"
            self.likesProgress.endPointValue = CGFloat(integerLiteral: self.likesCount)
            self.dismissIndicatorView()
        }
    }
    
    private func fetchTotalFollowers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        showIndicatorView()
        FOLLOWERS_REF.document(currentUserId).getDocument { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            guard let data = snapshot?.data() else {return}
            for (_,j) in data{
                let isFollower = j as? Bool ?? false
                if isFollower{
                    self.followersCount += 1
                }
            }
            if self.followersCount >= 1000 && self.likesCount >= 10000{
                self.monetizationSwitch.isUserInteractionEnabled = true
            }
            self.followersCountLabel.text = "\(self.followersCount) Followers"
            self.followersProgress.endPointValue = CGFloat(integerLiteral: self.followersCount)
            self.dismissIndicatorView()
        }
    }
    
    
//    MARK: - Handlers
    
    @objc private func monetizationStateChanged(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if monetizationSwitch.isOn{
            let value = ["monetizationEnabled": true]
            USER_REF.document(currentUserId).updateData(value)
        }else{
            let value = ["monetizationEnabled": false]
            USER_REF.document(currentUserId).updateData(value)
        }
    }
    
    private func checkMonetizationStatus(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            if user.monetizationEnabled{
                self.monetizationSwitch.setOn(true, animated: true)
            }else{
                self.monetizationSwitch.setOn(false, animated: true)
            }
        }
    }
}
