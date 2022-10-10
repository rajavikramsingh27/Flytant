//
//  YoutubeManager.swift
//  Flytant
//
//  Created by Vivek Rai on 25/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class YoutubeManager{
    
   static let instance = YoutubeManager()
    
    func getChannelId(url: String, completion: @escaping(String) -> ()){
        var channelId = ""
        AF.request(url, method : .get).responseJSON{
            response in
            switch response.result {
               case .success(let value):
                channelId = "\(JSON(value)["items"][0]["id"])"
                completion(channelId)
               case .failure(let error):
                print(error)
            }
        }
    }
    
    func getChannelStats(url: String, completion: @escaping([String]) -> ()){
        var subscribers = ""
        var views = ""
        var videos = ""
        var channelId = ""
        AF.request(url, method : .get).responseJSON{
            response in
            switch response.result {
               case .success(let value):
                    subscribers = "\(JSON(value)["items"][0]["statistics"]["subscriberCount"])"
                    videos = "\(JSON(value)["items"][0]["statistics"]["videoCount"])"
                    views = "\(JSON(value)["items"][0]["statistics"]["viewCount"])"
                    channelId = "\(JSON(value)["items"][0]["id"])"
                    completion([subscribers, views, videos, channelId])
               case .failure(let error):
                print(error)
            }
        }
    }
}
