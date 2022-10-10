//
//  ShopVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "exploreCell"
private let headerIdentifier = "exploreHeader"

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, AnonymousLoginViewDelegate{
    
    
//    MARK: - Properties
    var shopPosts = [ShopPosts]()
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var hasMore = true
    
//    MARK: - Views
    
    private var anonymousView = AnonymousView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configureCollectionView()
        
        configureRefreshControl()
        
        fetchShopPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureNavigationBar()
    }

    
//    MARK: - Configure Views
    private func configureNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Shop"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "myShopIcon"), style: .done, target: self, action: #selector(handleMyShop))

    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 56, left: 8, bottom: 8, right: 8)
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
    
    func handleLogin() {
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
    }
    
    func handleCancel() {
        removeAnonymousView()
    }

    @objc func handleRefresh(){
        fetchShopPosts()
    }
    
    @objc func handleMyShop(){
        let userShopVC = UserShopVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(userShopVC, animated: true)
    }
    
//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width = (view.frame.width - 2) / 2
       return CGSize(width: width-8, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCollectionViewCell
        if !shopPosts.isEmpty{
            cell.shopPosts = shopPosts[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let shopFeedVC = ShopFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            shopFeedVC.typeVC = "shop"
            shopFeedVC.scrollIndex = indexPath.row
            shopFeedVC.shopPosts = self.shopPosts
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(shopFeedVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hasMore{
            if indexPath.row == shopPosts.count - 1{
                paginateShopPosts()
            }
        }
    }
    
//    MARK: - API
    
    private func fetchShopPosts(){
        showIndicatorView()
        shopPosts.removeAll()
        documents.removeAll()
        self.hasMore = true
        query = SHOP_POST_REF.limit(to: 20)
        getShopPostsData()
    }
    
    private func getShopPostsData(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        query.getDocuments { (snapshot, error) in
            if let _ =  error{
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.documents.isEmpty{
                self.hasMore = false
                self.collectionView.refreshControl?.endRefreshing()
                self.dismissIndicatorView()
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
                    if currentUserId != userId{
                        self.documents.append(document)
                        self.shopPosts.append(newShopPost)
                        self.shopPosts.sort { (post1, post2) -> Bool in
                            return post1.creationDate > post2.creationDate
                        }
                    }
                 }
            }
            
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.dismissIndicatorView()
        }
    }
    
    private func paginateShopPosts(){
        query = query.start(afterDocument: documents.last!)
        getShopPostsData()
    }
}

