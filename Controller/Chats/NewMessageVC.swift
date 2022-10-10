//
//  NewMessageVC.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import UIKit
import Firebase

private let reuseIdentifier = "newMessageTableViewCell"

class NewMessageVC: UITableViewController {

//    MARK: - Properties
    
    var users = [Users]()
    var messageVC: MessageVC?
    
//    MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "New Message"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func configureTableView(){
        tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    

//    MARK: - TableView Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageTableViewCell
        cell.profileImageView.loadImage(with: users[indexPath.row].profileImageURL)
        cell.usernameLabel.text = users[indexPath.row].username
        cell.nameLabel.text = users[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messageVC?.showChatController(forUser: user)
        }
    }
    
//    MARK: - Handlers
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
//    MARK: - API
    
    private func fetchUsers(){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        USER_REF.getDocuments { (snapshot, error) in
            if let _ = error{
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
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                
                let newUser = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
                if currentUserID != userID{
                    self.users.append(newUser)
                }
                
            }
            
            self.tableView.reloadData()
        }
    }
}
