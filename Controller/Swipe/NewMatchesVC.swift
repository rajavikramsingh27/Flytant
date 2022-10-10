//
//  NewMatchesVC.swift
//  Flytant
//
//  Created by Vivek Rai on 09/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let tableViewReuseIdentifier = "newMatchesTableviewCell"

class NewMatchesVC: UITableViewController {
    
//    MARK: - Properties
    var matchedUsers = [SwipeMatches]()
    
//    MARK: - Views
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureTableView()
        fetchMatchedUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: true)
        //tabBarController?.tabBar.isHidden = true
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        //navigationController?.setNavigationBarHidden(true, animated: true)
//        tabBarController?.tabBar.isHidden = false
//    }
    
//  MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationItem.title = "New Matches"
    }
    
    private func configureTableView(){
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.systemBackground
        tableView.rowHeight = 75
        tableView.register(NewMatchesTableViewCell.self, forCellReuseIdentifier: tableViewReuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
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

//  MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReuseIdentifier, for: indexPath) as! NewMatchesTableViewCell
        cell.swipedUser = matchedUsers[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = self.matchedUsers[indexPath.row].userId else {return}
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Visit Profile", style: .default, handler: { (action) in
            DataService.instance.fetchPartnerUser(with: userId) { (user) in
                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                profileVC.user = user
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Send Message", style: .default, handler: { (action) in
            DataService.instance.fetchPartnerUser(with: userId) { (user) in
                self.showMessagesVC(user: user)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
//    MARK: - API
    
    private func fetchMatchedUsers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        showIndicatorView()
        SWIPES_REF.document(currentUserId).collection("Matches").getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            for document in snapshot.documents{
                let data = document.data()
                
                let bio = data["bio"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let userId = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let counter = data["counter"] as? Int ?? 0
                let matchedUser = SwipeMatches(bio: bio, counter: counter, profileImageUrl: profileImageUrl, userId: userId, username: username)
                self.matchedUsers.append(matchedUser)
            }
            self.tableView.reloadData()
            self.dismissIndicatorView()
        }
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
}
