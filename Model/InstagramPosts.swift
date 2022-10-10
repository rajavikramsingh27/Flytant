//
//  InstagramPosts.swift
//  Flytant
//
//  Created by Vivek Rai on 04/03/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation

class InstagramPosts{
 
    private(set) var likes: Int!
    private(set) var comments: Int!
    private(set) var postImageUrl: String!
    private(set) var username: String!
    private(set) var profileImageUrl: String!
    private(set) var creationDate: Double!
    
    init(likes: Int, comments: Int, postImageUrl: String, creationDate: Double, username: String, profileImageUrl: String) {
        self.likes = likes
        self.comments = comments
        self.postImageUrl = postImageUrl
        self.creationDate = creationDate
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    
}
