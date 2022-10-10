//
//  SwipeCardVC.swift
//  Flytant
//
//  Created by Vivek Rai on 29/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class SwipeCardVC: UIViewController, SwipeHeaderDelegate, SwipeBottomDelegate, CardViewDelegate, MatchViewDelegate, AnonymousLoginViewDelegate {

//    MARK: - Properties
    
    var user: Users?
    var users = [Users]()
    var topCardView: CardView?
    var cardViews = [CardView]()
    private var viewModels = [CardViewModel]()
    
//    MARK: - Views
    private var anonymousView = AnonymousView()
    let topStack = SwipeCardNavigationStackView()
    let deckView = UIView()
    let bottomStack = SwipeCardBottomStackView()
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anonymousView.delegate = self
        
        view.backgroundColor = UIColor.systemBackground
        configureUI()
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForUserDetails()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
//    MARK: - ConfigureViews
    
    private func configureUI(){
        //topStack.delegate = self
        bottomStack.delegate = self
        
        deckView.backgroundColor = UIColor.systemBackground
        deckView.layer.cornerRadius = 5
        
        //let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        let stack = UIStackView(arrangedSubviews: [deckView, bottomStack])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 60, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
    
    private func setupTransforms(cardView: CardView) {
        for (i, _) in viewModels.enumerated() {
            if i == 0 { continue; }
            
            if i > 3 { return }
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            } else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            
            cardView.transform = transform
        }
    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
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
    
    private func checkForUserDetails(){
         if let name = UserDefaults.standard.string(forKey: NAME), let dob = UserDefaults.standard.string(forKey: DATE_OF_BIRTH), let gender = UserDefaults.standard.string(forKey: GENDER), let bio = UserDefaults.standard.string(forKey: BIO), let swipeImageUrls = UserDefaults.standard.stringArray(forKey: SWIPE_IMAGE_URLS){
            
            if name == "" || bio == "" || gender == "" || dob == "" || swipeImageUrls.isEmpty{
                let swipeSetting = SwipeSetting()
                swipeSetting.showCancel = false
                let nav = UINavigationController(rootViewController: swipeSetting)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    func handleLogin() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DataService.instance.socialLogout()
            DataService.instance.resetDefaults()
            let displayVC = DisplayVC()
            displayVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(displayVC, animated: true)
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func handleCancel() {
        removeAnonymousView()
    }

    
    func handleSettings() {
        let swipeSetting = SwipeSetting()
        let nav = UINavigationController(rootViewController: swipeSetting)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func handleFindUsers() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Find Users", style: .default, handler: { (action) in
            let usersAroundVC = UsersAroundVC(collectionViewLayout: UICollectionViewFlowLayout())
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(usersAroundVC, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "New Matches", style: .default, handler: { (action) in
            let newMatchesVC = NewMatchesVC()
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(newMatchesVC, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
       
    }

    func handleLike(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let topCard = self.topCardView else {return}
            performSwipeAnimation(shouldLike: true)
            saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
        }
    }

    func handleDislike(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let topCard = self.topCardView else {return}
            performSwipeAnimation(shouldLike: false)
            Swipes.saveSwipes(forUser: topCard.viewModel.user, isLike: false, completion: nil)
        }
    }
    
    func performSwipeAnimation(shouldLike: Bool){
    
        let translation: CGFloat = shouldLike ? 700 : -700
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
           
        }) { (_) in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else {return}
            self.cardViews.remove(at: self.cardViews.count-1)
            self.topCardView = self.cardViews.last

        }
        
    }
    
    func saveSwipe(for view: CardView, didLike: Bool) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            view.removeFromSuperview()
            self.cardViews.removeAll(where: {view == $0})
            guard let user = topCardView?.viewModel.user else {return}
            saveSwipeAndCheckForMatch(forUser: user, didLike: didLike)
            self.topCardView = self.cardViews.last
        }
    }
    
    func showProfile(for view: CardView, user: Users) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: Users, didLike: Bool){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            Swipes.saveSwipes(forUser: user, isLike: didLike) { (error) in
                self.topCardView = self.cardViews.last
                guard didLike == true else {return}
                
                Swipes.checkForMatches(forUser: user) { (didMatch) in
                    debugPrint("Users did match")
                    self.presentMatchView(forUser: user)
                }
            }
        }
        
    }
    
    func presentMatchView(forUser user: Users){
        guard let currentUser = self.user else {return}
        let matchView = MatchView(currentUser: currentUser, matchedUser: user)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func handleMessage(for view: MatchView, user: Users) {
        
        showMessagesVC(user: user)
    }
    
    func showMessagesVC(user: Users){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
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

    
//    MARK: - API
    
    private func fetchUsers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        showIndicatorView()
        USER_REF.limit(to: 20).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userId = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let swipeImageUrls = data["swipeImageUrls"] as? [String] ?? [String]()
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint, swipeImageUrls: swipeImageUrls)
                let cardViewModel = CardViewModel(user: user)
                if userId != currentUserId{
                    self.viewModels.append(cardViewModel)
                    
                    let cardView = CardView(viewModel: cardViewModel)
                    cardView.delegate = self
                    self.deckView.addSubview(cardView)
                    cardView.anchor(top: self.deckView.topAnchor, left: self.deckView.leftAnchor, bottom: self.deckView.bottomAnchor, right: self.deckView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
                    self.setupTransforms(cardView: cardView)
                    self.cardViews = self.deckView.subviews.map({(($0 as? CardView)!)})
                    self.topCardView = self.cardViews.last
                    
                }else{
                    self.user = user
                }
                
            }
            self.dismissIndicatorView()
            return
        }
    }
    
}
