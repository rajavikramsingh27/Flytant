//
//  SettingsVC.swift
//  Flytant
//
//  Created by Vivek Rai on 07/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "settingsTableViewCell"

class SettingsVC: UITableViewController {
    
//    MARK: - Properties
    
//    var contentText = ["About", "Analytics", "Blogs", "Monetize", "Payments", "Privacy", "Help", "Ads", "Invite", "Discover", "Log out"]
//    var contentText = ["About",  "Privacy", "Help", "Ads", "Invite", "Log out"]
//    var iconImages = ["settingsAbout", "settingsPrivacy", "settingsHelp", "settingsAds", "settingsInvite", "settingsLogout"]
    
    var contentText = ["About", "Blogs", "Subscriptions", "Privacy", "Help", "Ads", "Invite", "Log out"]
    var iconImages = ["settingsAbout", "settingsGrowth", "settingssubscription", "settingsPrivacy", "settingsHelp", "settingsAds", "settingsInvite", "settingsLogout"]
    
//    MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear viewWillAppear viewWillAppear viewWillAppear viewWillAppear viewWillAppear ")
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
        
//    MARK: - Configure Views
    
//    private func configureNavigationBar(){
//        navigationItem.title = "Settings"
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.tintColor = UIColor.white
//    }

    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Settings"
    }
    
    private func configureTableView(){
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        cell.iconImageView.image = UIImage(named: iconImages[indexPath.row])
        cell.contentLabel.text = contentText[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        //  Growth
//        if indexPath.row == 0{
//            handleGrowth()
//        }
//
//
//
        //  About
        if indexPath.row == 0{
            handleAbout()
        }
        //  Ananlytics
//        if indexPath.row == 1{
//            handleAnalytics()
//        }
        //  Blogs
        if indexPath.row == 1{
            handleBlogs()
        }
        //  Monetize
//        if indexPath.row == 3{
//            handleMonetize()
//        }
        //  Payments
        if indexPath.row == 2{
            subscriptions()
        }
        //  Privacy
        if indexPath.row == 3{
            handlePrivacy()
        }
        //  Help
        if indexPath.row == 4{
            handleHelp()
        }
        //  Ads
        if indexPath.row == 5{
            handleAds()
        }
        //  Invite
        if indexPath.row == 6{
            handleInvite()
        }
        //  Discover
//        if indexPath.row == 9{
//            handleDiscover()
//        }
        //  Logout
        if indexPath.row == 7{
            handleLogout()
        }
    }
    
    
//    MARK: - Handlers
    
    private func handleGrowth(){
        let growthVC = GrowthVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(growthVC, animated: true)
    }
    
    private func handleAnalytics(){
        let analyticsVC = AnalyticsVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(analyticsVC, animated: true)
    }
    
    private func handleMonetize(){
        let monetizeVC = MonetizeVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(monetizeVC, animated: true)
    }
    
    private func subscriptions(){
//        let vc = SubscriptionDetailsVC()
        let vc = SubscriptionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleAbout(){
       let webViewVC = WebViewVC()
       webViewVC.urlString = "https://flytant.com/about/"
       navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    private func handleBlogs(){
       let webViewVC = WebViewVC()
       webViewVC.urlString = "https://flytant.com/blogs/"
       navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    private func handlePrivacy(){
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://flytant.com/privacy/"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    private func handleHelp(){
        let helpVC = HelpVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(helpVC, animated: true)
    }
    
    private func handleAds(){
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://flytant.com/ads/"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    private func handleInvite(){
        let inviteVC = InviteVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(inviteVC, animated: true)
    }
    
    private func handleDiscover(){
        let discoverVC = DiscoverVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(discoverVC, animated: true)
    }
    
    private func handleLogout(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action) in
            UserDefaults.standard.removeObject(forKey: kUserIDFireBase)
            
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
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
}
