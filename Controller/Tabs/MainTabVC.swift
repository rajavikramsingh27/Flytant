//
//  MainTabVC.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureViewControllers()
        loadUserDetails()
        
        getUserDetails()
    }
        
    
    
//    MARK: - Methods
    private func configureViewControllers() {
        
        self.delegate = self
//        let influencersVC = construcNavController(vc: InfluencersVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Influencers", imageName: "influencersBottomIcon", tag: 0)
        
        let influencersVC = construcNavController(vc: InfluencersViewC(), title: "Influencers", imageName: "influencersBottomIcon", tag: 0)

        let sponsorshipVC = construcNavController(vc: SponsorshipViewController(), title: "Sponsorships", imageName: "sponsorship_bottom", tag: 1)
        
     //  let blank = controller(vc: BlankController(), title: "Create", image: UIImage(systemName: "plus.app.fill")!, tag: 2)
        
        let createCampaignsVC = construcNavController(vc: CreateCompainViewC_1(), title: "Create", imageName: "postCampaignIcon", tag: 2)
        
        
//       let createCampaignsVC = construcNavController(vc: CreateCampaignsVC(), title: "Create", imageName: "postCampaignIcon", tag: 2)
        
       // let chatVC = controller(vc: ChatVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Chats", image: UIImage(systemName: "chat_bottom")!, tag: 3)
        let chatVC = construcNavController(vc: ChatVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Chats", imageName: "chat_bottom", tag: 3)
//        let createCampaign = controller(vc: CreateCampaignsController(), title: "Create", image: UIImage(systemName: "plus.app.fill")!, tag: 2)
//            construcNavController(vc: ChatVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Chats", imageName: "chat_bottom")
        
//        let notificationVC = construcNavController(vc: NotificationVC(), title: "Notifications", imageName: "notification_bottom", tag: 3)
        
//        let social = SocialViewController()
//            social.profile = .user
//
        let socialProfileVC = construcNavController(vc: SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Profile", imageName: "profile_bottom", tag: 4)
        
      //  let socialProfileVC = construcNavController(vc: social, title: "Profile", imageName: "profile_bottom", tag: 4)
        
        
//        let feedVC = construcNavController(vc: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Feed", imageName: "influencersBottomIcon")
//        let exploreVC = construcNavController(vc: ExploreVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Explore", imageName: "exploreIcon")
//        let searchVC = construcNavController(vc: SearchVC(), title: "Search", imageName: "search_bottom")
//        let profileVC = construcNavController(vc: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Profile", imageName: "profile_bottom")
        
        viewControllers = [influencersVC, sponsorshipVC, createCampaignsVC, chatVC, socialProfileVC]
        
        
        tabBar.barTintColor = UIColor.secondarySystemBackground
        tabBar.tintColor = .label
    }
    
    private func controller(vc: UIViewController, title: String, image: UIImage, tag: Int) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        nav.tabBarItem.tag = tag
        nav.navigationBar.isHidden = true
        nav.navigationBar.barTintColor = UIColor.secondarySystemBackground
        return nav
    }
    
    private func construcNavController(vc: UIViewController, title: String, imageName: String, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.tag = tag
        navController.tabBarItem.title = title
        navController.navigationBar.barTintColor = UIColor.secondarySystemBackground
//        navController.navigationBar.isHidden = true
        return navController
    }
    
    private func loadUserDetails() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        print("userId userId userId userId userId userId userId ")
        UserDefaults.standard.setValue(userId, forKey: kUserIDFireBase)

        DataService.instance.fetchUserDetails(userId: userId)
    }
    
}

extension MainTabVC {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let controller = viewController as? UINavigationController {
            if controller.viewControllers.first is CreateCompainViewC_1 {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 2:
            let createCamapign = CreateCompainViewC_1()
            self.navigationController?.pushViewController(createCamapign, animated: true)
            if let index = Defaults().get(for: .selectedIndex) {
                tabBarController?.selectedIndex = index
            }
        default:
            break
        }
    }
    
}



extension MainTabVC {
   private func getUserDetails() {
        if let email = UserDefaults.standard.value(forKey: kUserIDFireBase) {
            Firestore.firestore().collection("users").whereField("userId", isEqualTo: email)
                .getDocuments { (querySnapshot, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                kUsersDocumentID = document.documentID
                                
                                if let subscriptionEndingDate = document.data()["subscriptionEndingDate"] as? Int {
                                    let timeInterval = TimeInterval(subscriptionEndingDate)
                                    let dateSubscriptionEnding = Date(timeIntervalSince1970: timeInterval)
                                                                        
                                    print(dateSubscriptionEnding)
                                    
                                    let calendar = Calendar.current
                                    let date1 = calendar.startOfDay(for: Date())
                                    print(date1)
                                    let date2 = calendar.startOfDay(for: dateSubscriptionEnding)
                                    print(date2)
                                    
                                    let dateyes = calendar.date(byAdding: .day, value: -1, to: Date())
                                    print(dateyes?.timeIntervalSince1970)
                                    
                                    let differenceDate = calendar.dateComponents([.day], from: date1, to: date2).day
                                    
                                    print("differenceDate differenceDate differenceDate differenceDate differenceDate ")
                                    print(differenceDate)
                                    
                                    if let differenceDate_1 = differenceDate {
                                        if differenceDate_1 <= 0 {
                                            self.updateSubscription()
                                        }
                                    }
                                } else {
                                    
                                }
                            }
                        }
                    }
                    
                }
        }
        
    }
    
    
    
    func updateSubscription()  {
//        let loader = self.showLoader()
        Firestore.firestore().collection("users").document(kUsersDocumentID).updateData([
            "messageCredits": 0,
            "numberOfApplies": 0,
            "isSubscribed": false,
        ]) { (error) in
            DispatchQueue.main.async {
//                loader.removeFromSuperview()
                
                if let error = error {
                    print("error error error error error ")
                    print(error)
                } else {
                    
                }
            }
        }
    }
    
    
    
}
