//
//  MessageVC.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "messageTableViewCell"

class MessageVC: UITableViewController {
    
//    MARK: - Properties
    var message = [Message]()
    var messageDictionary = [String: Message]()
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        observeMessages()
//        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "createShopPostIcon"), style: .plain, target: self, action: #selector(handleSearchUsers))
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func configureTableView(){
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
//    private func configureRefreshControl(){
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        tableView?.refreshControl = refreshControl
//    }
    

//    MARK: - TableView Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let message = self.message[indexPath.row]
        let chatPartnerId = message.getChatPartnerId()
        
        USER_MESSAGES_REF.child(uid).child(chatPartnerId).removeValue { (err, ref) in
            
            self.message.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageTableViewCell
        cell.delegate = self
        cell.message = message[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.message[indexPath.row]
        DataService.instance.fetchPartnerUser(with: message.getChatPartnerId()) { (user) in
            self.showChatController(forUser: user)
        }
    }
    
//    MARK: - Handlers
    
//    @objc private func handleRefresh(){
//        observeMessages()
//    }
    
    @objc private func handleSearchUsers(){
        let newMessageVC = NewMessageVC()
        newMessageVC.messageVC = self
        let navigationController = UINavigationController(rootViewController: newMessageVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChatController(forUser user: Users){
//        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
//        chatVC.user = user
//        navigationController?.pushViewController(chatVC, animated: true)
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
    
// MARK: - API

    func observeMessages(){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
        self.message.removeAll()
        self.messageDictionary.removeAll()
        self.tableView.reloadData()
        
        USER_MESSAGES_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            USER_MESSAGES_REF.child(currentUid).child(uid).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessage(withMessageId: messageId)
            })
        }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        showIndicatorView()
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let message = Message(dictionary: dictionary)
            let chatPartnerId = message.getChatPartnerId()
            self.messageDictionary[chatPartnerId] = message
            self.message = Array(self.messageDictionary.values)
            
            self.message.sort(by: { (message1, message2) -> Bool in
                return message1.creationDate > message2.creationDate
            })
            self.dismissIndicatorView()
            self.tableView.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
}

extension MessageVC: MessageCellDelegate {
    
    func configureUserData(for cell: MessageTableViewCell) {
        guard let chatPartnerId = cell.message?.getChatPartnerId() else { return }
        DataService.instance.fetchPartnerUser(with: chatPartnerId) { (user) in
            cell.profileImageView.loadImage(with: user.profileImageURL)
            cell.usernameLabel.text = user.username
        }
    }
}
