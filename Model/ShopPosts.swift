//
//  ShopPosts.swift
//  Flytant
//
//  Created by Vivek Rai on 15/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class ShopPosts {
    
    private(set) var category: String!
    private(set) var description: String!
    private(set) var postType: String!
    private(set) var creationDate: Date!
    private(set) var storeIcon: String!
    private(set) var imageUrls: [String]!
    private(set) var userId: String!
    private(set) var shopPostId: String!
    private(set) var storeName: String!
    private(set) var storeWebsite: String!
    private(set) var websiteButtonTitle: String!
    
    init(category: String, description: String, postType: String, creationDate: Double, storeIcon: String, imageUrls: [String], userId: String, shopPostId: String, storeName: String, storeWebsite: String, websiteButtonTitle: String) {
        self.category = category
        self.description = description
        self.postType = postType
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.storeIcon = storeIcon
        self.imageUrls = imageUrls
        self.userId = userId
        self.shopPostId = shopPostId
        self.storeName = storeName
        self.storeName = storeName
        self.storeWebsite = storeWebsite
        self.websiteButtonTitle = websiteButtonTitle
    }
}
