//
//  ShopFeedVC.swift
//  Flytant
//
//  Created by Vivek Rai on 22/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SwiftToast
import FBAudienceNetwork

private let reuseIdentifier = "shopFeedCollectionViewCell"

class ShopFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ShopFeedCellDelegate, FBNativeAdDelegate, FBNativeAdsManagerDelegate {

//    MARK: - Properties
    var shopPosts = [ShopPosts]()
    var navigationTitle = ""
    var userId: String?
    var scrollIndex: Int?
    var typeVC = ""
    var toast = SwiftToast()
    
//    MARK: - Ads
    let adRowStep = 4
    var adsManager: FBNativeAdsManager!
    var adsCellProvider: FBNativeAdCollectionViewCellProvider!
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
        configureRefreshControl()
        
        fetchShopPosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - Ads Methods
    
    func configureAdManagerAndLoadAds() {
        let hashId = FBAdSettings.testDeviceHash()
        FBAdSettings.addTestDevice(hashId)
        if adsManager == nil {
            adsManager = FBNativeAdsManager(placementID: "601602877150235_619301165380406", forNumAdsRequested: 10)
            adsManager.delegate = self
            adsManager.loadAds()
        }
    }
    
    func nativeAdsLoaded() {
        adsCellProvider = FBNativeAdCollectionViewCellProvider(manager: adsManager, for: FBNativeAdViewType.genericHeight400)
        adsCellProvider.delegate = self
        if collectionView != nil{
            collectionView.reloadData()
        }
    }
    
    func nativeAdsFailedToLoadWithError(_ error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func nativeAdDidClick(_ nativeAd: FBNativeAd) {
        
    }
    
//    MARK: - ConfigureViews
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        if typeVC == "shop"{
            navigationItem.title = "Listings"
        }else{
            navigationItem.title = navigationTitle
        }
    }
    
    private func configureCollectionView(){
        self.collectionView.register(ShopFeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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

    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
    
//    MARK: - Handlers
    
    @objc private func handleRefresh(){
        fetchShopPosts()
    }
    
    func handleWebsiteButtonTapped(for cell: ShopFeedCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let webViewVC = WebViewVC()
        webViewVC.urlString = self.shopPosts[indexPath.row - Int(indexPath.row/adRowStep)].storeWebsite
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    func handleThreeDotTapped(for cell: ShopFeedCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let postUserId = self.shopPosts[indexPath.row - Int(indexPath.row/adRowStep)].userId else {return}
        if currentUserId == postUserId{
            showAlertForCurrentUser(index: indexPath.row - Int(indexPath.row/adRowStep))
        }else{
            showAlertForOtherUser(index: indexPath.row - Int(indexPath.row/adRowStep))
        }
    }
    
    func handleShopNameTapped(for cell: ShopFeedCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        openShopProfile(index: indexPath.row - Int(indexPath.row/adRowStep))
    }
    
    func handleSlideShowTapped(for cell: ShopFeedCollectionViewCell) {
        cell.slideShow.presentFullScreenController(from: self)
    }
    
    func handleActiveLabelShopNameTapped(for cell: ShopFeedCollectionViewCell, shopName: String) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        openShopProfile(index: indexPath.row - Int(indexPath.row/adRowStep))
    }
    
    private func openShopProfile(index: Int){
        let userShopVC = UserShopVC(collectionViewLayout: UICollectionViewFlowLayout())
        userShopVC.userId = self.shopPosts[index].userId
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(userShopVC, animated: true)
    }
    
    private func showAlertForCurrentUser(index: Int){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (action) in
            self.editShopPost(index: index)
        }))
        alertVC.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (action) in
            let alertVCInside = UIAlertController(title: "Delete", message: "Do you want to delete this product?", preferredStyle: .alert)
            alertVCInside.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                self.deleteShopPost(index: index)

            }))
            alertVCInside.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertVCInside, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func showAlertForOtherUser(index: Int){
        let alertVCInside = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVCInside.addAction(UIAlertAction(title: "Report Product", style: .destructive, handler: { (action) in
            self.reportPost(index: index)
        }))
        alertVCInside.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVCInside, animated: true, completion: nil)
    }
    
    private func reportPost(index: Int){
        let alertVC = UIAlertController(title: nil, message: "Do you want to report this product?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
            guard let userId = self.shopPosts[index].userId else {return}
            guard let storeName = self.shopPosts[index].storeName else {return}
            let reportData = [DataService.instance.randomString(length: 20): ["userId": userId, "storeName": storeName, "creationDate": self.shopPosts[index].creationDate.timeIntervalSince1970]]
            REPORT_REF.document("reportedProducts").setData(reportData, merge: true)
            self.toast = SwiftToast(text: "You have reported \(storeName)'s product!")
            self.present(self.toast, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if adsCellProvider != nil && adsCellProvider.isAdCell(at: indexPath, forStride: UInt(adRowStep)){
            return CGSize(width: view.frame.width, height: adsCellProvider.collectionView(collectionView, heightForRowAt: indexPath))
        }else{
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            let dummyCell = ShopFeedCollectionViewCell(frame: frame)
            dummyCell.shopPosts = shopPosts[indexPath.item - Int(indexPath.row/adRowStep)]
            dummyCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
            let height = max(40 + 8 + 8, estimatedSize.height)
            return CGSize(width: view.frame.width, height: height)
        }
        
    }
        
    

//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if adsCellProvider != nil{
            return Int(adsCellProvider.adjustCount(UInt(shopPosts.count), forStride: UInt(adRowStep)))
        }else{
            return shopPosts.count
        }
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if adsCellProvider != nil && adsCellProvider.isAdCell(at: indexPath, forStride: UInt(adRowStep)){
            return adsCellProvider.collectionView(collectionView, cellForItemAt: indexPath)
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopFeedCollectionViewCell
            cell.delegate = self
            if !shopPosts.isEmpty{
                cell.shopPosts = shopPosts[indexPath.row - Int(indexPath.row/adRowStep)]
            }
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
//    MARK: - API
    
    private func fetchShopPosts(){
        
        guard let scrollIndex = self.scrollIndex else {return}
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(item: scrollIndex + Int(scrollIndex/adRowStep), section: 0), at: .top, animated: false)
        self.collectionView.refreshControl?.endRefreshing()
        self.configureAdManagerAndLoadAds()
        
    }
    
    private func deleteShopPost(index: Int){
        showIndicatorView()
        guard let shopPostId = self.shopPosts[index].shopPostId else {return}
        guard let imageUrls = self.shopPosts[index].imageUrls else {return}
        
        SHOP_POST_REF.document(shopPostId).delete { (error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            imageUrls.forEach { (url) in
                Storage.storage().reference(forURL: url).delete(completion: nil)
            }
            self.shopPosts.remove(at: index)
            self.toast = SwiftToast(text: "Your post has been deleted successfully.")
            self.present(self.toast, animated: true)
            self.collectionView.reloadData()
            self.dismissIndicatorView()
        }
        
        
    }
    
    private func editShopPost(index: Int){
        let editShopPostVC = EditShopPostVC()
        editShopPostVC.imageUrls = self.shopPosts[index].imageUrls
        editShopPostVC.buttonTitle = self.shopPosts[index].websiteButtonTitle
        editShopPostVC.websiteLink = self.shopPosts[index].storeWebsite
        editShopPostVC.postDescription = self.shopPosts[index].description
        editShopPostVC.postId = self.shopPosts[index].shopPostId
        editShopPostVC.category = self.shopPosts[index].category
        self.present(UINavigationController(rootViewController: editShopPostVC), animated: true)
    }

}
