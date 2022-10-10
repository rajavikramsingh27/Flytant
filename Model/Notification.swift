//
//  Notification.swift
//  Flytant
//
//  Created by Vivek Rai on 17/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class Notification{
    
    private(set) var checked: Int!
    private(set) var creationDate: Date!
    private(set) var postId: String!
    private(set) var postImageUrl: String!
    private(set) var receiverId: String!
    private(set) var senderId: String!
    private(set) var senderProfileImageUrl: String!
    private(set) var senderUsername: String!
    private(set) var type: Int!
    
    init(checked: Int, creationDate: Double, postId: String, postImageUrl: String, receiverId: String, senderId: String, senderProfileImageUrl: String, senderUsername: String, type: Int) {
        self.checked = checked
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.postId = postId
        self.postImageUrl = postImageUrl
        self.receiverId = receiverId
        self.senderId = senderId
        self.senderProfileImageUrl = senderProfileImageUrl
        self.senderUsername = senderUsername
        self.type = type
    }
}
