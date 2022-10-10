//
//  Messages.swift
//  Flytant
//
//  Created by Vivek Rai on 09/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class Messages: Equatable{
    
    private(set) var message: String!
    private(set) var messageId: String!
    private(set) var senderId: String!
    private(set) var senderUsername: String!
    private(set) var status: String!
    private(set) var type: String!
    private(set) var creationDate: Date!

    init(message: String, messageId: String, senderId: String, senderUsername: String, status: String, type: String, creationDate: Double) {
        self.message = message
        self.messageId = messageId
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.status = status
        self.type = type
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
    
    static func == (lhs: Messages, rhs: Messages) -> Bool {
        return true
    }

}
