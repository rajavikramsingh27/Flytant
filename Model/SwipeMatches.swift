//
//  SwipeMatches.swift
//  Flytant
//
//  Created by Vivek Rai on 09/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class SwipeMatches {
    
    private(set) var bio: String!
    private(set) var counter: Int!
    private(set) var profileImageUrl: String!
    private(set) var userId: String!
    private(set) var username: String!
    
    init(bio: String, counter: Int, profileImageUrl: String, userId: String, username: String) {
        self.bio = bio
        self.counter = counter
        self.profileImageUrl = profileImageUrl
        self.userId = userId
        self.username = username
    }
}
