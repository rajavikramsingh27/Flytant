//
//  HelpVC.swift
//  Flytant
//
//  Created by Vivek Rai on 28/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework

private let reuseIdentifier = "helpTableViewCell"

class HelpVC: UITableViewController {
    
//    MARK: - Properties
    var contentText = ["General Feedback", "App Functionality", "Payments & Transfer", "Troubleshooting", "Security Help", "Privacy Related", "Content Quality", "Spam or Abuse", "Something Else"]
    var iconImages = ["generalFeedback", "appFunctionality", "payment", "troubleShooting", "security", "privacy", "contentQuality", "spamAndAbuse", "somethingElse"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureTableView()
        
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
        navigationItem.title = "Help"
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
        let feedbackVC = FeedbackVC()
        feedbackVC.issueDescription = contentText[indexPath.row]
        present(UINavigationController(rootViewController: feedbackVC), animated: true, completion: nil)
    }
    
    
    
}





























//
//import UIKit
//import FBAudienceNetwork
//import ChameleonFramework
//
//class HelpVC: UIViewController, FBNativeAdDelegate {
//
////    MARK: - Properties
//    var nativeAd: FBNativeAd?
//    var adUIView = UIView()
//    var adIConImageView = FBAdIconView()
//    var adTitleLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
//    var adCoverMediaView = FBMediaView()
//    var adSponsoredLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.secondaryLabel)
//    var adOptionView = FBAdOptionsView()
//    var adCallToAction = FButton(backgroundColor: UIColor.randomFlat(), title: "", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 14))
//    var adBodyLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.label)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground
//
//        configureViews()
//        let hashId = FBAdSettings.testDeviceHash()
//        FBAdSettings.addTestDevice(hashId)
//        nativeAd = FBNativeAd(placementID: "601602877150235_618706458773210")
//        nativeAd?.delegate = self
//        nativeAd?.loadAd()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        configureNavigationBar()
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        tabBarController?.tabBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//        tabBarController?.tabBar.isHidden = false
//    }
//
////    MARK: - Configure Views
//
//    private func configureNavigationBar(){
//        navigationItem.title = "Help"
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.tintColor = UIColor.white
//    }
//
//    private func configureViews(){
//        view.addSubview(adUIView)
//        adUIView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width + 100)
//        adUIView.backgroundColor = UIColor.systemPink
//
//        adUIView.addSubview(adIConImageView)
//        adIConImageView.anchor(top: adUIView.topAnchor, left: adUIView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
//        adIConImageView.layer.cornerRadius = 20
//        adIConImageView.backgroundColor = UIColor.systemYellow
//
//        adUIView.addSubview(adTitleLabel)
//        adTitleLabel.anchor(top: adIConImageView.topAnchor, left: adIConImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 200, height: 16)
//
//        adUIView.addSubview(adCoverMediaView)
//        adCoverMediaView.anchor(top: adIConImageView.bottomAnchor, left: adUIView.leftAnchor, bottom: nil, right: adUIView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
//        adCoverMediaView.backgroundColor = UIColor.systemGray
//
//        adUIView.addSubview(adSponsoredLabel)
//        adSponsoredLabel.anchor(top: adTitleLabel.bottomAnchor, left: adIConImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 200, height: 12)
//
//        adUIView.addSubview(adOptionView)
//        adOptionView.anchor(top: adUIView.topAnchor, left: nil, bottom: nil, right: adUIView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
//        adOptionView.backgroundColor = UIColor.clear
//        adOptionView.foregroundColor = UIColor.systemOrange
//
//        adUIView.addSubview(adCallToAction)
//        adCallToAction.anchor(top: adCoverMediaView.bottomAnchor, left: adUIView.leftAnchor, bottom: nil, right: adUIView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
//
//        adUIView.addSubview(adBodyLabel)
//        adBodyLabel.anchor(top: adCallToAction.bottomAnchor, left: adUIView.leftAnchor, bottom: nil, right: adUIView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
//        adBodyLabel.numberOfLines = 0
//    }
//
////    MARK: - FBAds
//
//    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
//        self.nativeAd = nativeAd
//        showNativeAds()
//    }
//
//    private func showNativeAds(){
//        if (nativeAd != nil) && ((nativeAd?.isAdValid) != nil){
//            nativeAd?.unregisterView()
//
//            nativeAd?.registerView(forInteraction: adUIView, mediaView: adCoverMediaView, iconView: adIConImageView, viewController: self, clickableViews: [adCallToAction])
//
//            adTitleLabel.text = nativeAd?.advertiserName
//
//            adSponsoredLabel.text = nativeAd?.sponsoredTranslation
//
//            adOptionView.nativeAd = nativeAd
//
//            adBodyLabel.text = nativeAd?.bodyText
//
//            guard let callToActionText = nativeAd?.callToAction else {return}
//            adCallToAction.setTitle("  \(callToActionText)", for: .normal)
//            adCallToAction.contentHorizontalAlignment = .left
//        }
//    }
//
//    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
//        debugPrint(error.localizedDescription)
//    }
//
//}
