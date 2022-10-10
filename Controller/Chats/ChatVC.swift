//
//  ChatVC.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import FirebaseFirestore
import MessageUI
import ProgressHUD

private let reuseIdentifier = "chatsCollectionViewCell"
private let headerIdentifier = "chatsHeader"

class ChatVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

//    MARK: - Properties
    
    var chats = [Chats]()
    var inSearchMode = false
    var filteredChats = [Chats]()
    
//    MARK: - Views
    
    private var anonymousView = AnonymousView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    let navigationTitleView = FLabel(backgroundColor: UIColor.clear, text: "Chats", font: UIFont(name: "RoundedMplus1c-Bold", size: 24)!, textAlignment: .left, textColor: UIColor.label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
        fetchRecentChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationTitleView.removeFromSuperview()
    }

//    MARK: - Configure Views
    
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
//        navigationItem.title = "Chats"
//    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        
        let callBarButtonItem = UIBarButtonItem(image: UIImage(named: "callIcon"), style: .done, target: self, action: #selector(handleCallLogs))
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .done, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [settingsBarButtonItem, callBarButtonItem]
        
    }
    
    private func configureCollectionView(){
        self.collectionView.register(ChatsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ChatHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        
    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
    }

        
//    MARK: - CollectionView Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ChatHeader
        header.searchBar.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
//    MARK: - CollectionView Delegate and DataSource
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 72)
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredChats.count
        }else{
            return chats.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatsCollectionViewCell
        var chat: Chats!
        if inSearchMode {
            if !filteredChats.isEmpty{
                chat = filteredChats[indexPath.row]
            }
        } else {
            if !chats.isEmpty{
                chat = chats[indexPath.row]
            }
        }
        cell.chat = chat
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedChats = [Chats]()
        selectedChats = chats
        if inSearchMode{
            selectedChats = filteredChats
        }else{
            selectedChats = chats
        }
        if !selectedChats.isEmpty{
                var recentChats: NSDictionary!
                recentChats = ["chatImageUrl": selectedChats[indexPath.row].chatImageUrl!, "chatRoomId": selectedChats[indexPath.row].chatRoomId!, "counter": selectedChats[indexPath.row].counter!, "creationDate": selectedChats[indexPath.row].creationDate!, "lastMessage": selectedChats[indexPath.row].lastMessage!, "members": selectedChats[indexPath.row].members!, "membersToPush": selectedChats[indexPath.row].membersToPush!, "recentId": selectedChats[indexPath.row].recentId!, "type": selectedChats[indexPath.row].type!, "withUserId": selectedChats[indexPath.row].withUserId!, "withUsername": selectedChats[indexPath.row].withUsername!, "userId": selectedChats[indexPath.row].userId!]
                ChatService.instance.restartRecentChat(recent: recentChats)
                let messagesVC = MessagesVC()
                messagesVC.membersToPush = (recentChats[MEMBERS_TO_PUSH] as? [String])!
                messagesVC.memberIds = (recentChats[MEMBERS] as? [String])!
                messagesVC.chatRoomId = (recentChats[CHAT_ROOM_ID] as? String)!
                messagesVC.chatTitle = (recentChats[WITH_USERNAME] as? String)!
                messagesVC.isGroup = (recentChats[TYPE] as? String)! == GROUP_CHAT
                messagesVC.hidesBottomBarWhenPushed = true
                let backButton = UIBarButtonItem()
                backButton.title = ""
                navigationItem.backBarButtonItem = backButton
                navigationController?.pushViewController(messagesVC, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
//    MARK: - Handlers
    
    @objc private func handleOptionsMenu(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Call Logs", style: .default, handler: { (action) in
           let callLogsVC = CallLogsVC(collectionViewLayout: UICollectionViewFlowLayout())
           let backButton = UIBarButtonItem()
           backButton.title = ""
           self.navigationItem.backBarButtonItem = backButton
           self.navigationController?.pushViewController(callLogsVC, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Chat Settings", style: .default, handler: { (action) in
           let chatSettings = ChatSettings()
           let backButton = UIBarButtonItem()
           backButton.title = ""
           self.navigationItem.backBarButtonItem = backButton
           self.navigationController?.pushViewController(chatSettings, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
           
        }))
       
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func handleCallLogs(){
        let callLogsVC = CallLogsVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(callLogsVC, animated: true)
    }
    
    @objc private func handleSettings(){
        let chatSettings = ChatSettings()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(chatSettings, animated: true)
    }
    
    
    func showMessagesVC(user: Users){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
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
    
//    MARK: - SearchBar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            collectionView.reloadData()
            searchBar.endEditing(false)
        } else {
            inSearchMode = true
            filteredChats = chats.filter({ (chat) -> Bool in
                return chat.withUsername.contains(searchText) || chat.lastMessage.contains(searchText)
            })
            collectionView.reloadData()
            searchBar.endEditing(false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    
//    MARK: - API
    
    private func fetchRecentChats(){
        showIndicatorView()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        RECENT_CHAT_REF.whereField("userId", isEqualTo: currentUserId).addSnapshotListener(includeMetadataChanges: true){ (snapshot, error) in
            if let _ = error{
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
                return
            }
            self.chats.removeAll()
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let chatImageUrl = data["chatImageUrl"] as? String ?? ""
                let chatRoomId = data["chatRoomId"] as? String ?? ""
                let counter = data["counter"] as? Int ?? 0
                let creationDate = data["creationDate"] as? Double ?? 0
                let lastMessage = data["lastMessage"] as? String ?? ""
                let members = data["members"] as? [String] ?? [String]()
                let membersToPush = data["membersToPush"] as? [String] ?? [String]()
                let recentId = data["recentId"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let userId = data["userId"] as? String ?? ""
                let withUserId = data["withUserId"] as? String ?? ""
                let withUsername = data["withUsername"] as? String ?? ""
                if !lastMessage.isEmpty && !chatRoomId.isEmpty && !recentId.isEmpty{
                    let chat = Chats(lastMessage: lastMessage, members: members, membersToPush: membersToPush, recentId: recentId, type: type, userId: userId, withUserId: withUserId, withUsername: withUsername, creationDate: creationDate, counter: counter, chatRoomId: chatRoomId, chatImageUrl: chatImageUrl)
                    self.chats.append(chat)
                    self.chats.sort { (chat1, chat2) -> Bool in
                        return chat1.creationDate > chat2.creationDate
                    }
                }
            }
            
            self.collectionView.reloadData()
            self.dismissIndicatorView()
            
        }
    }
    
}
