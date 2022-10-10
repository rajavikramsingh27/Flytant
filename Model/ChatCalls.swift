//
//  ChatCalls.swift
//  Flytant
//
//  Created by Vivek Rai on 16/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase

class ChatCalls {
    
    private(set) var objectId: String!
    private(set) var callerId: String!
    private(set) var callerName: String!
    private(set) var withUserName: String!
    private(set) var withUserId: String!
    private(set) var status: String!
    private(set) var callDate: Date!
    private(set) var isIncoming: Bool!
    
    init(callerId: String, callerName: String, withUserName: String, withUserId: String) {
        self.objectId = UUID().uuidString
        self.callerId = callerId
        self.callerName = callerName
        self.withUserName = withUserName
        self.withUserId = withUserId
        self.status = ""
        self.isIncoming = false
        self.callDate = NSDate() as Date
    }
    
    init(dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as? String
        
        if let callerId = dictionary["callerId"]{
            self.callerId = callerId as? String
        }else{
            self.callerId = ""
        }
        
        if let callerName = dictionary["callerName"]{
            self.callerName = callerName as? String
        }else{
            self.callerName = ""
        }
        
        if let withUserName = dictionary["withUserName"]{
            self.withUserName = withUserName as? String
        }else{
            self.withUserName = ""
        }
        
        if let withUserId = dictionary["withUserId"]{
            self.withUserId = withUserId as? String
        }else{
            self.withUserId = ""
        }
        
        if let status = dictionary["status"]{
            self.status = status as? String
        }else{
            self.status = "Unknown"
        }
        
        if let isIncoming = dictionary["isIncoming"]{
            self.isIncoming = isIncoming as? Bool
        }else{
            self.isIncoming = false
        }
        
        if let callDate = dictionary["callDate"]{
            self.callDate = Date(timeIntervalSince1970: (callDate as? Double)!)
        }else{
            self.callDate = Date()
        }
    }
    
    func dictionaryFromCall() -> NSDictionary{
        let callDateValue = Int(callDate.timeIntervalSince1970)
        
        return NSDictionary(objects: [objectId ?? "", callerId ?? "", callerName ?? "", withUserId ?? "", withUserName ?? "", status ?? "", isIncoming ?? false, callDateValue], forKeys: ["objectId" as NSCopying, "callerId" as NSCopying, "callerName" as NSCopying, "withUserId" as NSCopying, "withUserName" as NSCopying, "status" as NSCopying, "isIncoming" as NSCopying, "callDate" as NSCopying])
    }
    
    func saveCall(){
        CALL_REF.document(callerId).collection(callerId).document(objectId).setData(dictionaryFromCall() as! [String: Any])
        CALL_REF.document(withUserId).collection(withUserId).document(objectId).setData(dictionaryFromCall() as! [String: Any])
    }
   
    func deleteCall(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        CALL_REF.document(currentUserId).collection(currentUserId).document(objectId).delete()
    }
}
