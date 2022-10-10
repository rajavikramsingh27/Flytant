//
//  ChatProfileVC.swift
//  Flytant
//
//  Created by Vivek Rai on 07/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatProfileVC: UIViewController {
    
//    MARK: - Properties
    var userId: String?
    var isBlocked = false
    var blockedUsers = [String]()
    
//    MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 40, image: UIImage(named: "emptyProfileIcon")!)
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 20), textAlignment: .center, textColor: UIColor.label)
    let phoneNumberLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
    
    let callView = UIView()
    let messageView = UIView()
    let blockView = UIView()
    let profileView = UIView()
    
    let callImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "callChatProfile")!)
    let messageImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "messageChatProfile")!)
    let mainProfileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "profileChatProfile")!)
    let blockImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "blockChatProfile")!)
    
    let mainProfileButton = FButton(backgroundColor: UIColor.clear, title: "Profile", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let callButton = FButton(backgroundColor: UIColor.clear, title: "Call", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let messageButton = FButton(backgroundColor: UIColor.clear, title: "Message", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 18))
    let blockButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.systemRed, font: UIFont.boldSystemFont(ofSize: 18))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        
        setupScrollView()
        configureViews()
        setUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - ConfigureViews
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Chat Profile"
        
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
        
        contentView.addSubview(profileView)
        profileView.anchor(top: phoneNumberLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        profileView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(callView)
        callView.anchor(top: profileView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        callView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(messageView)
        messageView.anchor(top: callView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        messageView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(blockView)
        blockView.anchor(top: messageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        blockView.backgroundColor = UIColor.secondarySystemBackground
        
        contentView.addSubview(mainProfileImageView)
        mainProfileImageView.anchor(top: nil, left: profileView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(callImageView)
        callImageView.anchor(top: nil, left: callView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(messageImageView)
        messageImageView.anchor(top: nil, left: messageView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(blockImageView)
        blockImageView.anchor(top: nil, left: blockView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        contentView.addSubview(mainProfileButton)
        mainProfileButton.anchor(top: profileView.topAnchor, left: mainProfileImageView.rightAnchor, bottom: profileView.bottomAnchor, right: profileView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        mainProfileButton.addTarget(self, action: #selector(handleMainProfile), for: .touchUpInside)
        mainProfileButton.contentHorizontalAlignment = .left
        
        contentView.addSubview(callButton)
        callButton.anchor(top: callView.topAnchor, left: callImageView.rightAnchor, bottom: callView.bottomAnchor, right: callView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        callButton.contentHorizontalAlignment = .left
        callButton.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        
        contentView.addSubview(messageButton)
        messageButton.anchor(top: messageView.topAnchor, left: messageImageView.rightAnchor, bottom: messageView.bottomAnchor, right: messageView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        messageButton.contentHorizontalAlignment = .left
        messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        
        contentView.addSubview(blockButton)
        blockButton.anchor(top: blockView.topAnchor, left: blockImageView.rightAnchor, bottom: blockView.bottomAnchor, right: blockView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        blockButton.contentHorizontalAlignment = .left
         blockButton.addTarget(self, action: #selector(handleBlock), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mainProfileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            callImageView.centerYAnchor.constraint(equalTo: callView.centerYAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            blockImageView.centerYAnchor.constraint(equalTo: blockView.centerYAnchor),
        ])
        
    }

//    MARK: - Handlers
    
    @objc private func handleMainProfile(){
        guard let userId = self.userId else {return}
        DataService.instance.fetchUserWithUserId(with: userId) { (user) in
            let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            socialProfileVC.user = user
            socialProfileVC.changeHeader = true
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(socialProfileVC, animated: true)
        }
    }
    
    @objc private func handleCall(){
        guard let userId = self.userId else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let currentUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            let call = ChatCalls(callerId: currentUserId, callerName: currentUsername, withUserName: user.username, withUserId: userId)
            call.saveCall()
            self.callUser()
        }
    }
    
    @objc private func handleBlock(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = self.userId else {return}
        if isBlocked{
            blockButton.setTitle("Block", for: .normal)
            blockImageView.image = UIImage(named: "blockChatProfile")
            blockedUsers = blockedUsers.filter(){$0 != userId}
            let value = ["blockedUsers": blockedUsers]
            USER_REF.document(currentUserId).updateData(value)
        }else{
            blockButton.setTitle("Unblock", for: .normal)
            blockImageView.image = UIImage(named: "unblockChatProfile")
            blockedUsers.append(userId)
            debugPrint(blockedUsers)
            let value = ["blockedUsers": blockedUsers]
            USER_REF.document(currentUserId).updateData(value)
        }
        isBlocked = !isBlocked
    }
    
    @objc private func handleMessage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUserInfo(){
        guard let userId = self.userId else {return}
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            self.profileImageView.loadImage(with: user.profileImageURL)
            self.nameLabel.text = user.username
            //  self.phoneNumberLabel.text = user.phoneNumber
        }
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            guard let blockedUsers = user.blockedUsers else {return}
            self.blockedUsers = blockedUsers
            if blockedUsers.contains(userId){
                self.blockButton.setTitle("Unblock", for: .normal)
                self.blockImageView.image = UIImage(named: "unblockChatProfile")
                self.isBlocked = true
            }else{
                self.blockButton.setTitle("Block", for: .normal)
                self.blockImageView.image = UIImage(named: "blockChatProfile")
                self.isBlocked = false
            }
        }
    }
    
//    MARK: - Call User
    
    private func callClient() -> SINCallClient?{
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
        return sceneDelegate.client.call()
    }
    
    private func callUser(){
        guard let userId = self.userId else {return}
        let call = callClient()?.callUser(withId: userId)
        let callVC = CallVC()
        callVC.call = call
        let navController = UINavigationController(rootViewController: callVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
}
