//
//  ChatsVC.swift
//  Flytant
//
//  Created by Vivek Rai on 06/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ProgressHUD
import FirebaseFirestore
import MessageUI
import ProgressHUD

private let reuseIdentifier = "chatsCollectionViewCell"
private let contactsReuseIdentifier = "contactsCollectionViewCell"
private let callsReuseIdentifier = "callsCollectionViewCell"
private let headerIdentifier = "chatsHeader"

class ChatsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ChatsHeaderDelegate, AnonymousLoginViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate {

//    MARK: - Properties
    
    var chats = [Chats]()
    var chatCalls = [ChatCalls]()
    var chatContacts = [ChatContacts]()
    var contactStore = CNContactStore()
    var selectedView = "chats"
    var inSearchMode = false
    var filteredChats = [Chats]()
    var filteredChatCalls = [ChatCalls]()
    var filteredChatContacts = [ChatContacts]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var callListener: ListenerRegistration!
    
    
//    MARK: - Views
    
    private var anonymousView = AnonymousView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configureCollectionView()
        requestContactsPermission()
        fetchRecentChats()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureNavigationBar()
        fetchCalls()
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        callListener.remove()
        //navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "createShopPostIcon"), style: .plain, target: self, action: #selector(handleAddUser))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureCollectionView(){
        self.collectionView.register(ChatsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ChatsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
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
        
        if selectedView == "chats"{
            if inSearchMode{
                return filteredChats.count
            }else{
                return chats.count
            }
        }
        
        if selectedView == "contacts"{
            if inSearchMode{
                return filteredChatContacts.count
            }else{
                return chatContacts.count
            }
        }
        
        if selectedView == "calls"{
            if inSearchMode{
                return filteredChatCalls.count
            }else{
                return chatCalls.count
            }
        }
        
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ChatsHeader
        header.delegate = self
        header.searchBar.delegate = self
        if selectedView == "chats"{
            header.searchBar.placeholder = "Search by name or username"
        }else if selectedView == "calls"{
            header.searchBar.placeholder = "Search by caller name"
        }else{
            header.searchBar.placeholder = "Search by name or number"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = view.frame.width/4 + 40
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedView == "chats"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatsCollectionViewCell
            if inSearchMode{
                if !filteredChats.isEmpty{
                    cell.chat = self.filteredChats[indexPath.row]
                }
            }else{
                if !chats.isEmpty{
                    cell.chat = self.chats[indexPath.row]
                }
            }
            return cell
        }
        
        if selectedView == "contacts"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contactsReuseIdentifier, for: indexPath) as! ContactsCollectionViewCell
            if inSearchMode{
                cell.chatContacts = filteredChatContacts[indexPath.row]
            }else{
                cell.chatContacts = chatContacts[indexPath.row]
            }
            return cell
        }
        
        if selectedView == "calls"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: callsReuseIdentifier, for: indexPath) as! CallsCollectionViewCell
            if inSearchMode{
                cell.chatCalls = filteredChatCalls[indexPath.row]
            }else{
                cell.chatCalls = chatCalls[indexPath.row]
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedView == "chats"{
            var selectedChats = [Chats]()
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
        
        if selectedView == "calls"{
            var selectedCall = [ChatCalls]()
            if inSearchMode{
                selectedCall = filteredChatCalls
            }else{
                selectedCall = chatCalls
            }
            handleCall(chatCall: selectedCall[indexPath.row])
            
        }
        
        if selectedView == "contacts"{
            var selectedContacts = [ChatContacts]()
            if inSearchMode{
                selectedContacts = filteredChatContacts
            }else{
                selectedContacts = chatContacts
            }
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                if let url = URL(string: "tel://\(selectedContacts[indexPath.row].contactNumber ?? "")"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }else{
                    ProgressHUD.showError("Error while calling. Seems like the country code is not present in the contact!")
                }
            }))
            alertController.addAction(UIAlertAction(title: "Invite", style: .default, handler: { (action) in
                if (MFMessageComposeViewController.canSendText()) {
                    guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
                    let shareText = "Hi there, I am on Flytant as \(username). Come and join me to expereince the next gen of social media."
                    let controller = MFMessageComposeViewController()
                    controller.body = shareText
                    controller.recipients = [selectedContacts[indexPath.row].contactNumber]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }else{
                    print("Cannot send the message")
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            }))
            present(alertController, animated: true)
        }
                
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
    private func requestContactsPermission(){
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success{
                self.fetchContacts()
            }else{
                ProgressHUD.showError("Please give the app permission to access contacts in the settings.")
            }
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
    
//    MARK: - MFMessageDelegaet
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
//    MARK: - SearchBar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.searchTextField.text?.lowercased() else {return}
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            collectionView.reloadData()
        } else {
            inSearchMode = true
            if selectedView == "chats"{
                filteredChats = chats.filter({ (chat) -> Bool in
                    return chat.withUsername.contains(searchText) || chat.lastMessage.contains(searchText)
                })
            }else if selectedView == "calls"{
                filteredChatCalls = chatCalls.filter({ (call) -> Bool in
                    return call.withUserName.contains(searchText)
                })
            }else if selectedView == "contacts"{
                filteredChatContacts = chatContacts.filter({ (contact) -> Bool in
                    return contact.firstName.contains(searchText) || contact.lastName.contains(searchText) || contact.contactNumber.contains(searchText)
                })
            }
            
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.resignFirstResponder()
    }
    
