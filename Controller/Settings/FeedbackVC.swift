//
//  FeedbackVC.swift
//  Flytant
//
//  Created by Vivek Rai on 03/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SwiftToast

class FeedbackVC: UIViewController, UITextViewDelegate {
    
//    MARK: - Properties
    var issueDescription: String?
    var toast = SwiftToast()
    
//    MARK: - Views
    let profileImageView = FImageView(backgroundColor: UIColor.randomFlat(), cornerRadius: 14, image: UIImage())
    let issueLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: .label)
  
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.label
        tv.backgroundColor = UIColor.secondarySystemBackground
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        return tv
    }()
    
    let placeholderLabel = FLabel(backgroundColor: UIColor.clear, text: "Briefly explain the issue you encountered.", font: UIFont.systemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.systemGray)
    
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
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
        navigationItem.title = "Feedback"
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(handleSend))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    
    private func configureViews(){
        guard let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        profileImageView.loadImage(with: profileImageUrl)
        
        guard let issueDescription = self.issueDescription else {return}
        view.addSubview(issueLabel)
        issueLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        issueLabel.text = issueDescription
        
        descriptionTextView.delegate = self
        descriptionTextView.becomeFirstResponder()
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 200)
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: descriptionTextView.topAnchor, left: descriptionTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 300, height: 18)
        
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
    
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSend(){
        guard let issue = self.issueDescription else {return}
        guard let descriptionText = descriptionTextView.text else {return}
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
        if !descriptionText.isEmpty{
            showIndicatorView()
            let documentData = ["issue": issue, "description": descriptionText, "userId": userId, "username": username]
            HELP_REF.document().setData(documentData, merge: true) { (error) in
                if let _ = error{
                    self.dismissIndicatorView()
                    return
                }
                self.toast = SwiftToast(text: "Thank You for reporting the issue. We will look into it and resolve it ASAP.")
                self.present(self.toast, animated: true)
                self.dismissIndicatorView()
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            placeholderLabel.isHidden = false
        }
        if textView.text.count > 0 {
            placeholderLabel.isHidden = true
        }
        if textView.text.count > 120{
            textView.font = UIFont.systemFont(ofSize: 16)
        }
        if textView.text.count > 240{
            textView.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
}
