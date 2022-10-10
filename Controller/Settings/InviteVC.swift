//
//  InviteVC.swift
//  Flytant
//
//  Created by Vivek Rai on 28/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Social
import SwiftToast
import FBSDKShareKit
import MessageUI
import ProgressHUD

private let reuseIdentifier = "inivteTableViewCell"

class InviteVC: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

//    MARK: - Properties
    var contentText = ["WhatsApp", "Facebook", "Twitter", "Email", "SMS", "Share"]
    var iconImages = ["whatsapp", "facebook", "twitter", "email", "sms", "share"]
    var shareText = ""
    var toast = SwiftToast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        configureTableView()
        
        configureShareText()
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
        navigationItem.title = "Invite"
    }


    private func configureTableView(){
        tableView.register(HelpTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
    }

//    MARK: - TableView Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentText.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HelpTableViewCell
        cell.iconImageView.image = UIImage(named: iconImages[indexPath.row])
        cell.contentLabel.text = contentText[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            whatsappInvite()
        }
        
        if indexPath.row == 1{
            facebookInvite()
        }
        
        if indexPath.row == 2{
            twitterInvite()
        }
        
        if indexPath.row == 3{
            emailInvite()
        }
        
        if indexPath.row == 4{
            smsInvite()
        }
        
        if indexPath.row == 5{
            shareInvite()
        }
        
    }
    
    private func configureShareText(){
        guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
        shareText = "Hi there, I am on Flytant as \(username). Come and join me to expereince the next gen of social media."
    }
    
    private func whatsappInvite(){
        let escapedString = shareText.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }else{
            ProgressHUD.showError("Seems like Whatsapp is not insatlled on your device!")
        }
    }
    
    private func facebookInvite(){
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText(shareText)
            vc.add(URL(string: "https://flytant.com"))
            present(vc, animated: true)
        }else{
            ProgressHUD.showError("Seems like Facebook is not insatlled on your device!")
        }
    }

    private func twitterInvite(){
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText(shareText)
            vc.add(URL(string: "https://flytant.com"))
            present(vc, animated: true)
        }else{
            ProgressHUD.showError("Seems like Twitter is not insatlled on your device!")
        }
    }
    
    private func smsInvite(){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = shareText
//        controller.recipients = ["1234567890"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            ProgressHUD.showError("Unable to send message!")
        }
        
    }
    
    private func shareInvite(){
        let url = NSURL(string:"https://flytant.com")
        let shareAll = [shareText , url!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func emailInvite(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
//          mail.setToRecipients(["abc@gmail.com","xyz@gmail.com"])
            mail.setMessageBody("<h2>\(shareText)<h2>", isHTML: true)
            present(mail, animated: true)
        } else {
            ProgressHUD.showError("Unable to send email!")
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}





