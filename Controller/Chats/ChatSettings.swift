//
//  ChatSettings.swift
//  Flytant
//
//  Created by Vivek Rai on 17/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class ChatSettings: UIViewController {
    
//    MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
//    MARK: - Views
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 40, image: UIImage(named: "avatarPlaceholder")!)
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 20), textAlignment: .center, textColor: UIColor.label)
    let phoneNumberLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
   
    let chatBackgroundView = UIView()
    let clearCacheView = UIView()
    let blockedUsersVies = UIView()
    let termsView = UIView()
    
   
    let clearCacheImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chatSettingsClearCache")!)
    let blockedUsersImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chatSettingsBlockedUsers")!)
    let chatBackgroundImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chatSettingsChatBackground")!)
    let termsImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "chatSettingsTerms")!)
   
    let chatbackgroundButton = FButton(backgroundColor: UIColor.clear, title: "Chat Backgrounds", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let clearCacheButton = FButton(backgroundColor: UIColor.clear, title: "Clear Cache", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let blockedUsersButton = FButton(backgroundColor: UIColor.clear, title: "Blocked Users", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let termsButton = FButton(backgroundColor: UIColor.clear, title: "Terms & Conditions", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        configureViews()
        setUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Chat Settings"
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
        contentView.addSubview(profileImageView)
        profileImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 24)
        
        contentView.addSubview(phoneNumberLabel)
        phoneNumberLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        
        contentView.addSubview(chatBackgroundView)
        chatBackgroundView.anchor(top: phoneNumberLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        chatBackgroundView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(clearCacheView)
        clearCacheView.anchor(top: chatBackgroundView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        clearCacheView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(blockedUsersVies)
        blockedUsersVies.anchor(top: clearCacheView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        blockedUsersVies.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(termsView)
        termsView.anchor(top: blockedUsersVies.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        termsView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(chatBackgroundImageView)
        chatBackgroundImageView.anchor(top: nil, left: chatBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(clearCacheImageView)
        clearCacheImageView.anchor(top: nil, left: clearCacheView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(blockedUsersImageView)
        blockedUsersImageView.anchor(top: nil, left: blockedUsersVies.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(termsImageView)
        termsImageView.anchor(top: nil, left: termsView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(chatbackgroundButton)
        chatbackgroundButton.anchor(top: chatBackgroundView.topAnchor, left: chatBackgroundImageView.rightAnchor, bottom: chatBackgroundView.bottomAnchor, right: chatBackgroundView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        chatbackgroundButton.addTarget(self, action: #selector(handleChatBackground), for: .touchUpInside)
        chatbackgroundButton.contentHorizontalAlignment = .left
        
        contentView.addSubview(clearCacheButton)
        clearCacheButton.anchor(top: clearCacheView.topAnchor, left: clearCacheImageView.rightAnchor, bottom: clearCacheView.bottomAnchor, right: clearCacheView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        clearCacheButton.contentHorizontalAlignment = .left
        clearCacheButton.addTarget(self, action: #selector(handleClearCache), for: .touchUpInside)
        
        contentView.addSubview(blockedUsersButton)
        blockedUsersButton.anchor(top: blockedUsersVies.topAnchor, left: blockedUsersImageView.rightAnchor, bottom: blockedUsersVies.bottomAnchor, right: blockedUsersVies.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        blockedUsersButton.contentHorizontalAlignment = .left
        blockedUsersButton.addTarget(self, action: #selector(handleBlockedUsers), for: .touchUpInside)
        
        contentView.addSubview(termsButton)
        termsButton.anchor(top: termsView.topAnchor, left: termsImageView.rightAnchor, bottom: termsView.bottomAnchor, right: termsView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        termsButton.contentHorizontalAlignment = .left
         termsButton.addTarget(self, action: #selector(handleTerms), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            chatBackgroundImageView.centerYAnchor.constraint(equalTo: chatBackgroundView.centerYAnchor),
            clearCacheImageView.centerYAnchor.constraint(equalTo: clearCacheView.centerYAnchor),
            blockedUsersImageView.centerYAnchor.constraint(equalTo: blockedUsersVies.centerYAnchor),
            termsImageView.centerYAnchor.constraint(equalTo: termsView.centerYAnchor),
        ])
    }
    
    private func setUserInfo(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            self.profileImageView.loadImage(with: user.profileImageURL)
            self.nameLabel.text = user.username
            self.phoneNumberLabel.text = user.phoneNumber
        }
    }
    
    
//    MARK: - Handlers
    
    @objc private func handleChatBackground(){
        let chatBackgroundVC = ChatBackgroundVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(chatBackgroundVC, animated: true)
    }
    
    @objc private func handleClearCache(){
        do{
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsURL().path)
            for file in files{
                try FileManager.default.removeItem(atPath: "\(getDocumentsURL().path)/\(file)")
            }
            ProgressHUD.showSuccess("Successfully cleaned cache.")
        }catch{
            ProgressHUD.showError("Couldn't clean Media files")
        }
    }
    
    @objc private func handleBlockedUsers(){
        let blockedUsersVC = BlockedUsersVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(blockedUsersVC, animated: true)
    }
    
    @objc private func handleTerms(){
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://flytant.com/terms/"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
}
