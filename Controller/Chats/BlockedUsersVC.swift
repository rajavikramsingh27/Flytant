//
//  BlockedUsersVC.swift
//  Flytant
//
//  Created by Vivek Rai on 22/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "blockedUsersCollectionViewCell"

class BlockedUsersVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    var blockedUsers = [Users]()
    var blockedUsersId = [String]()
    var index = 0
    

//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
        
        fetchBlockedUsersId()
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
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.label
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Blocked Users"
        
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(BlockedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
      
          
//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 72)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BlockedCollectionViewCell
        cell.nameLabel.text = blockedUsers[indexPath.row].username
        cell.profileImageView.loadImage(with: blockedUsers[indexPath.row].profileImageURL)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Do you want to unblock?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Unblock", style: .destructive, handler: { (action) in
            self.unblockUser(at: indexPath.row)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
//    MARK: - API
    
    private func fetchBlockedUsersId(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        USER_REF.document(currentUserId).getDocument{ (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            self.blockedUsersId = blockedUsers
            self.fetchBlockedUsers()
            
        }
    }
    
    private func fetchBlockedUsers(){
        if self.index < blockedUsersId.count{
            fetchBlockedUser(userId: blockedUsersId[self.index]) { (success, error) in
                if success{
                    self.index += 1
                    self.fetchBlockedUsers()
                }
            }
        }else{
            self.collectionView.reloadData()
            self.dismissIndicatorView()
        }

    }
    
    private func fetchBlockedUser(userId: String, userFetchComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        self.showIndicatorView()
        USER_REF.document(userId).getDocument{ (snapshot, error) in
            if let _ = error{
                userFetchComplete(false, error)
                self.dismissIndicatorView()
                return
            }
                
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userID = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
            self.blockedUsers.append(user)
            self.dismissIndicatorView()
            userFetchComplete(true, error)
        }
    }

    private func unblockUser(at index: Int){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        debugPrint("Unblock \(index)")
        blockedUsersId = blockedUsersId.filter(){$0 != blockedUsersId[index]}
        let value = ["blockedUsers": blockedUsersId]
        USER_REF.document(currentUserId).updateData(value)
        blockedUsers.remove(at: index)
        self.collectionView.reloadData()
    }
}
