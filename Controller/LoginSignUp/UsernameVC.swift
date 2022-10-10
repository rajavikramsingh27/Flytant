//
//  UsernameVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SwiftToast
import ProgressHUD

class UsernameVC: UIViewController {
    
//    MARK: - Properties
    var phoneNumber: String?
    var toast = SwiftToast()
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    private let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyTopImage")!)
    
    private let usernameTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .roundedRect, contentType: .username, keyboardType: .alphabet, textAlignment: .left, placeholder: "Enter username")

//    private let verifyButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Check Availability", cornerRadius: 20, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
    private let verifyButton = FButton(backgroundColor: UIColor.systemBackground, title: "Check Availability", cornerRadius: 20, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
         navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
//        configureTopImageView()
        configureUsernameTextField()
        configureVerifyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.navigationItem.title = "Choose a username"
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
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

    
//    MARK: - Handlers
    
    @objc private func handleVerify(){
        showIndicatorView()
//        check username availability
        guard let usernameEntered = usernameTextField.text?.lowercased(), let userId = Auth.auth().currentUser?.uid else {self.dismissIndicatorView(); return}
        
        if usernameEntered.isAlphanumeric && usernameEntered.count > 3 && usernameEntered.count < 16{
//             USER_REF.getDocuments { (snapshot, error) in
//                    if let error = error{
//                        self.dismissIndicatorView()
//                        self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
//                        self.present(self.toast, animated: true)
//                        return
//                    }
//                    guard let snapshot = snapshot else {self.dismissIndicatorView(); return}
//                    for document in snapshot.documents{
//                        let data = document.data()
//                        let username = data["username"] as? String ?? ""
//                        if username == usernameEntered{
//                            self.toast = SwiftToast(text: "This username is already taken. Please try a new one.")
//                            self.present(self.toast, animated: true)
//                            self.dismissIndicatorView()
//                            return
//                        }
//                    }
//                    self.dismissIndicatorView()
//
//                    let alertController = UIAlertController(title: "Username Available", message: "Would you like to continue with this username", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                        self.showIndicatorView()
//                        var contactNumber = ""
//                        if let phoneNumber = self.phoneNumber{
//                            contactNumber = phoneNumber
//                        }
//                        DataService.instance.createNewUser(userID: userId, username: usernameEntered, phoneNumber: contactNumber) { (success, error) in
//                            if success{
//                                self.dismissIndicatorView()
//                                let mainTabVC = MainTabVC()
//                                self.navigationController?.pushViewController(mainTabVC, animated: true)
//                            }else{
//                                self.dismissIndicatorView()
//                                self.toast = SwiftToast(text: "An error occured while creating new user. Please try again")
//                                self.present(self.toast, animated: true)
//                            }
//                        }
//                    }))
//                    self.present(alertController, animated: true, completion: nil)
//                }
            
            
            USER_REF.whereField("username", isEqualTo: usernameEntered).getDocuments { (snapshot, error) in
                if let error = error{
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
                    self.present(self.toast, animated: true)
                    return
                }
                guard let snapshot = snapshot else {return}
                if snapshot.isEmpty{
                    let alertController = UIAlertController(title: "Username Available", message: "Would you like to continue with this username", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                        self.dismissIndicatorView()
                    }))
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.showIndicatorView()
                        var contactNumber = ""
                        if let phoneNumber = self.phoneNumber{
                            contactNumber = phoneNumber
                        }
                        DataService.instance.createNewUser(userID: userId, username: usernameEntered, phoneNumber: contactNumber) { (success, error) in
                            if success{
                                self.dismissIndicatorView()
                                let mainTabVC = MainTabVC()
                                self.navigationController?.pushViewController(mainTabVC, animated: true)
                            }else{
                                self.dismissIndicatorView()
                                self.toast = SwiftToast(text: "An error occured while creating new user. Please try again")
                                self.present(self.toast, animated: true)
                            }
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    ProgressHUD.showError("This username is already taken. Please try a new one.")
                    self.toast = SwiftToast(text: "This username is already taken. Please try a new one.")
                    self.present(self.toast, animated: true)
                    self.dismissIndicatorView()
                    return
                }
            }
        }else{
            dismissIndicatorView()
            ProgressHUD.showError("Invalid username entered. Username must be alphanumeric and 4 to 15 charcters long.")
            self.toast = SwiftToast(text: "Invalid username entered. Username must be alphanumeric and 4 to 15 charcters long.")
            self.present(self.toast, animated: true)
        }
       
    }
    
    private func configureTopImageView(){
        view.addSubview(topImageView)
        topImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 64)
        topImageView.contentMode = .redraw
    }
    
    private func configureUsernameTextField(){
        view.addSubview(usernameTextField)
        usernameTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 240, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
    
    private func configureVerifyButton(){
        view.addSubview(verifyButton)
        verifyButton.anchor(top: usernameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        verifyButton.addTarget(self, action: #selector(handleVerify), for: .touchUpInside)
        verifyButton.layer.borderColor = UIColor.label.cgColor
        verifyButton.layer.borderWidth = 1
    }
    
}

