//
//  Contacts.swift
//  Flytant
//
//  Created by Vivek Rai on 16/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class ChatContacts{
    
     private(set) var firstName: String!
     private(set) var lastName: String!
     private(set) var contactNumber: String!
    
    init(firstName: String, lastName: String, contactNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.contactNumber = contactNumber
    }
}
