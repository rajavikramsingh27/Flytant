//
//  InfluencersVC.swift
//  Flytant
//
//  Created by Vivek Rai on 27/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

private let reuseIdentifier = "influencersCollectionViewCell"
private let headerIdentifier = "influencersHeader"

class InfluencersVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, InfluencersHeaderDelegate {

//    MARK: - Properties
    var trendingInfluecners = [Users]()
    var topInfluencers = [Users]()
    

//    MARK: - Views
    
    var navigationTitleView: UIView = {
        let view = UIView()
        return view
    }()
    let navigationImage = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "flytantNavigationLogo")!)
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureNavigationBar()
        configureCollectionView()
        configureRefreshControl()
        fetchTopInfluencers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationTitleView.removeFromSuperview()
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        navigationTitleView.addSubview(navigationImage)
        navigationImage.anchor(top: nil, left: navigationTitleView.leftAnchor, bottom: navigationTitleView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 120, height: 28)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "notification_bottom"), style: .done, target: self, action: #selector(handleCreateCampaign))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureCollectionView() {
        self.collectionView.register(InfluencersHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.register(InfluencersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func showIndicatorView() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    private func dismissIndicatorView() {
        activityIndicatorView.removeFromSuperview()
    }
    
    @objc private func handleNotifications() {
        print("Notifications")
    }
    
//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 2
        return CGSize(width: width, height: width + 24)
    }
    
    
    
//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topInfluencers.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! InfluencersHeader
        header.delegate = self
       
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InfluencersCollectionViewCell
        
        if !self.topInfluencers.isEmpty{
            cell.influencerIV.sd_setImage(with: URL(string: self.topInfluencers[indexPath.row].profileImageURL), completed: nil)
//            cell.influencerIV.sd_setImage(with: URL(string: self.topInfluencers[indexPath.row].profileImageURL, placeholderImage: UIImage())
            cell.usernameLabel.text = "@" + self.topInfluencers[indexPath.row].username
            cell.imageCollectionView.isHidden = true
        }
        return cell
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(self.topInfluencers[indexPath.row].linkedAccounts)
//        print(self.topInfluencers[indexPath.row].profileImageURL!)
//        let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//        socialProfileVC.user = topInfluencers[indexPath.row]
//        socialProfileVC.changeHeader = true
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationItem.backBarButtonItem = backButton
//        navigationController?.pushViewController(socialProfileVC, animated: true)
        
//        let socialProfile = SocialViewController()
//        socialProfile.profile = .influencer
//        socialProfile.user = topInfluencers[indexPath.row]
//        navigationController?.pushViewController(socialProfile, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    

//    MARK: - Handlers
    
//    @objc private func handleCreateCampaign(){
//        let createCampaignVC = CreateCampaignsVC()
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationItem.backBarButtonItem = backButton
//        navigationController?.pushViewController(createCampaignVC, animated: true)
//    }
    
    @objc private func handleCreateCampaign(){
        let createCampaignVC = NotificationVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(createCampaignVC, animated: true)
    }
    
    
    @objc func handleRefresh(){
        fetchTopInfluencers()
    }
    
    func handleSearch(for cell: InfluencersHeader) {
        print("search")
        let searchVC = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    func handleInlfluencers(for cell: InfluencersHeader, user: Users) {
        let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        socialProfileVC.user = user
        socialProfileVC.changeHeader = true
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(socialProfileVC, animated: true)
        
    }
    
//    MARK: - API
    
    
    private func fetchTopInfluencers(){
        self.topInfluencers.removeAll()
        self.showIndicatorView()
        
        USER_REF.whereField("shouldShowInfluencer", isEqualTo: true).order(by: "socialScore", descending: true).limit(to: 50).getDocuments { (snapshot, error) in
            if let _ = error{
                print("Error encountered")
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
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
                let socialScore = data["socialScore"] as? Int ?? 0
                let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
                let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [String]()
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
                if profileImageURL != DEFAULT_PROFILE_IMAGE_URL {
                    if !shouldShowTrending{
                        self.topInfluencers.append(user)
                    }
                }
                
            }
            
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.dismissIndicatorView()
            print(self.topInfluencers)
            print("Top Influencers Count: \(self.trendingInfluecners.count)")
        }
    }
}


//for family in UIFont.familyNames.sorted(){
//    let names = UIFont.fontNames(forFamilyName: family)
//    print("Family: \(family) Font Name: \(names)")
//}
//        RoundedMplus1c-Regular  RoundedMplus1c-Medium RoundedMplus1c-Bold
