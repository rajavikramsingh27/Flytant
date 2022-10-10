//
//  HubVC.swift
//  Flytant
//
//  Created by Vivek Rai on 14/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class HubVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AnonymousLoginViewDelegate {

//    MARK: - Properties
    
    var previousIndex = 0
    var nextIndex = 0
    var currentIndex = 0
    
    private var anonymousView = AnonymousView()
    
    lazy var viewControllerList: [UIViewController] = {
        let exploreVC = ExploreVC(collectionViewLayout: UICollectionViewFlowLayout())
        let shopVC = ShopVC(collectionViewLayout: UICollectionViewFlowLayout())
        return [exploreVC, shopVC]
    }()
    
//    MARK: - Views
    
    let navBarView = UIView()
    let navLabel = FLabel(backgroundColor: UIColor.clear, text: "Explore", font: UIFont.boldSystemFont(ofSize: 24), textAlignment: .left, textColor: UIColor.white)
    let navBarImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "naviagationTopImage")!)
    
    let createShopButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
    let searchButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
    
    let exploreImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "hubExplore")!)
    let shopImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "hubShop")!)
    let exploreIndicatorView = UIView()
    let shopIndicatorView = UIView()
    let exploreView = UIView()
    let shopView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configurePageViewController()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        configureNavBarViews()
        configureNavigationHeader(index: currentIndex)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarView.removeFromSuperview()
    }
    
    
//    MARK: - Configure Views

    private func configurePageViewController(){
        self.dataSource = self
        self.delegate = self
        if let firstVC = viewControllerList.first{
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    private func configureNavBarViews(){
        navigationController?.navigationBar.addSubview(navBarView)
        navBarView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        navBarView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: -48, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        navBarView.addSubview(navBarImageView)
        navBarImageView.anchor(top: navBarView.topAnchor, left: navBarView.leftAnchor, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        navBarView.addSubview(navLabel)
        navLabel.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 32)
        
        navBarView.addSubview(searchButton)
        searchButton.setImage(UIImage(named: "searchHub"), for: .normal)
        searchButton.anchor(top: navigationController?.navigationBar.topAnchor, left: nil, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 32, height: 32)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        navBarView.addSubview(createShopButton)
        createShopButton.setImage(UIImage(named: "myShopIcon"), for: .normal)
        createShopButton.anchor(top: navigationController?.navigationBar.topAnchor, left: nil, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 32, height: 32)
        createShopButton.addTarget(self, action: #selector(handleOpenShop), for: .touchUpInside)
        createShopButton.isHidden = true
        
        navBarView.addSubview(exploreView)
        exploreView.anchor(top: nil, left: navBarView.leftAnchor, bottom: navBarView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

        navBarView.addSubview(shopView)
        shopView.anchor(top: nil, left: nil, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

        exploreView.addSubview(exploreIndicatorView)
        exploreIndicatorView.anchor(top: nil, left: exploreView.leftAnchor, bottom: exploreView.bottomAnchor, right: exploreView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        exploreIndicatorView.backgroundColor = UIColor.white
        
        shopView.addSubview(shopIndicatorView)
        shopIndicatorView.anchor(top: nil, left: shopView.leftAnchor, bottom: shopView.bottomAnchor, right: shopView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        shopIndicatorView.backgroundColor = UIColor.white
        shopIndicatorView.isHidden = true
        
        exploreView.addSubview(exploreImageView)
        exploreImageView.anchor(top: nil, left: nil, bottom: exploreIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)
        
        shopView.addSubview(shopImageView)
        shopImageView.anchor(top: nil, left: nil, bottom: shopIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)
        
        NSLayoutConstraint.activate([
            exploreView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.5),
            shopView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.5),
            exploreIndicatorView.centerXAnchor.constraint(equalTo: exploreView.centerXAnchor),
            shopIndicatorView.centerXAnchor.constraint(equalTo: shopView.centerXAnchor),
            exploreImageView.centerXAnchor.constraint(equalTo: exploreView.centerXAnchor),
            shopImageView.centerXAnchor.constraint(equalTo: shopView.centerXAnchor)
        ])
        
    }

    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.shadowImage = UIImage()
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
    }

//    MARK: - PageView Controller DataSource
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {return}

        let currentView = pageViewController.viewControllers?[0]

        if currentView is ExploreVC {
            currentIndex = 0
            configureNavigationHeader(index: currentIndex)
        } else if currentView is ShopVC {
            currentIndex = 1
            configureNavigationHeader(index: currentIndex)
        }
        
    }
    
    
    private func configureNavigationHeader(index: Int){
        if index == 0{
            exploreIndicatorView.isHidden = false
            shopIndicatorView.isHidden = true
            navLabel.text = "Explore"
            createShopButton.isHidden = true
            searchButton.isHidden = false
        } else if index == 1{
            exploreIndicatorView.isHidden = true
            shopIndicatorView.isHidden = false
            navLabel.text = "Shop"
            createShopButton.isHidden = false
            searchButton.isHidden = true
        }
    }
    
//    MARK: - Handlers
    
    @objc private func handleSearch(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let searchUsersVC = SearchUsersVC(collectionViewLayout: UICollectionViewFlowLayout())
            searchUsersVC.openProfile = true
            self.present(UINavigationController(rootViewController: searchUsersVC), animated: true)
        }
    }
    
    @objc private func handleOpenShop(){
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let userShopVC = UserShopVC(collectionViewLayout: UICollectionViewFlowLayout())
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(userShopVC, animated: true)
        }
        
    }
    
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
    
}



























//import UIKit
//
//class HubVC: UIViewController {
//
////    MARK: - Properties
//
//    private let slidingTabController = UISimpleSlidingTabController()
//    private let topView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground
//
//        setupUI()
//
//    }
//
//    private func setupUI(){
//        view.addSubview(topView)
//        topView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        topView.setGradientBackground(color1: UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), color2: UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1))
//        topView.backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
//        view.addSubview(slidingTabController.view)
//        slidingTabController.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        navigationController?.setNavigationBarHidden(true, animated: true)
//
//        slidingTabController.addItem(item: ExploreVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Explore")
//        slidingTabController.addItem(item: ShopVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Shop")
//        slidingTabController.addItem(item: MoreVC(), title: "More")
//
//        slidingTabController.setHeaderActiveColor(color: .white)
//        slidingTabController.setHeaderInActiveColor(color: .lightText)
//        slidingTabController.setHeaderBackgroundColor(color: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1))
//        slidingTabController.setCurrentPosition(position: 0)
//        slidingTabController.setStyle(style: .fixed)
//        slidingTabController.build()
//    }
//
//}
//


