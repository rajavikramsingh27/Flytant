//
//  SwipeVC.swift
//  Flytant
//
//  Created by Vivek Rai on 18/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SwipeVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

//    MARK: - Properties
    
    var previousIndex = 0
    var nextIndex = 0
    var currentIndex = 0
    var swipeSetting = SwipeSetting()
    
    lazy var viewControllerList: [UIViewController] = {
        let swipeCardVC = SwipeCardVC()
        let usersAroundVC = UsersAroundVC(collectionViewLayout: UICollectionViewFlowLayout())
        let newMatchesVC = NewMatchesVC()
        let swipeSetting = SwipeSetting()
//        return [swipeCardVC, usersAroundVC, newMatchesVC, swipeSetting]
        return [swipeCardVC, usersAroundVC, newMatchesVC]
    }()
    
//    MARK: - Views
    
    let navBarView = UIView()
    let navBarImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "naviagationTopImage")!)
    let navLabel = FLabel(backgroundColor: UIColor.clear, text: "Swipe", font: UIFont.boldSystemFont(ofSize: 24), textAlignment: .left, textColor: UIColor.white)
    
    let swipeImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "swipeSwipeCards")!)
    let usersAroundImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "swipeUsersAround")!)
    let newMatchesImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "swipeNewMatches")!)
    let settingsImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "swipeSettings")!)
    
    let swipeIndicatorView = UIView()
    let usersAroundIndicatorView = UIView()
    let newMatchesIndicatorView = UIView()
    let settingIndicatorView = UIView()
    
    let swipeView = UIView()
    let usersAroundView = UIView()
    let newMatchesView = UIView()
    let settingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        
        configurePageViewController()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        configureNavBarViews()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        navLabel.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 200, height: 32)
    
        
        navBarView.addSubview(swipeView)
        swipeView.anchor(top: nil, left: navBarView.leftAnchor, bottom: navBarView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
//        navBarView.addSubview(settingView)
//        settingView.anchor(top: nil, left: nil, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        
        navBarView.addSubview(newMatchesView)
        newMatchesView.anchor(top: nil, left: nil, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        navBarView.addSubview(usersAroundView)
        usersAroundView.anchor(top: nil, left: swipeView.rightAnchor, bottom: navBarView.bottomAnchor, right: newMatchesView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        swipeView.addSubview(swipeIndicatorView)
        swipeIndicatorView.anchor(top: nil, left: swipeView.leftAnchor, bottom: swipeView.bottomAnchor, right: swipeView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 4)
        swipeIndicatorView.backgroundColor = UIColor.white

        usersAroundView.addSubview(usersAroundIndicatorView)
        usersAroundIndicatorView.anchor(top: nil, left: usersAroundView.leftAnchor, bottom: usersAroundView.bottomAnchor, right: usersAroundView.rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottom: 0, paddingRight: 60, width: 0, height: 4)
        usersAroundIndicatorView.backgroundColor = UIColor.white
        usersAroundIndicatorView.isHidden = true
        
        newMatchesView.addSubview(newMatchesIndicatorView)
        newMatchesIndicatorView.anchor(top: nil, left: newMatchesView.leftAnchor, bottom: newMatchesView.bottomAnchor, right: newMatchesView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 4)
        newMatchesIndicatorView.backgroundColor = UIColor.white
        newMatchesIndicatorView.isHidden = true
        
//        settingView.addSubview(settingIndicatorView)
//        settingIndicatorView.anchor(top: nil, left: settingView.leftAnchor, bottom: settingView.bottomAnchor, right: settingView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 4)
//        settingIndicatorView.backgroundColor = UIColor.white
//        settingIndicatorView.isHidden = true

        swipeView.addSubview(swipeImageView)
        swipeImageView.anchor(top: nil, left: nil, bottom: swipeIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)
        
        usersAroundView.addSubview(usersAroundImageView)
        usersAroundImageView.anchor(top: nil, left: nil, bottom: usersAroundIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)

        newMatchesView.addSubview(newMatchesImageView)
        newMatchesImageView.anchor(top: nil, left: nil, bottom: newMatchesIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)
        
//        settingView.addSubview(settingsImageView)
//        settingsImageView.anchor(top: nil, left: nil, bottom: settingIndicatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 32, height: 32)
        
        NSLayoutConstraint.activate([
            swipeView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.25),
//            settingView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.25),
            usersAroundView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.5),
            newMatchesView.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.25),
            swipeIndicatorView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor),
            usersAroundIndicatorView.centerXAnchor.constraint(equalTo: usersAroundView.centerXAnchor),
            newMatchesIndicatorView.centerXAnchor.constraint(equalTo: newMatchesView.centerXAnchor),
//            settingIndicatorView.centerXAnchor.constraint(equalTo: settingView.centerXAnchor),
            swipeImageView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor),
            usersAroundImageView.centerXAnchor.constraint(equalTo: usersAroundView.centerXAnchor),
            newMatchesImageView.centerXAnchor.constraint(equalTo: newMatchesView.centerXAnchor),
//            settingsImageView.centerXAnchor.constraint(equalTo: settingView.centerXAnchor)
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

        if currentView is SwipeCardVC {
            currentIndex = 0
            configureNavigationHeader(index: currentIndex)
        } else if currentView is UsersAroundVC {
            currentIndex = 1
            configureNavigationHeader(index: currentIndex)
        } else if currentView is NewMatchesVC {
            currentIndex = 2
            configureNavigationHeader(index: currentIndex)
        } else if currentView is SwipeSetting {
            currentIndex = 3
            configureNavigationHeader(index: currentIndex)
        }
        
    }
    
    
    private func configureNavigationHeader(index: Int){
        if index == 0{
            swipeIndicatorView.isHidden = false
            usersAroundIndicatorView.isHidden = true
            newMatchesIndicatorView.isHidden = true
            settingIndicatorView.isHidden = true
            navLabel.text = "Swipe"
        } else if index == 1{
            swipeIndicatorView.isHidden = true
            usersAroundIndicatorView.isHidden = false
            newMatchesIndicatorView.isHidden = true
            settingIndicatorView.isHidden = true
            navLabel.text = "Find Users"
        } else if index == 2{
            swipeIndicatorView.isHidden = true
            usersAroundIndicatorView.isHidden = true
            newMatchesIndicatorView.isHidden = false
            settingIndicatorView.isHidden = true
            navLabel.text = "New Matches"
        }
//        else if index == 3{
//            swipeIndicatorView.isHidden = true
//            usersAroundIndicatorView.isHidden = true
//            newMatchesIndicatorView.isHidden = true
//            settingIndicatorView.isHidden = false
//            navLabel.text = "Settings"
//        }
    }
  
//    MARK: - Handle Save
    
    @objc private func handleSave(){
        swipeSetting.saveData()
    }
    
}



