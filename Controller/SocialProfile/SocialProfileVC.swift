//
//  SocialProfileVC.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import MapKit
import Alamofire
import GoogleSignIn
import SwiftyJSON
import SwiftToast

private let reuseIdentifier = "influencersCollectionViewCell"
private let youtubeReuseIdentifier = "youtubeReuseIdentifier"
private let headerIdentifier = "influencersHeader"

class SocialProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, SocialProfileHeaderDelegate, GIDSignInDelegate {
   
//    MARK: - Properties
    var user: Users?
    var toast = SwiftToast()
    var changeHeader = false
    var instagramPosts = [InstagramPosts]()
    var youtubeData = [YoutubeData]()
    var selectedAccount = "Instagram"
    var currentUser: Users?
    var linkedAccounts = Dictionary<String, Any>()
    
//    MARK: - Views
    let navigationTitleView = FLabel(backgroundColor: UIColor.clear, text: "Social Profile", font: UIFont(name: "RoundedMplus1c-Bold", size: 24)!, textAlignment: .left, textColor: UIColor.label)
    
    let socialAccountButton = FButton(backgroundColor: UIColor.systemGray4, title: "", cornerRadius: 32, titleColor: UIColor.systemBackground, font: UIFont.systemFont(ofSize: 12))
    
    let accountLinkLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Medium", size: 16)!, textAlignment: .center, textColor: UIColor.label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        fetchCurrentUser { (user) in
            self.currentUser = user
            self.fetchUserInstagramData()
        }
        
        configureNavigationBar()
        configureCollectionView()
        configureRefreshControl()
        configureSocialAccountButton()
        configureGoogleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationTitleView.removeFromSuperview()
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        if changeHeader{
            navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            navigationTitleView.textAlignment = .center
        }else{
            navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        }
       
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if let user = self.user {
            if currentUserId == user.userID{
                let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .done, target: self, action: #selector(handleSettings))
                navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }else{
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .done, target: self, action: #selector(handleSettings))
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
    }
    
    private func configureGoogleSignIn(){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = "832016968104-5no1q3gneq241vt9i68kkct0p36v0kq2.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let scope: NSString = "https://www.googleapis.com/auth/youtube.readonly"
        let currentScopes: NSArray = GIDSignIn.sharedInstance().scopes! as NSArray
        GIDSignIn.sharedInstance().scopes = currentScopes.adding(scope)
    }
    
    private func configureCollectionView(){
        self.collectionView.register(SocialProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.register(InstagramProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func configureSocialAccountButton(){
        collectionView.addSubview(socialAccountButton)
        socialAccountButton.anchor(top: collectionView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 316, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 64, height: 64)
        socialAccountButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        socialAccountButton.setImage(UIImage(named: "youtubeicon"), for: .normal)
        socialAccountButton.addTarget(self, action: #selector(handleSocialAccountButton), for: .touchUpInside)
        collectionView.addSubview(accountLinkLabel)
        accountLinkLabel.anchor(top: socialAccountButton.bottomAnchor, left: socialAccountButton.leftAnchor, bottom: nil, right: socialAccountButton.rightAnchor, paddingTop: 8, paddingLeft: -80, paddingBottom: 0, paddingRight: -80, width: 0, height: 20)
        accountLinkLabel.text = "Tap on Icon to link Account"
        socialAccountButton.isHidden = true
        accountLinkLabel.isHidden = true
    }
    

    
//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedAccount == "Instagram"{
            let width = (view.frame.width)
            return CGSize(width: width, height: width + 120)
        }else{
            let width = (view.frame.width - 2) / 2
            return CGSize(width: width, height: 120)
        }
        
    }
    
    

//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedAccount == "Instagram"{
            return instagramPosts.count
        }else{
            return youtubeData.count
        }
       
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SocialProfileHeader
        header.delegate = self
        setUserData(header: header)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 264)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedAccount == "Instagram"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InstagramProfileCollectionViewCell
            cell.profileIV.loadImage(with: self.instagramPosts[indexPath.row].profileImageUrl)
            cell.usernameLabel.text = self.instagramPosts[indexPath.row].username
            cell.timeLabel.text = "\(Date(timeIntervalSince1970: self.instagramPosts[indexPath.row].creationDate).timeAgoToDisplay())"
            cell.postIV.loadImage(with: self.instagramPosts[indexPath.row].postImageUrl)
            cell.likesLabel.text = "\(self.instagramPosts[indexPath.row].likes ?? 12) likes"
            cell.commentsLabel.text = "\(self.instagramPosts[indexPath.row].comments ?? 3) comments"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: youtubeReuseIdentifier, for: indexPath) as! YoutubeProfileCollectionViewCell
            cell.postIV.sd_setImage(with: URL(string: youtubeData[indexPath.row].thumbnail), placeholderImage: UIImage(named: ""))
            cell.titleLabel.text = youtubeData[indexPath.row].title
            return cell
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
//    MARK: - Google SignIn Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error{
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        debugPrint(credential.provider)
        debugPrint(authentication.accessToken)
        debugPrint(authentication.clientID)
//        getYoutubeData(url: "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&access_token="+authentication.accessToken!)
        let url = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&access_token="+authentication.accessToken!
        YoutubeManager.instance.getChannelId(url: url) { (channelId) in
            print(channelId)
            if channelId == "null"{
                self.toast = SwiftToast(text: "Invalid account. Unable to fetch Youtube Details!")
                self.present(self.toast, animated: true)
            }else{
                UserDefaults.standard.set(channelId, forKey: YOUTUBE_ID)
                
                let instagram = self.linkedAccounts["Instagram"]
                let twitter = self.linkedAccounts["Twitter"]
                var socialAccounts = ["linkedAccounts": ["Instagram": instagram, "Twitter": twitter, "Youtube": ["channelId": channelId]]]
                if instagram == nil{
                    socialAccounts = ["linkedAccounts": ["Twitter": twitter, "Youtube": ["channelId": channelId]]]
                }
                if twitter == nil{
                    socialAccounts = ["linkedAccounts": ["Instagram": instagram, "Youtube": ["channelId": channelId]]]
                }
                if instagram == nil && twitter == nil{
                    socialAccounts = ["linkedAccounts": ["Youtube": ["channelId": channelId]]]
                }
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                USER_REF.document(currentUserId).updateData(socialAccounts) { (error) in
                    if let  _ = error{
                        return
                    }
                    self.getYoutubeChannelStats(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(channelId)&part=id%2Csnippet&order=date&type=video&maxResults=20")
                    self.collectionView.reloadData()
                    print("Successfully updated")
                    self.linkedAccounts = socialAccounts
                }
            }
        }
    }
    

