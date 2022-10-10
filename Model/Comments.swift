//
//  Comments.swift
//  Flytant
//
//  Created by Vivek Rai on 05/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class Comments {
    
    var postId: String!
    var profileImageUrl: String!
    var commentText: String
    var creationDate: Date!
    var username: String!
    var userId: String!
    
    init(postId: String, profileImageUrl: String, commentText: String, creationDate: Double, username: String, userId: String) {
        self.postId = postId
        self.profileImageUrl = profileImageUrl
        self.commentText = commentText
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.username = username
        self.userId = userId
    }
}
