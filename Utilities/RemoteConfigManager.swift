//
//  RemoteConfigManager.swift
//  Flytant
//
//  Created by Vivek Rai on 21/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//


import Foundation
import Firebase
import FirebaseRemoteConfig

struct RemoteConfigManager {
    
    private static var remoteConfig: RemoteConfig = {
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        return remoteConfig
    }()
    
    static func configure(expirationDuration: TimeInterval = 3600){
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            print("Got the values from Remote Config.")
            RemoteConfig.remoteConfig().activate(completionHandler: nil)
        }
    }

    static func getExploreCategoryData(for key: String) -> [[String]]{
        var resultArray = [[String]]()
        let fetchedData = remoteConfig.configValue(forKey: key)
        do {
            
            let json = try JSONSerialization.jsonObject(with: fetchedData.dataValue, options: .fragmentsAllowed) as! [String: Any]
            var categoryName = [String]()
            var categoryImages = [String]()
            for (i,j) in json{
                categoryName.append(i)
                categoryImages.append(j as? String ?? "")
            }
            resultArray.insert(categoryName, at: 0)
            resultArray.insert(categoryImages, at: 1)
        } catch let _ {
            //print(error)
        }
        return resultArray
    }
    
    static func getDisplayImages(for key: String) -> [[String]]{
        var resultArray = [[String]]()
        let fetchedData = remoteConfig.configValue(forKey: key)
        do {
            
            let json = try JSONSerialization.jsonObject(with: fetchedData.dataValue, options: .fragmentsAllowed) as! [String: Any]
            var categoryName = [String]()
            var categoryImages = [String]()
            for (i,j) in json{
                categoryName.append(i)
                categoryImages.append(j as? String ?? "")
            }
            resultArray.insert(categoryName, at: 0)
            resultArray.insert(categoryImages, at: 1)
        } catch let error {
            print(error)
        }
        return resultArray
    }
    
    
}
