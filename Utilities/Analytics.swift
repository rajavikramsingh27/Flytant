//
//  Analytics.swift
//  Flytant
//
//  Created by Vivek Rai on 25/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class Analytics {
    
    static func getRevenue(followersCount: Int, likes: Int) -> Double{
        if followersCount >= 1000{
            if followersCount >= 1000 && followersCount < 10000{
                return Double(likes/1000) * 0.05
            }else if followersCount >= 10000 && followersCount < 20000{
                return Double(likes/1000) * 0.1
            }else if followersCount >= 20000 && followersCount < 30000{
                return Double(likes/1000) * 0.2
            }else if followersCount >= 30000 && followersCount < 40000{
                return Double(likes/1000) * 0.3
            }else if followersCount >= 40000 && followersCount < 50000{
                return Double(likes/1000) * 0.4
            }else if followersCount >= 50000 && followersCount < 60000{
                return Double(likes/1000) * 0.5
            }else if followersCount >= 60000 && followersCount < 70000{
                return Double(likes/1000) * 0.6
            }else if followersCount >= 70000 && followersCount < 80000{
                return Double(likes/1000) * 0.7
            }else if followersCount >= 80000 && followersCount < 90000{
                return Double(likes/1000) * 0.8
            }else if followersCount >= 90000 && followersCount < 100000{
                return Double(likes/1000) * 0.9
            }else if followersCount >= 100000{
                return Double(likes/1000) * 1.0
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
}