//    MARK: - Handlers
    
    @objc private func linkInstagram(){
           let alert = UIAlertController(title: "Instagram", message: nil, preferredStyle: .alert)
           alert.addTextField { (textField) in
               textField.text = ""
               textField.placeholder = "Enter your instagram username"
           }
           alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
           }))
           alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
               let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
               print("Text field: \(textField?.text ?? "")")
               if let instaUsername = textField?.text{
                   if !instaUsername.isEmpty{
                       print(instaUsername)
                       self.fetchInstagramDetails(instaUsername: instaUsername)
                   }else{
                       print("Unable to fetch")
                   }
               }else{
                   print("Unable to fetch")
               }
   
           }))
           self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func linkYoutube(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func handleSettings(){
        let settingsVC = SettingsVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func handleRefresh(){
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func handleSocialAccountButton(){
        
    }
    
    func handleYoutubeButtonTapped(for header: SocialProfileHeader) {
            
    }
    
    func handleInstagram(for header: SocialProfileHeader) {
        selectedAccount = "Instagram"
        self.collectionView.register(InstagramProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchUserInstagramData()
    }
    
    func handleYoutube(for header: SocialProfileHeader) {
        selectedAccount = "Youtube"
        self.collectionView.register(YoutubeProfileCollectionViewCell.self, forCellWithReuseIdentifier: youtubeReuseIdentifier)
        fetchUserYoutubeData()
//        if let _ = self.user{
//
//        }else{
//            self.fetchCurrentUser { (user) in
//                let youtube = user.linkedAccounts["Youtube"]
//                if youtube == nil{
//                    self.socialAccountButton.isHidden = false
//                    self.socialAccountButton.setImage(UIImage(named: "youtubeicon"), for: .normal)
//                    self.accountLinkLabel.isHidden = false
//                    self.accountLinkLabel.text = "No Account linked"
//
//
//                    print("Current User Youtube")
//                    self.socialAccountButton.removeTarget(self, action: #selector(self.linkInstagram), for: .touchUpInside)
//                    self.socialAccountButton.addTarget(self, action: #selector(self.linkYoutube), for: .touchUpInside)
//
//                }else{
//                    self.socialAccountButton.isHidden = true
//                    self.accountLinkLabel.isHidden = true
//                }
//            }
//
//        }
    }
    
    func handleWebsiteTapped(for header: SocialProfileHeader) {
        
    }
    
    func handleFollowersTapped(for header: SocialProfileHeader) {
        
    }
    
    func handleFollowingTapped(for header: SocialProfileHeader) {
        
    }
    
    func handleEditProfileMessageButton(for header: SocialProfileHeader) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if let user = self.user{
            if currentUserId == user.userID{
                let editProfileVC = EditProfileVC()
                navigationController?.pushViewController(editProfileVC, animated: true)
            }else{
                DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
                    let messagesVC = MessagesVC()
                    messagesVC.chatTitle = user.username
                    messagesVC.memberIds = [currentUserId, user.userID]
                    messagesVC.membersToPush = [currentUserId, user.userID]
                    messagesVC.chatRoomId = ChatService.instance.startPrivateChat(user1: currentUser, user2: user)
                    messagesVC.isGroup = false
                    messagesVC.hidesBottomBarWhenPushed = true
                    let backButton = UIBarButtonItem()
                    backButton.title = ""
                    self.navigationItem.backBarButtonItem = backButton
                    self.navigationController?.pushViewController(messagesVC, animated: true)
                }
            }
        }else{
            let editProfileVC = EditProfileVC()
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
        
    }
    
    func addCategoriesData(for cell: CategoriesCollectionViewCell, indexPath: IndexPath) {
        
    }
    
    
    
//    MARK: - API
    
    private func getYoutubeChannelStats(url: String){
        AF.request(url, method : .get).responseJSON{
            response in

            switch response.result {
               case .success(let value):
                self.youtubeData.removeAll()
                for index in 0..<JSON(value)["items"].count{
                    let videoId = "\(JSON(value)["items"][index]["id"]["videoId"])"
                    let thumbnail = "\(JSON(value)["items"][index]["snippet"]["thumbnails"]["medium"]["url"])"
                    let title = "\(JSON(value)["items"][index]["snippet"]["title"])"
                    let youtubeData = YoutubeData(thumbnail: thumbnail, title: title, videoId: videoId)
                    self.youtubeData.append(youtubeData)
                }
                self.collectionView.reloadData()
                print(self.youtubeData.count)
                self.socialAccountButton.isHidden = true
                self.accountLinkLabel.isHidden = true
               case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchInstagramDetails(instaUsername: String){
        
        let url = "https://www.instagram.com/\(instaUsername)/?__a=1"
        AF.request(url, method: .get).responseJSON { response in
//            https://www.instagram.com/vivekrai2997/?__a=1
            switch response.result {
               case .success(let value):
                print("Success fetching instagram")
                print(JSON(value))
                let youtube = self.linkedAccounts["Youtube"]
                let twitter = self.linkedAccounts["Twitter"]
                var socialAccounts = ["linkedAccounts": ["Instagram": ["details": value, "username": instaUsername], "Twitter": twitter, "Youtube": youtube]]
                if youtube == nil{
                    socialAccounts = ["linkedAccounts": ["Instagram": ["details": value, "username": instaUsername], "Twitter": twitter]]
                }
                if twitter == nil{
                    socialAccounts = ["linkedAccounts": ["Instagram": ["details": value, "username": instaUsername], "Youtube": youtube]]
                }
                if youtube == nil && twitter == nil{
                    socialAccounts = ["linkedAccounts": ["Instagram": ["details": value, "username": instaUsername]]]
                }
                
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                USER_REF.document(currentUserId).updateData(socialAccounts) { (error) in
                    if let  _ = error{
                        return
                    }
                    self.toast = SwiftToast(text: "Linked Successfully")
                    self.linkedAccounts = socialAccounts
                    self.present(self.toast, animated: true)
                    self.fetchUserInstagramData()
                }

               case .failure(let error):
                print(error)
                self.toast = SwiftToast(text: "Unable to link, Please try again shortly!")
                self.present(self.toast, animated: true)

            }
        }
            
        
    }
    
    private func fetchUserInstagramData(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
//        guard let user = self.user else {return}
        
        
        var socialuser: Users?
        if let user = self.user{
            socialuser = user
        }else{
            guard let currentUser = self.currentUser else {return}
            socialuser = currentUser
        }
        guard let socialUser = socialuser else {return}
        
        let linkedAccounts = socialUser.linkedAccounts
        let instagram = linkedAccounts?["Instagram"]
        if instagram == nil{
            socialAccountButton.isHidden = false
            socialAccountButton.setImage(UIImage(named: "instagramicon"), for: .normal)
            accountLinkLabel.isHidden = false
            accountLinkLabel.text = "No Account Linked"
            
            if currentUserId == socialUser.userID{
                print("Current User Instagram")
                accountLinkLabel.text = "Click on Icon to link Insatgram"
                socialAccountButton.removeTarget(self, action: #selector(linkYoutube), for: .touchUpInside)
                socialAccountButton.addTarget(self, action: #selector(linkInstagram), for: .touchUpInside)
            }
        }else{
            socialAccountButton.isHidden = true
            accountLinkLabel.isHidden = true
        }
        print(linkedAccounts)
        let followers = JSON(linkedAccounts)["Instagram"]["details"]["graphql"]["user"]["edge_followed_by"]["count"]
        let following = JSON(linkedAccounts)["Instagram"]["details"]["graphql"]["user"]["edge_follow"]["count"]
        let profilePicUrl = JSON(linkedAccounts)["Instagram"]["details"]["graphql"]["user"]["profile_pic_url"]
        let username = JSON(linkedAccounts)["Instagram"]["details"]["graphql"]["user"]["username"]
        let posts = JSON(linkedAccounts)["Instagram"]["details"]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
        
        for i in 0..<posts.count{
            let likes = Int("\(posts[i]["node"]["edge_liked_by"]["count"])") ?? 0
            let comments = Int("\(posts[i]["node"]["edge_media_to_comment"]["count"])") ?? 0
            let creationDate = Double("\(posts[i]["node"]["taken_at_timestamp"])") ?? 0
            let postImageUrl = "\(posts[i]["node"]["thumbnail_src"])"
            
            let igPost = InstagramPosts(likes: likes, comments: comments, postImageUrl: postImageUrl, creationDate: creationDate, username: "\(username)", profileImageUrl: "\(profilePicUrl)")
            self.instagramPosts.append(igPost)
        }
        self.collectionView.reloadData()
//        print(followers, following, profilePicUrl, posts.count)
    }
    
    private func fetchUserYoutubeData(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        var socialuser: Users?
        if let user = self.user{
            socialuser = user
        }else{
            guard let currentUser = self.currentUser else {return}
            socialuser = currentUser
        }
//        guard let user = self.user else {return}
        
        guard let socialUser = socialuser else {return}
        let linkedAccounts = socialUser.linkedAccounts
        let youtube = linkedAccounts?["Youtube"]
        
        
        
        if youtube == nil{
            print("Come on")
            socialAccountButton.isHidden = false
            socialAccountButton.setImage(UIImage(named: "youtubeicon"), for: .normal)
            accountLinkLabel.isHidden = false
            accountLinkLabel.text = "No Account linked"
            if currentUserId == socialUser.userID{
                print("Come on here too")
                print("Current User Youtube")
                accountLinkLabel.text = "Click on Icon to link Insatgram"
                socialAccountButton.removeTarget(self, action: #selector(linkInstagram), for: .touchUpInside)
                socialAccountButton.addTarget(self, action: #selector(linkYoutube), for: .touchUpInside)
            }
        }else{
            socialAccountButton.isHidden = true
            accountLinkLabel.isHidden = true
        }
        let channelId = JSON(linkedAccounts)["Youtube"]["channelId"]
        print(channelId)
        AF.request("https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(channelId)&part=id%2Csnippet&order=date&type=video&maxResults=20", method : .get).responseJSON{
            response in

            switch response.result {
               case .success(let value):
                self.youtubeData.removeAll()
                for index in 0..<JSON(value)["items"].count{
                    let videoId = "\(JSON(value)["items"][index]["id"]["videoId"])"
                    let thumbnail = "\(JSON(value)["items"][index]["snippet"]["thumbnails"]["medium"]["url"])"
                    let title = "\(JSON(value)["items"][index]["snippet"]["title"])"
                    let youtubeData = YoutubeData(thumbnail: thumbnail, title: title, videoId: videoId)
                    self.youtubeData.append(youtubeData)
                }
                print(self.youtubeData)
                self.collectionView.reloadData()
//                self.socialAccountButton.isHidden = true
//                self.accountLinkLabel.isHidden = true
               case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUserData(header: SocialProfileHeader){
        
        if let user = self.user{
            header.profileImageView.loadImage(with: user.profileImageURL)
            header.usernameLabel.text = user.username
            
    //        let instagram = user.linkedAccounts["Instagram"]
    //        let youtube = user.linkedAccounts["Youtube"]
    //
    //        print(instagram)
    //        print(youtube)
    //        if youtube == nil{
    //            print("No Youtube")
    //        }
    //        if instagram == nil{
    //            print("No Instagram")
    //        }
            let userGender = user.gender.prefix(1).uppercased()
            let location = CLLocation(latitude: user.geoPoint.latitude, longitude: user.geoPoint.longitude)
            location.fetchCityAndCountry { (city, country, error) in
                guard let city = city, let country = country, error == nil else { return }
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .medium
                if let date = dateformatter.date(from: user.dateOfBirth ?? ""){
                    let calendar = NSCalendar.current
                    let components = calendar.dateComponents([.year], from: date, to: Date())
                    header.additionalDescLabel.text = country + ", \(components.year ?? 22) \(userGender)"
                }
            }
            if  user.socialScore == 0{
                header.socialScoreCardView.isHidden = true
                header.socialScoreLabel.isHidden = true
            }else{
                header.socialScoreLabel.text = "\(user.socialScore ?? 58)"
            }
            
            
            
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if let user = self.user {
                if currentUserId == user.userID{
                    header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
                }else{
                    header.editProfileMessageButton.setTitle("Message", for: .normal)
                }
            }else{
                header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
            }
        }else{
            setCurrentUserData(header: header)
        }
    }
    
    private func setCurrentUserData(header: SocialProfileHeader){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
        USER_REF.document(currentUserId).getDocument { [self] (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let socialScore = data["socialScore"] as? Int ?? 0
            let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
            let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userID = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let categories = data["categories"] as? [String] ?? [String]()
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
            
            header.profileImageView.loadImage(with: profileImageURL)
            header.usernameLabel.text = username
            let userGender = gender.prefix(1).uppercased()
            let location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
            location.fetchCityAndCountry { (city, country, error) in
                guard let city = city, let country = country, error == nil else { return }
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .medium
                if let date = dateformatter.date(from: dateofBirth){
                    let calendar = NSCalendar.current
                    let components = calendar.dateComponents([.year], from: date, to: Date())
                    header.additionalDescLabel.text = country + ", \(components.year ?? 22) \(userGender)"
                }
            }
            if  socialScore == 0{
                header.socialScoreCardView.isHidden = true
                header.socialScoreLabel.isHidden = true
            }else{
                header.socialScoreLabel.text = "\(socialScore ?? 58)"
            }
            
            if selectedAccount == "Instagram"{
                let instagram = linkedAccounts["Instagram"]
                if instagram == nil{
                    self.socialAccountButton.isHidden = false
                    self.socialAccountButton.setImage(UIImage(named: "instagramicon"), for: .normal)
                    self.accountLinkLabel.isHidden = false
                    self.accountLinkLabel.text = "Click on icon to link Instagram"
                    
                    
                    print("Current User Instagram")
                    self.socialAccountButton.removeTarget(self, action: #selector(self.linkYoutube), for: .touchUpInside)
                    self.socialAccountButton.addTarget(self, action: #selector(self.linkInstagram), for: .touchUpInside)
                    
                }else{
                    self.socialAccountButton.isHidden = true
                    self.accountLinkLabel.isHidden = true
                }
            }else{
                print("This one too")
                let youtube = linkedAccounts["Youtube"]
                if youtube == nil{
                    self.socialAccountButton.isHidden = false
                    self.socialAccountButton.setImage(UIImage(named: "youtubeicon"), for: .normal)
                    self.accountLinkLabel.isHidden = false
                    self.accountLinkLabel.text = "Click on icon to link Youtube"


                    print("Current User Youtube")
                    self.socialAccountButton.removeTarget(self, action: #selector(self.linkInstagram), for: .touchUpInside)
                    self.socialAccountButton.addTarget(self, action: #selector(self.linkYoutube), for: .touchUpInside)

                }else{
                    self.socialAccountButton.isHidden = true
                    self.accountLinkLabel.isHidden = true
                }
            }
            
        }
    }
    
    
    private func fetchCurrentUser(completion: @escaping(Users) -> ()){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        USER_REF.document(currentUserId).getDocument { [self] (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let socialScore = data["socialScore"] as? Int ?? 0
            let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
            let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userID = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let categories = data["categories"] as? [String] ?? [String]()
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
            self.linkedAccounts = linkedAccounts
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
            completion(user)
        }
    }
}


//for family in UIFont.familyNames.sorted(){
//    let names = UIFont.fontNames(forFamilyName: family)
//    print("Family: \(family) Font Name: \(names)")
//}
//        RoundedMplus1c-Regular  RoundedMplus1c-Medium RoundedMplus1c-Bold















































//import UIKit
//import Firebase
//import GoogleSignIn
//import Alamofire
//import SwiftyJSON
//import SDWebImage
//import SwiftToast
//
//private let reuseIdentifier = "socialProfileCollectionViewCell"
//private let headerIdentifier = "profileHeader"
//
//class SocialProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, SocialProfileHeaderDelegate, GIDSignInDelegate {
//
////    MARK: - Properties
//    var toast = SwiftToast()
//    var username: String?
//    var otherUser: Users?
//    var youtubeData = [YoutubeData]()
//    var showStats = false
//    var otherUserYoutubeId = ""
//    var linkedAccounts = Dictionary<String, Any>()
////    MARK: - Views
//
//    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground
//        configureNavigationBar()
//        configureCollectionView()
//        configureGoogleSignIn()
//
//        if let currentUserId = Auth.auth().currentUser?.uid{
//            USER_REF.document(currentUserId).getDocument { (snapshot, error) in
//                if let _ = error{
//                    return
//                }
//
//                guard let snapshot = snapshot else {return}
//                guard let data = snapshot.data() else {return}
//
//                let linkedAccounts = data["linkedAccounts"] as? [Dictionary<String, String>] ?? [Dictionary<String, String>]()
//                print(linkedAccounts)
//            }
//        }
//
//        if let username = self.username{
//            print(username, "Username")
//            self.fetchOtherUserDetails(username: username)
//        }else{
//            if let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID){
//                self.getYoutubeChannelStats(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(youtubeId)&part=id%2Csnippet&order=date&type=video&maxResults=20")
//            }
//        }
//
//
//
////        getYoutubeChannelStats(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(youtubeId)&part=id%2Csnippet&order=date&type=video&maxResults=20")
//
//
//
////        getYoutubeData(url: "https://www.googleapis.com/youtube/v3/videos?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&id=w0i2fyVhNlM&part=statistics")
////        getYoutubeData(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=UCbKc3B1rC-R0vQ1xShQ9cnA&part=id%2Csnippet&order=date&type=video&maxResults=20")
////        getYoutubeData(url: "https://www.googleapis.com/youtube/v3/channels?id=UCbKc3B1rC-R0vQ1xShQ9cnA&key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&part=snippet%2Cstatistics")
//
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(RELOAD_PROFILE_DATA), object: nil)
//    }
//
////    MARK: - Configure Views
//
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
//        navigationItem.title = "Social Profile"
//        if let username = self.username{
//
//        }else{
//            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profileMenuIcon"), style: .done, target: self, action: #selector(handleOptionsMenu))
//            navigationItem.rightBarButtonItem = rightBarButtonItem
//        }
//
//    }
//
//    private func configureCollectionView(){
//        self.collectionView.register(SocialProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView.register(SocialProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
//        self.collectionView.showsHorizontalScrollIndicator = false
//        self.collectionView.showsVerticalScrollIndicator = false
//        self.collectionView.backgroundColor = UIColor.secondarySystemBackground
//        self.collectionView.alwaysBounceVertical = true
//    }
//
//    private func configureGoogleSignIn(){
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.clientID = "832016968104-5no1q3gneq241vt9i68kkct0p36v0kq2.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        let scope: NSString = "https://www.googleapis.com/auth/youtube.readonly"
//        let currentScopes: NSArray = GIDSignIn.sharedInstance().scopes! as NSArray
//        GIDSignIn.sharedInstance().scopes = currentScopes.adding(scope)
//    }
//
//
//
//
////    MARK: - CollectionView Header
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SocialProfileHeader
//        header.delegate = self
//        configureHeaderView(header: header)
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if !otherUserYoutubeId.isEmpty{
//            return CGSize(width: view.frame.width, height: 448)
//        }else{
//            if let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID){
//                print(youtubeId, "Youtube")
//                if youtubeId == ""{
//                    return CGSize(width: view.frame.width, height: 384)
//                }else{
//                    return CGSize(width: view.frame.width, height: 448)
//                }
//            }else{
//                return CGSize(width: view.frame.width, height: 384)
//            }
//        }
//
//
//    }
//
////    MARK: - CollectionView Delegate and DataSource
//
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
//        let width = (view.frame.width - 2) / 2
//        return CGSize(width: width, height: 120)
//    }
//
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if !otherUserYoutubeId.isEmpty{
//            return youtubeData.count
//        }else{
//            if let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID){
//               if youtubeId.isEmpty || youtubeId == ""{
//                   return 0
//               }
//           }
//        }
//
//        return youtubeData.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SocialProfileCollectionViewCell
//        cell.postIV.sd_setImage(with: URL(string: youtubeData[indexPath.row].thumbnail), placeholderImage: UIImage(named: ""))
//        cell.titleLabel.text = youtubeData[indexPath.row].title
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//    }
//
////    MARK: - Handlers
//
//    func handleInstagram(for header: SocialProfileHeader) {
//        //1. Create the alert controller.
//        let alert = UIAlertController(title: "Instagram", message: nil, preferredStyle: .alert)
//
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.text = ""
//            textField.placeholder = "Enter your instagram username"
//        }
//
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
//        }))
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(textField?.text ?? "")")
//            if let instaUsername = textField?.text{
//                if !instaUsername.isEmpty{
//                    print(instaUsername)
//                    self.fetchInstagramDetails(instaUsername: instaUsername)
//                }else{
//                    print("Unable to fetch")
//                }
//            }else{
//                print("Unable to fetch")
//            }
//
//        }))
//
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//    }
//
//
//
//    @objc private func handleOptionsMenu(){
//        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
//           let settingsVC = SettingsVC()
//           let backButton = UIBarButtonItem()
//           backButton.title = ""
//           self.navigationItem.backBarButtonItem = backButton
//           self.navigationController?.pushViewController(settingsVC, animated: true)
//        }))
//
//        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//
//        }))
//
//        present(alertVC, animated: true, completion: nil)
//    }
//
//    private func showIndicatorView() {
//        view.addSubview(activityIndicatorView)
//        NSLayoutConstraint.activate([
//            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
//            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
//        ])
//    }
//
//    private func dismissIndicatorView(){
//        activityIndicatorView.removeFromSuperview()
//    }
//
//    private func fetchInstagramDetails(instaUsername: String){
//        let url = "https://www.instagram.com/\(instaUsername)/?__a=1"
//        AF.request(url, method: .get).responseJSON { response in
////            https://www.instagram.com/vivekrai2997/?__a=1
//            switch response.result {
//               case .success(let value):
//                print("Success fetching instagram")
//                print(JSON(value))
//                let linkedAccounts = ["linkedAccounts": ["Instagram": ["details": value, "username": instaUsername]]]
//                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//                USER_REF.document(currentUserId).updateData(linkedAccounts) { (error) in
//                    if let  _ = error{
//                        return
//                    }
//                    self.toast = SwiftToast(text: "Linked Successfully")
//                    self.present(self.toast, animated: true)
//
//                }
//
//               case .failure(let error):
//                print(error)
//                self.toast = SwiftToast(text: "Unable to link, Please try again shortly!")
//                self.present(self.toast, animated: true)
//
//            }
//        }
//
//
//    }
//
////    MARK: - Google SignIn
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let _ = error{
//            return
//        }
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                          accessToken: authentication.accessToken)
//        debugPrint(credential.provider)
//        debugPrint(authentication.accessToken)
//        debugPrint(authentication.clientID)
////        getYoutubeData(url: "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&access_token="+authentication.accessToken!)
//        let url = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&access_token="+authentication.accessToken!
//        YoutubeManager.instance.getChannelId(url: url) { (channelId) in
//            print(channelId)
//            if channelId == "null"{
//                self.toast = SwiftToast(text: "Invalid account. Unable to fetch Youtube Details!")
//                self.present(self.toast, animated: true)
//            }else{
//                UserDefaults.standard.set(channelId, forKey: YOUTUBE_ID)
//                let socialAccounts = ["linkedAccounts": ["Twitter": ["socialId":""], "Youtube": ["channelId": channelId]]]
//                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//                USER_REF.document(currentUserId).updateData(socialAccounts) { (error) in
//                    if let  _ = error{
//                        return
//                    }
//                    self.getYoutubeChannelStats(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(channelId)&part=id%2Csnippet&order=date&type=video&maxResults=20")
//                    self.collectionView.reloadData()
//                    print("Successfully updated")
//                }
//            }
//        }
//    }
//
//
////    MARK: - Set Data
//
//    private func configureHeaderView(header: SocialProfileHeader){
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//
//        if let username = self.username {
//
//            //  For other user
//            DataService.instance.fetchUserWithUsername(with: username) { (user) in
//                header.usernameLabel.text = user.username
//                if user.gender != ""{
//                    header.additionalDescLabel.text = "\(Locale.current.regionCode ?? ""), \(user.gender ?? "")"
//                }else{
//                    header.additionalDescLabel.text = "\(Locale.current.regionCode ?? "")"
//                }
//                header.bioLabel.text = user.bio
//
//                if currentUserId != user.userID{
//                    header.editProfileMessageButton.setTitle("Message", for: .normal)
//                }else{
//                    header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
//                }
//
//                header.socialLabel.text = "Social Account"
//                header.socialAccountButton.setTitle("   Youtube", for: .normal)
//                header.profileImageView.sd_setImage(with: URL(string: user.profileImageURL), placeholderImage: UIImage())
//                header.youtubeButton.isEnabled = false
//                header.youtubeTextLabel.text = "No Account Linked"
//                header.firstDataLabel.text = "Subscribers"
//                header.secondDataLabel.text = "Views/Video"
//                header.thirdDataLabel.text = "Views"
//                header.fourthDataLabel.text = "Engagement"
//                header.contentLabel.text = "Latest Videos"
//
//                if !self.otherUserYoutubeId.isEmpty{
//                    print(self.otherUserYoutubeId, "otherUserYoutubeId")
//                    if self.otherUserYoutubeId == ""{
//                        self.hideStatsViews(header: header)
//                    }else{
//                        self.showStatsView(header: header)
//                        YoutubeManager.instance.getChannelStats(url: "https://www.googleapis.com/youtube/v3/channels?id=\(self.otherUserYoutubeId)&key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&part=snippet%2Cstatistics") { (stats) in
//                            let subscribers = Int(stats[0]) ?? 1
//                            let views = Int(stats[1]) ?? 1
//                            let avgViews = Int((Int(stats[1]) ?? 0)/(Int(stats[2]) ?? 1))
//                            var engagement: Double = 0
//                            if subscribers != 0{
//                                engagement = Double(Double((views/subscribers))/100)
//                            }else{
//                                engagement = 0
//                            }
//
//                            print(engagement)
//                            header.firstNumLabel.text = stats[0]
//                            header.secondNumLabel.text = "\(avgViews)"
//                            header.thirdNumLabel.text = stats[1]
//                            header.fourthNumLabel.text = "\(engagement)%"
//                        }
//                    }
//                }else{
//                    self.hideStatsViews(header: header)
//                }
//            }
//        }else{
//
//                //  For current User
//                    guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//                    DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
//                        header.usernameLabel.text = user.username
//                        if user.gender != ""{
//                            header.additionalDescLabel.text = "\(Locale.current.regionCode ?? ""), \(user.gender ?? "")"
//                        }else{
//                            header.additionalDescLabel.text = "\(Locale.current.regionCode ?? "")"
//                        }
//                        header.bioLabel.text = user.bio
//
//                        header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
//                        header.socialLabel.text = "Social Account"
//                        header.socialAccountButton.setTitle("   Youtube", for: .normal)
//                        if let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL){
//                            header.profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage())
//                        }else{
//                            header.profileImageView.image = UIImage(named: "profile_botttom")
//                        }
//
//
//                        header.firstDataLabel.text = "Subscribers"
//                        header.secondDataLabel.text = "Views/Video"
//                        header.thirdDataLabel.text = "Views"
//                        header.fourthDataLabel.text = "Engagement"
//                        header.contentLabel.text = "Latest Videos"
//                    }
//                    if let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID){
//                        print(youtubeId, "youtubeId")
//                        if youtubeId == ""{
//                            self.hideStatsViews(header: header)
//                        }else{
//                            self.showStatsView(header: header)
//                            YoutubeManager.instance.getChannelStats(url: "https://www.googleapis.com/youtube/v3/channels?id=\(youtubeId)&key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&part=snippet%2Cstatistics") { (stats) in
//                                let subscribers = Int(stats[0]) ?? 1
//                                let views = Int(stats[1]) ?? 1
//                                let avgViews = Int((Int(stats[1]) ?? 0)/(Int(stats[2]) ?? 1))
//                                let engagement: Double = Double(Double((views/subscribers))/100)
//                                print(engagement)
//                                header.firstNumLabel.text = stats[0]
//                                header.secondNumLabel.text = "\(avgViews)"
//                                header.thirdNumLabel.text = stats[1]
//                                header.fourthNumLabel.text = "\(engagement)%"
//                            }
//                        }
//                    }else{
//                        self.hideStatsViews(header: header)
//                    }
//
//        }
//
//
//
//
//
////        if let user = self.user{
////            print("Other user")
////        }else{
////            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
////            DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
////                self.user = user
////                header.usernameLabel.text = user.username
////                if user.gender != ""{
////                    header.additionalDescLabel.text = "\(Locale.current.regionCode ?? ""), \(user.gender ?? "")"
////                }else{
////                    header.additionalDescLabel.text = "\(Locale.current.regionCode ?? "")"
////                }
////                header.bioLabel.text = user.bio
////
////                header.editProfileMessageButton.setTitle("Edit Profile", for: .normal)
////                header.socialLabel.text = "Social Account"
////                header.socialAccountButton.setTitle("   Youtube", for: .normal)
////
////                guard let youtubeId = UserDefaults.standard.string(forKey: YOUTUBE_ID) else {
////                    header.firstDataLabel.isHidden = true
////                    header.secondDataLabel.isHidden = true
////                    header.thirdDataLabel.isHidden = true
////                    header.fourthDataLabel.isHidden = true
////                    header.firstNumLabel.isHidden = true
////                    header.secondNumLabel.isHidden = true
////                    header.thirdNumLabel.isHidden = true
////                    header.fourthNumLabel.isHidden = true
////                    return
////                }
////                if youtubeId == "" || youtubeId == "null"{
////                    header.firstDataLabel.isHidden = true
////                    header.secondDataLabel.isHidden = true
////                    header.thirdDataLabel.isHidden = true
////                    header.fourthDataLabel.isHidden = true
////                    header.firstNumLabel.isHidden = true
////                    header.secondNumLabel.isHidden = true
////                    header.thirdNumLabel.isHidden = true
////                    header.fourthNumLabel.isHidden = true
////                }else{
////                    header.firstDataLabel.isHidden = false
////                    header.secondDataLabel.isHidden = false
////                    header.thirdDataLabel.isHidden = false
////                    header.fourthDataLabel.isHidden = false
////                    header.firstNumLabel.isHidden = false
////                    header.secondNumLabel.isHidden = false
////                    header.thirdNumLabel.isHidden = false
////                    header.fourthNumLabel.isHidden = false
////
////                    header.firstDataLabel.text = "Subscribers"
////                    header.secondDataLabel.text = "Views/Video"
////                    header.thirdDataLabel.text = "Views"
////                    header.fourthDataLabel.text = "Engagement"
////                    header.contentLabel.text = "Latest Videos"
////                    YoutubeManager.instance.getChannelStats(url: "https://www.googleapis.com/youtube/v3/channels?id=\(youtubeId)&key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&part=snippet%2Cstatistics") { (stats) in
////                        let subscribers = Int(stats[0]) ?? 1
////                        let views = Int(stats[1]) ?? 1
////                        let avgViews = Int((Int(stats[1]) ?? 0)/(Int(stats[2]) ?? 1))
////                        let engagement: Double = Double(Double((views/subscribers))/100)
////                        print(engagement)
////                        header.firstNumLabel.text = stats[0]
////                        header.secondNumLabel.text = "\(avgViews)"
////                        header.thirdNumLabel.text = stats[1]
////                        header.fourthNumLabel.text = "\(engagement)%"
////                    }
////                }
////
////            }
////        }
//    }
//
//    private func hideStatsViews(header: SocialProfileHeader){
//        header.firstDataLabel.isHidden = true
//        header.secondDataLabel.isHidden = true
//        header.thirdDataLabel.isHidden = true
//        header.fourthDataLabel.isHidden = true
//        header.firstNumLabel.isHidden = true
//        header.secondNumLabel.isHidden = true
//        header.thirdNumLabel.isHidden = true
//        header.fourthNumLabel.isHidden = true
//        header.firstDataView.isHidden = true
//        header.secondDataView.isHidden = true
//        header.thirdDataView.isHidden = true
//        header.fourthDataView.isHidden = true
//        header.contentLabel.isHidden = true
//        header.youtubeButton.isHidden = false
//        header.youtubeTextLabel.isHidden = false
//    }
//
//    private func showStatsView(header: SocialProfileHeader){
//        header.firstDataLabel.isHidden = false
//        header.secondDataLabel.isHidden = false
//        header.thirdDataLabel.isHidden = false
//        header.fourthDataLabel.isHidden = false
//        header.firstNumLabel.isHidden = false
//        header.secondNumLabel.isHidden = false
//        header.thirdNumLabel.isHidden = false
//        header.fourthNumLabel.isHidden = false
//        header.firstDataView.isHidden = false
//        header.secondDataView.isHidden = false
//        header.thirdDataView.isHidden = false
//        header.fourthDataView.isHidden = false
//        header.contentLabel.isHidden = false
//        header.youtubeButton.isHidden = true
//        header.youtubeTextLabel.isHidden = true
//    }
//
////    MARK: - API
//
//    private func getYoutubeChannelStats(url: String){
//        AF.request(url, method : .get).responseJSON{
//            response in
//
//            switch response.result {
//               case .success(let value):
//                for index in 0..<JSON(value)["items"].count{
//                    let videoId = "\(JSON(value)["items"][index]["id"]["videoId"])"
//                    let thumbnail = "\(JSON(value)["items"][index]["snippet"]["thumbnails"]["medium"]["url"])"
//                    let title = "\(JSON(value)["items"][index]["snippet"]["title"])"
//                    let youtubeData = YoutubeData(thumbnail: thumbnail, title: title, videoId: videoId)
//                    self.youtubeData.append(youtubeData)
//                }
//                self.collectionView.reloadData()
//               case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    func getYoutubeData(url : String){
//
//
//
//
//        AF.request(url, method : .get).responseJSON{
//            response in
//
//            switch response.result {
//               case .success(let value):
//                print("Success fetching")
////                print(JSON(value)["items"][0]["id"])
////                print(JSON(value)["items"][0]["statistics"]["subscriberCount"])
////                print(JSON(value)["items"][0]["statistics"]["videoCount"])
////                print(JSON(value)["items"][0]["statistics"]["viewCount"])
////                print(JSON(value)["items"].count)
////
////                for index in 0..<JSON(value)["items"].count{
////                    print(JSON(value)["items"][index]["id"]["videoId"])
////                    print(JSON(value)["items"][index]["snippet"]["thumbnails"]["medium"]["url"])
////                    print(JSON(value)["items"][index]["snippet"]["title"])
////                }
////                print(JSON(value)["items"][0]["statistics"]["likeCount"])
////                print(JSON(value)["items"][0]["statistics"]["dislikeCount"])
////                print(JSON(value)["items"][0]["statistics"]["commentCount"])
////                print(JSON(value)["items"][0]["statistics"]["viewCount"])
//
//               case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func fetchOtherUserDetails(username: String){
//        USER_REF.whereField("username", isEqualTo: username).getDocuments{ (snapshot, error) in
//            if let error = error{
//                debugPrint(error.localizedDescription)
//                return
//            }
//            guard let snapshot = snapshot else {return}
//            for document in snapshot.documents{
//                let data = document.data()
//                let userID = document.documentID
//                let name = data["name"] as? String ?? ""
//                let username = data["username"] as? String ?? ""
//                let phoneNumber = data["phoneNumber"] as? String ?? ""
//                let bio = data["bio"] as? String ?? ""
//                let dateOfBirth = data["dateOfBirth"] as? String ?? ""
//                let email = data["email"] as? String ?? ""
//                let gender = data["gender"] as? String ?? ""
//                let profileImageURL = data["profileImageUrl"] as? String ?? ""
//                let websiteUrl = data["websiteUrl"] as? String ?? ""
//                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
//                let swipeImageUrls = data["swipeImageUrls"] as? [String] ?? [String]()
//                let linkedAccounts = data["linkedAccounts"] as? [String: [String: String]] ?? [:]
//                let youtubeId = linkedAccounts["Youtube"]?["channelId"] ?? ""
//                let twitterId = linkedAccounts["Twitter"]?["socialId"] ?? ""
//                let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
//                let categories = data["categories"] as? [String] ?? [String]()
//                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
//
//                let user = Users(bio: bio, dateOfBirth: dateOfBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint, categories: categories)
//                self.otherUser = user
//                print(youtubeId)
//                self.otherUserYoutubeId = youtubeId
//                if !youtubeId.isEmpty{
//                    print(youtubeId)
//                    self.getYoutubeChannelStats(url: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0&channelId=\(youtubeId)&part=id%2Csnippet&order=date&type=video&maxResults=20")
//                }
//                self.collectionView.reloadData()
//            }
//
//
//        }
//    }
//
////    MARK: - Handlers
//
//
//    func handleYoutubeButtonTapped(for header: SocialProfileHeader) {
//        GIDSignIn.sharedInstance()?.signIn()
//    }
//
//    func addCategoriesData(for cell: CategoriesCollectionViewCell, indexPath: IndexPath) {
////        if let username = self.username{
////            DataService.instance.fetchUserWithUsername(with: username) { (user) in
////                if !user.categories.isEmpty{
////                    cell.categoryButton.setTitle(user.categories[indexPath.row], for: .normal)
////                }else{
////                    cell.categoryButton.isHidden = true
////                }
////
////            }
////        }else{
////            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
////            DataService.instance.fetchUserSocialProfile(with: currentUserId) { (user) in
////                cell.categoryButton.setTitle(user.categories[indexPath.row], for: .normal)
////            }
////        }
//    }
//
//
////
//
//    func handleEditProfileMessageButton(for header: SocialProfileHeader) {
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//        if let username = self.username{
//            if let currentUsername = UserDefaults.standard.string(forKey: USERNAME){
//                if username == currentUsername{
//                    let editProfileVC = EditProfileVC()
//                    let backButton = UIBarButtonItem()
//                    backButton.title = ""
//                    navigationItem.backBarButtonItem = backButton
//                    navigationController?.pushViewController(editProfileVC, animated: true)
//                }else{
//                    DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
//                        if let otherUser = self.otherUser{
//                            let messagesVC = MessagesVC()
//                            messagesVC.chatTitle = otherUser.username
//                            messagesVC.memberIds = [currentUserId, otherUser.userID]
//                            messagesVC.membersToPush = [currentUserId, otherUser.userID]
//                            messagesVC.chatRoomId = ChatService.instance.startPrivateChat(user1: currentUser, user2: otherUser)
//                            messagesVC.isGroup = false
//                            messagesVC.hidesBottomBarWhenPushed = true
//                            let backButton = UIBarButtonItem()
//                            backButton.title = ""
//                            self.navigationItem.backBarButtonItem = backButton
//                            self.navigationController?.pushViewController(messagesVC, animated: true)
//                        }
//                    }
//                }
//            }
//        }else{
//            let editProfileVC = EditProfileVC()
//            let backButton = UIBarButtonItem()
//            backButton.title = ""
//            navigationItem.backBarButtonItem = backButton
//            navigationController?.pushViewController(editProfileVC, animated: true)
//        }
//    }
//
//    func handleWebsiteTapped(for header: SocialProfileHeader) {
//
//    }
//
//    func handleFollowersTapped(for header: SocialProfileHeader) {
//
//    }
//
//    func handleFollowingTapped(for header: SocialProfileHeader) {
//
//    }
//
//    @objc private func reloadData(){
//        self.collectionView.reloadData()
//    }
//
//
//}
