//
//  Payments.swift
//  Flytant
//
//  Created by Vivek Rai on 26/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class Payments{
    
    private(set) var userId: String!
    private(set) var username: String!
    private(set) var amount: Double!
    private(set) var paymentMode: String!
    private(set) var status: String!
    private(set) var paymentId: String!
    private(set) var creationDate: Date!
    
    init(userId: String, username: String, amount: Double, paymentMode: String, status: String, paymentId: String, creationDate: Double) {
        self.userId = userId
        self.username = username
        self.amount = amount
        self.paymentMode = paymentMode
        self.status = status
        self.paymentId = paymentId
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
    
}
