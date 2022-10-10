//
//  AppliedVC.swift
//  Flytant
//
//  Created by Vivek Rai on 04/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SwiftToast

private let reuseIdentifier = "myCampaignCollectionViewCell"

class AppliedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ApplieCellDelegate {
    
    //    MARK: - Properties
        
        var users = [Users]()
        var influencers = [String]()
        var index = 10
        var hasMore = true
        var toast = SwiftToast()
    //    MARK: - Views
        
        let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureNavigationBar()
            configureCollectionView()
            print(influencers.count)
            if self.influencers.count > 10 { hasMore = true }
    //        print(Array(influencers[0..<index]))
            if !self.influencers.isEmpty{
                print(index)
                if influencers.count < 10{
                    index = influencers.count
                }
                fetchUsersData(influencers: Array(influencers[0..<index]))
            }else{
                self.toast = SwiftToast(text: "Your campaign is in review.")
                self.present(self.toast, animated: true)
            }
            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = false
        }
        
        
    //    MARK: - Configure Views
        
        private func configureNavigationBar(){
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.barTintColor = UIColor.label
            navigationController?.navigationBar.tintColor = UIColor.label
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
            navigationItem.title = "Influencers"

        }
     
      
    
    private func configureCollectionView(){
      
        self.collectionView.register(AppliedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
    
    
        
//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppliedCollectionViewCell
        cell.delegate = self
        if !users.isEmpty{
            cell.user = self.users[indexPath.row]
        }
        return cell
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if indexPath.row == users.count - 1{
                var finalIndex = index + 10
                if finalIndex > influencers.count{
                    finalIndex = influencers.count
                }
                print(index, finalIndex)
                print(Array(influencers[index..<finalIndex]))
                fetchUsersData(influencers: Array(influencers[index..<finalIndex]))
                self.index = self.index + 10
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2 - 1), height: 224)
    }

//    MARK: - Handlers
    
    func handleMessage(for cell: AppliedCollectionViewCell) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
            let messagesVC = MessagesVC()
            messagesVC.chatTitle = self.users[indexPath.row].username
            messagesVC.memberIds = [currentUserId, self.users[indexPath.row].userID]
            messagesVC.membersToPush = [currentUserId, self.users[indexPath.row].userID]
            messagesVC.chatRoomId = ChatService.instance.startPrivateChat(user1: currentUser, user2: self.users[indexPath.row])
            messagesVC.isGroup = false
            messagesVC.hidesBottomBarWhenPushed = true
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(messagesVC, animated: true)
        }
       
    }
    
    func handleProfile(for cell: AppliedCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        DataService.instance.fetchUserWithUserId(with: self.users[indexPath.row].userID) { (user) in
            let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            socialProfileVC.user = user
            socialProfileVC.changeHeader = true
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(socialProfileVC, animated: true)
        }
    }
//    MARK: - API
    
    private func fetchUsersData(influencers: [String]){
        
        showIndicatorView()
        USER_REF.whereField("userId", in: influencers).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let userId = document.documentID
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
                let categories = data["categories"] as? [String] ?? [String]()
                
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint)
                self.users.append(user)
            }
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            if self.influencers.count == self.users.count{ self.hasMore = false}
        }
        
        
        
//        self.showIndicatorView()
//        if self.index < self.influencers.count{
//            DataService.instance.fetchPartnerUserWithCompletion(with: self.influencers[self.index]) { (user, success) in
//                if success{
//                    self.index = self.index + 1
//                    self.users.append(user)
//                }else{
//                    self.fetchUsersData(for: self.index)
//                }
//            }
//        }else{
//            self.dismissIndicatorView()
//            self.collectionView.reloadData()
//            return
//        }
        
//        Use Where in Array with 10 users from Firebase
    }

}
