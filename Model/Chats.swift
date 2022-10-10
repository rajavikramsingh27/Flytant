//
//  Chats.swift
//  Flytant
//
//  Created by Vivek Rai on 08/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class Chats{
    
    private(set) var lastMessage: String!
    private(set) var members: [String]!
    private(set) var membersToPush: [String]!
    private(set) var recentId: String!
    private(set) var type: String!
    private(set) var userId: String!
    private(set) var withUserId: String!
    private(set) var withUsername: String!
    private(set) var creationDate: Date!
    private(set) var counter: Int!
    private(set) var chatRoomId: String!
    private(set) var chatImageUrl: String!
    
    init(lastMessage: String, members: [String], membersToPush: [String], recentId: String, type: String, userId: String, withUserId: String, withUsername: String, creationDate: Double, counter: Int, chatRoomId: String, chatImageUrl: String) {
        self.lastMessage = lastMessage
        self.members = members
        self.membersToPush = membersToPush
        self.recentId = recentId
        self.type = type
        self.userId = userId
        self.withUserId = withUserId
        self.withUsername = withUsername
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.counter = counter
        self.chatRoomId = chatRoomId
        self.chatImageUrl = chatImageUrl
    }
}
