//
//  Sponsorships.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class Sponsorships{

    private(set) var userId: String!
    private(set) var price: Int!
    private(set) var platforms: [String]!
    private(set) var name: String!
    private(set) var gender: String!
    private(set) var minFollowers: Int!
    private(set) var description: String!
    private(set) var currency: String!
    private(set) var creationDate: Date!
    private(set) var influencers: [String]!
    private(set) var categories: [String]!
    private(set) var campaignId: String!
    private(set) var isApproved: Bool!
    private(set) var selectedUsers: [String]!
    private(set) var blob: [Dictionary<String, String>]!
   
    
    init(userId: String, price: Int, platforms: [String], name: String, gender: String, minFollowers: Int, description: String, currency: String, creationDate: Double, influencers: [String], categories: [String], campaignId: String, isApproved: Bool,selectedUsers: [String], blob: [Dictionary<String, String>]){
        self.userId = userId
        self.price = price
        self.platforms = platforms
        self.name = name
        self.gender = gender
        self.minFollowers = minFollowers
        self.description = description
        self.currency = currency
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.influencers = influencers
        self.categories = categories
        self.campaignId = campaignId
        self.isApproved = isApproved
        self.selectedUsers = selectedUsers
        self.blob = blob
    }
    
}