//    MARK: - Handlers
    
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
    
    private func callClient() -> SINCallClient?{
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
        return sceneDelegate.client.call()
    }
    
    private func callUser(chatCall: ChatCalls){
        //guard let userId = self.userId else {return}
        guard let userId = chatCall.withUserId else {return}
        let call = callClient()?.callUser(withId: userId)
        let callVC = CallVC()
        callVC.call = call
        let navController = UINavigationController(rootViewController: callVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    private func handleCall(chatCall: ChatCalls){
        //guard let userId = self.userId else {return}
        guard let userId = chatCall.withUserId else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let currentUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            let call = ChatCalls(callerId: currentUserId, callerName: currentUsername, withUserName: user.username, withUserId: userId)
            call.saveCall()
            self.callUser(chatCall: chatCall)
        }
    }
    
    @objc private func handleAddUser(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let searchUsersVC = SearchUsersVC(collectionViewLayout: UICollectionViewFlowLayout())
            searchUsersVC.chatsVC = self
            self.present(UINavigationController(rootViewController: searchUsersVC), animated: true)
        }
    }
    
    func handleChats(for header: ChatsHeader) {
        selectedView = "chats"
        self.collectionView.register(ChatsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        header.chatImageView.image = UIImage(named: "chatViewPagerColored")
        header.chatBottomView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        header.callImageView.image = UIImage(named: "callViewPager")
        header.callBottomView.backgroundColor = UIColor.systemBackground
        header.contactsImageView.image = UIImage(named: "contactsViewPager")
        header.contactsBottomView.backgroundColor = UIColor.systemBackground
        header.settingsImageView.image = UIImage(named: "settingsViewPager")
        header.settingsBottomView.backgroundColor = UIColor.systemBackground
        self.collectionView.reloadData()
    }
    
    func handleCalls(for header: ChatsHeader) {
        selectedView = "calls"
        self.collectionView.register(CallsCollectionViewCell.self, forCellWithReuseIdentifier: callsReuseIdentifier)
        header.chatImageView.image = UIImage(named: "chatViewPager")
        header.chatBottomView.backgroundColor = UIColor.systemBackground
        header.callImageView.image = UIImage(named: "callViewPagerColored")
        header.callBottomView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        header.contactsImageView.image = UIImage(named: "contactsViewPager")
        header.contactsBottomView.backgroundColor = UIColor.systemBackground
        header.settingsImageView.image = UIImage(named: "settingsViewPager")
        header.settingsBottomView.backgroundColor = UIColor.systemBackground
        self.collectionView.reloadData()
    }
    
    func handleContacts(for header: ChatsHeader) {
        selectedView = "contacts"
        self.collectionView.register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: contactsReuseIdentifier)
        header.chatImageView.image = UIImage(named: "chatViewPager")
        header.chatBottomView.backgroundColor = UIColor.systemBackground
        header.callImageView.image = UIImage(named: "callViewPager")
        header.callBottomView.backgroundColor = UIColor.systemBackground
        header.contactsImageView.image = UIImage(named: "contactsViewPagerColored")
        header.contactsBottomView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        header.settingsImageView.image = UIImage(named: "settingsViewPager")
        header.settingsBottomView.backgroundColor = UIColor.systemBackground
        self.collectionView.reloadData()
    }
    
    func handleSettings(for header: ChatsHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let chatSettings = ChatSettings()
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(chatSettings, animated: true)
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
    
    private func fetchContacts(){
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do{
            try contactStore.enumerateContacts(with: request){ (contact, stoppingPointer) in
                   let firstName = contact.givenName
                   let lastName = contact.familyName
                   let contactNumber = contact.phoneNumbers.first?.value.stringValue
                   
                   let contactToAppend = ChatContacts(firstName: firstName, lastName: lastName, contactNumber: contactNumber ?? "")
                   self.chatContacts.append(contactToAppend)
            
               }
        }catch{
            ProgressHUD.showError("Unable to get your contacts")
        }
        
        if Thread.current.isMainThread {
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
       
        
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
            self.filteredChats.removeAll()
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
    
    private func fetchCalls(){
        chatCalls.removeAll()
        filteredChatCalls.removeAll()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        callListener = CALL_REF.document(currentUserId).collection(currentUserId).order(by: "callDate", descending: true).limit(to: 20).addSnapshotListener({ (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty{
                let sortedDictionary = ChatService.instance.dictionaryFromSnapshots(snapshots: snapshot.documents)
                for callDictionary in sortedDictionary{
                    let call = ChatCalls(dictionary: callDictionary)
                    self.chatCalls.append(call)
                }
            }
            self.collectionView.reloadData()
        })
    }
    
}
