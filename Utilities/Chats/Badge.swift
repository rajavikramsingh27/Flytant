//
//  Badge.swift
//  Flytant
//
//  Created by Vivek Rai on 18/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public var recentBadgeHandler: ListenerRegistration?

func recentBadgeCount(withBlock: @escaping(_ badgeNumber: Int) -> Void){
    guard let currentUserId = Auth.auth().currentUser?.uid else {return}
    recentBadgeHandler = RECENT_CHAT_REF.whereField("userId", isEqualTo: currentUserId).addSnapshotListener({ (snapshot, error) in
        if let _ = error{
            return
        }
        var badge = 0
        var counter = 0
        guard let snapshot = snapshot else {return}
        
        if !snapshot.isEmpty{
            let recents = snapshot.documents
            for recent in recents{
                let currentRecent = recent.data() as NSDictionary
                badge += currentRecent["counter"] as! Int
                counter += 1
                if counter == recents.count{
                    withBlock(badge)
                }
             }
        }else{
            withBlock(badge)
        }
    })
}

func setBadges(controller: UITabBarController){
    recentBadgeCount{(badge) in
        if badge != 0{
            controller.tabBar.items?[2].badgeValue = "\(badge)"
        }else{
            controller.tabBar.items?[2].badgeValue = nil
        }
        
    }
}
