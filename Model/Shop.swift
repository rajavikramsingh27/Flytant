//
//  Shop.swift
//  Flytant
//
//  Created by Vivek Rai on 24/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class Shop {
    
    private(set) var storeName: String!
    private(set) var storeWebsite: String!
    private(set) var storeIcon: String!
    private(set) var storeBanner: String!
    
    init(storeName: String, storeWebsite: String, storeIcon: String, storeBanner: String) {
        self.storeName = storeName
        self.storeWebsite = storeWebsite
        self.storeIcon = storeIcon
        self.storeBanner = storeBanner
    }
}
