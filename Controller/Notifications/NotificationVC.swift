//
//  NotificationVC.swift
//  Flytant
//
//  Created by Vivek Rai on 26/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let tableViewReuseIdentifier = "notificationTableviewCell"

class NotificationVC: UITableViewController, NotificationCellDelegate {
    
//    MARK: - Properties
    var notifications = [Notification]()
    var chatVC: ChatVC?
//    MARK: - Views
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    let navigationTitleView = FLabel(backgroundColor: UIColor.clear, text: "Notifications", font: UIFont(name: "RoundedMplus1c-Bold", size: 24)!, textAlignment: .left, textColor: UIColor.label)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchNotifications()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationTitleView.removeFromSuperview()
        tabBarController?.tabBar.isHidden = false
    }
    
//  MARK: - Configure Views
    
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
//        navigationItem.title = "Notifications"
//    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        
        navigationTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationTitleView.centerXAnchor.constraint(equalTo: navigationController!.navigationBar.centerXAnchor, constant: 0),
            navigationTitleView.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.centerYAnchor, constant: 0),
        ])
        
//        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    private func configureTableView(){
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.systemBackground
        tableView.rowHeight = 60
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: tableViewReuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
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
        return notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReuseIdentifier, for: indexPath) as! NotificationTableViewCell
        if !notifications.isEmpty{
            cell.notification = self.notifications[indexPath.row]
        }
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = self.notifications[indexPath.row].senderId else {return}
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
    
//    MARK: - Handlers
    
    func handlePostTapped(for cell: NotificationTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell) else {return}
        let singlePostVC = SinglePostVC()
        DataService.instance.fetchPost(with: self.notifications[indexpath.row].postId) { (post) in
            singlePostVC.post = post
            self.navigationController?.pushViewController(singlePostVC, animated: true)
        }
    }
    
    func handleFollowTapped(for cell: NotificationTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell) else {return}
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        DataService.instance.fetchPartnerUser(with: notifications[indexpath.row].senderId) { (user) in
            if !user.didFollow{
               cell.followButton.setTitle("Following", for: .normal)
               cell.followButton.setTitleColor(.label, for: .normal)
               cell.followButton.backgroundColor = UIColor.systemBackground
               self.updateFollowing(indexPath: indexpath)
            }else{
               cell.followButton.setTitle("Follow", for: .normal)
               cell.followButton.setTitleColor(.white, for: .normal)
               cell.followButton.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
               self.updateFollowing(indexPath: indexpath)
            }
        }
    }
    
    func handleMessageTapped(for cell: NotificationTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell) else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
            DataService.instance.fetchPartnerUser(with: self.notifications[indexpath.row].senderId) { (user) in
                print("Hello")
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
    
    @objc private func handleRefresh(){
        fetchNotifications()
    }
    
//    MARK: - API
    
    private func fetchNotifications(){
        showIndicatorView()
        self.notifications.removeAll()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        NOTIFICATIONS_REF.whereField("receiverId", isEqualTo: currentUserId).limit(to: 30).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                self.tableView.refreshControl?.endRefreshing()
                return
            }
            
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let receiverId = data["receiverId"] as? String ?? ""
                let senderId = data["senderId"] as? String ?? ""
                let creationDate = data["creationDate"] as? Double ?? 0
                let checked = data["checked"] as? Int ?? 0
                let postId = data["postId"] as? String ?? ""
                let postImageUrl = data["postImageUrl"] as? String ?? ""
                let senderProfileImageUrl = data["senderProfileImageUrl"] as? String ?? ""
                let senderUsername = data["senderUsername"] as? String ?? ""
                let type = data["type"] as? Int ?? 0
                
                let notification = Notification(checked: checked, creationDate: creationDate, postId: postId, postImageUrl: postImageUrl, receiverId: receiverId, senderId: senderId, senderProfileImageUrl: senderProfileImageUrl, senderUsername: senderUsername, type: type)
                self.notifications.append(notification)
                self.notifications.sort { (notification1, notifcation2) -> Bool in
                    return notification1.creationDate > notifcation2.creationDate
                }
            }
            self.tableView.reloadData()
            self.dismissIndicatorView()
            self.tableView.refreshControl?.endRefreshing()
            
        }
        
    }

    private func updateFollowing(indexPath: IndexPath){
        DataService.instance.fetchPartnerUser(with: notifications[indexPath.row].senderId) { (user) in
            if !user.didFollow{
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                guard let otherUserId = user.userID else {return}
                let currentUserData = ["\(otherUserId)": true]
                let otherUserData = ["\(currentUserId)": true]
                FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    FOLLOWERS_REF.document(otherUserId).setData(otherUserData, merge: true) { (error) in
                        if let _ = error{
                            return
                        }
                        user.didFollow = !user.didFollow
                        NotificationService.instance.sendFollowNotification(userId: otherUserId, didFollow: true)
                    }
                }

            }else{
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                guard let otherUserId = user.userID else {return}
                let currentUserData = ["\(otherUserId)": false]
                let otherUserData = ["\(currentUserId)": false]
                FOLLOWING_REF.document(currentUserId).setData(currentUserData, merge: true) { (error) in
                    if let _ = error{
                        return
                    }
                    FOLLOWERS_REF.document(otherUserId).setData(otherUserData, merge: true) { (error) in
                        if let _ = error{
                            return
                        }
                        debugPrint("Successfully updated")
                        user.didFollow = !user.didFollow
                        NotificationService.instance.sendFollowNotification(userId: otherUserId, didFollow: false)
                    }
                }
            }
        }
    }

}
