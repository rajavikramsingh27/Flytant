//
//  UserShopVC.swift
//  Flytant
//
//  Created by Vivek Rai on 14/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import SwiftToast
import Firebase

private let reuseIdentifier = "userShopCollectionViewCell"
private let headerIdentifier = "shopHeader"

class UserShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ShopHeaderDeleagte {
    
//    MARK: - Properties
    var toast = SwiftToast()
    var shopPosts = [ShopPosts]()
    var userId: String?
    var storeWebsite = ""
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureNavigationBar()
        configureCollectionView()
        configureRefreshControl()
        fetchShopPosts()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(RELOAD_SHOP_DATA), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = ""
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addIcon"), style: .done, target: self, action: #selector(handleCreateShopPost))

    }
    
    private func configureCollectionView(){
        self.collectionView.register(UserShopCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UserShopHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
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
    
    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
    
        
//    MARK: - CollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 232)
    }
    
//    MARK: - CollectionView Delegates and DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if indexPath.row == shopPosts.count - 1{
                paginateShopPostsData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserShopHeader
        header.delegate = self
        configureShopDetails(for: header)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserShopCollectionViewCell
        if !shopPosts.isEmpty{
            cell.shopPosts = shopPosts[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopFeedVC = ShopFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        if let title = navigationItem.title{
            shopFeedVC.navigationTitle = title
        }else{
            shopFeedVC.navigationTitle = shopPosts[indexPath.row].storeName
        }
        shopFeedVC.scrollIndex = indexPath.row
        shopFeedVC.shopPosts = self.shopPosts
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(shopFeedVC, animated: true)
    }
    
    
//    MARK: - Handlers
    
    @objc func handleCreateShopPost(){
        let shopIconUrl = UserDefaults.standard.string(forKey: SHOP_ICON_URL) ?? ""
        let shopBannerUrl = UserDefaults.standard.string(forKey: SHOP_BANNER_URL) ?? ""
        let shopName = UserDefaults.standard.string(forKey: SHOP_NAME) ?? ""
        let shopWebsite = UserDefaults.standard.string(forKey: SHOP_WEBSITE) ?? ""

        if shopName.isEmpty || shopIconUrl.isEmpty || shopBannerUrl.isEmpty || shopWebsite.isEmpty{
            self.toast = SwiftToast(text: "Please complete your store profile before listing products.")
            self.present(self.toast, animated: true)
        }else{
            let uploadShopPostVC = UploadShopPostVC()
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(uploadShopPostVC, animated: false)
        }
        
    }
    
    @objc func reloadData(){
        self.collectionView.reloadData()
    }
    
    @objc private func handleRefresh(){
        fetchShopPosts()
    }
    
    func handleEditShopWebsite(for header: UserShopHeader) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if let userId = self.userId{
            if userId != currentUserId{
                let webViewVC = WebViewVC()
                webViewVC.urlString = self.storeWebsite
                navigationController?.pushViewController(webViewVC, animated: true)
                return
            }
        }
        let editShopVC = EditShopVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(editShopVC, animated: true)
    }
    
    func configureShopDetails(for header: UserShopHeader){
        if let userId = self.userId{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if userId != currentUserId{
                DataService.instance.fetchShopData(with: userId) { (shop) in
                    header.headerImageView.loadImage(with: shop.storeBanner)
                    header.shopIconImageView.loadImage(with: shop.storeIcon)
                    header.editShopWebsiteButton.setTitle("Visit Website", for: .normal)
                    header.editShopWebsiteButton.layer.borderColor = UIColor.label.cgColor
                    header.editShopWebsiteButton.backgroundColor = UIColor.systemRed
                    header.editShopWebsiteButton.setTitleColor(UIColor.white, for: .normal)
                    self.storeWebsite = shop.storeWebsite
                    self.navigationItem.title = shop.storeName
                }
            }
        }else{
            guard let bannerUrl = UserDefaults.standard.string(forKey: SHOP_BANNER_URL) else {return}
            guard let iconUrl = UserDefaults.standard.string(forKey: SHOP_ICON_URL) else {return}
            guard let shopName = UserDefaults.standard.string(forKey: SHOP_NAME) else {return}
            header.headerImageView.loadImage(with: bannerUrl)
            header.shopIconImageView.loadImage(with: iconUrl)
            navigationItem.title = shopName
        }
        
    }
    
    private func fetchShopPosts(){
        var userId = ""
        if let userID = self.userId{
            userId = userID
        }else{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            userId = currentUserId
        }
        showIndicatorView()
        shopPosts.removeAll()
        documents.removeAll()
        self.hasMore = true
        query = SHOP_POST_REF.limit(to: 20).whereField("userId", isEqualTo: userId)
        getShopPostsData()
    }
    
    private func getShopPostsData(){
        query.getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                return
            }
            
            guard let snapshot = snapshot else {return}
            if snapshot.documents.isEmpty{
                self.hasMore = false
                self.dismissIndicatorView()
                self.collectionView.refreshControl?.endRefreshing()
                return
            }else{
                for document in snapshot.documents{
                    let data = document.data()
                    let shopPostId = document.documentID
                    let category = data["category"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let postType = data["postType"] as? String ?? ""
                    let creationDate = data["creationDate"] as? Double ?? 0
                    let storeIcon = data["storeIcon"] as? String ?? ""
                    let imageUrls = data["imageUrls"] as? [String] ?? [String]()
                    let userId = data["userId"] as? String ?? ""
                    let storeName = data["storeName"] as? String ?? ""
                    let storeWebsite = data["productWebsite"] as? String ?? ""
                    let websiteButtonTitle = data["buttonTitle"] as? String ?? ""
                    
                    let newShopPost = ShopPosts(category: category, description: description, postType: postType, creationDate: creationDate, storeIcon: storeIcon, imageUrls: imageUrls, userId: userId, shopPostId: shopPostId, storeName: storeName, storeWebsite: storeWebsite, websiteButtonTitle: websiteButtonTitle)
                    
                    self.documents.append(document)
                    self.shopPosts.append(newShopPost)
                    self.shopPosts.sort { (post1, post2) -> Bool in
                        return post1.creationDate > post2.creationDate
                    }
                }
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
            }
        }
    }
    
    private func paginateShopPostsData(){
        query = query.start(afterDocument: documents.last!)
        getShopPostsData()
    }
    
}
