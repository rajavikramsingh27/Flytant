//
//  CreateCampaignModel.swift
//  Flytant
//
//  Created by Flytant on 07/10/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation

struct CreateCampaignModel {
    var applied: Int?
    var blob: [CampaignImage]?
    var campaignId: String?
    var categories: [String]?
    var currency: String = "$"
    var description: String?
    var gender: String?
    var minFollowers: Int?
    var name: String?
    var platforms: [String]?
    var price: Int?
    var userId: String?
    var barter: Bool?
    var barterDescription: String?
    var isApproved: Bool?
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["applied"] = 0
        if let isApproved = isApproved {
            dict["isApproved"] = isApproved
        } else {
            dict["isApproved"] = false
        }
        if let campaignId = campaignId {
            dict["campaignId"] = campaignId
        }
        if let description = description {
            dict["description"] = description
        }
        if let gender = gender {
            dict["gender"] = gender
        }
        if let minFollowers = minFollowers {
            dict["minFollowers"] = minFollowers
        }
        if let name = name {
            dict["name"] = name
        }
        if let price = price {
            dict["price"] = price
        }
        if let userid = userId {
            dict["userId"] = userid
        }
        if let barter = barter {
            dict["barter"] = barter
        }
        if let barterDescription = barterDescription {
            dict["barterDescription"] = barterDescription
        }
        if let blob = blob {
            var dictionaryElement = [[String: Any]]()
            for imageType in blob {
                dictionaryElement.append(imageType.toDictionary())
            }
            dict["blob"] = dictionaryElement
        }
        if let platform = platforms {
            var arr = [String]()
            for i in platform {
                arr.append(i)
            }
            dict["platforms"] = arr
        }
        if let categories = categories {
            var arr = [String]()
            for i in categories {
                arr.append(i)
            }
            dict["categories"] = arr
        }
        return dict
    }
    
}


struct CampaignImage {
    var path: String?
    var type: String?
    
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if let path = path {
            dict["path"] = path
        }
        if let type = type {
            dict["type"] = type
        }
        return dict
    }
    
}
