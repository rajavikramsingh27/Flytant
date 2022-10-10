//
//  OutgoingMessages.swift
//  Flytant
//
//  Created by Vivek Rai on 08/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase

class OutgoingMessages {
    
    let messageDictionary: NSMutableDictionary
    
//    MARK: - Initializers
    
    // text
    init(message: String, senderId: String, senderUsername: String, creationDate: Double, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderUsername, creationDate, status, type], forKeys: ["message" as NSCopying, "senderId" as NSCopying, "senderUsername" as NSCopying, "creationDate" as NSCopying, "status" as NSCopying, "type"as NSCopying])
    }
    
    // picture
    init(message: String, pictureLink: String, senderId: String, senderUsername: String, creationDate: Double, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message, pictureLink, senderId, senderUsername, creationDate, status, type], forKeys: ["message" as NSCopying, "picture" as NSCopying, "senderId" as NSCopying, "senderUsername" as NSCopying, "creationDate" as NSCopying, "status" as NSCopying, "type"as NSCopying])
    }
    
    // video
    init(message: String, videoLink: String, thumbnail: NSData, senderId: String, senderUsername: String, creationDate: Double, status: String, type: String) {
        let picThumb = thumbnail.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        messageDictionary = NSMutableDictionary(objects: [message, videoLink, picThumb, senderId, senderUsername, creationDate, status, type], forKeys: ["message" as NSCopying, "video" as NSCopying, "picture" as NSCopying, "senderId" as NSCopying, "senderUsername" as NSCopying, "creationDate" as NSCopying, "status" as NSCopying, "type"as NSCopying])
    }
    
    // audio
    init(message: String, audioLink: String, senderId: String, senderUsername: String, creationDate: Double, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message, audioLink, senderId, senderUsername, creationDate, status, type], forKeys: ["message" as NSCopying, "audio" as NSCopying, "senderId" as NSCopying, "senderUsername" as NSCopying, "creationDate" as NSCopying, "status" as NSCopying, "type"as NSCopying])
    }
    
    // location
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderUsername: String, creationDate: Double, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderUsername, creationDate, status, type], forKeys: ["message" as NSCopying, "latitude" as NSCopying, "longitude" as NSCopying, "senderId" as NSCopying, "senderUsername" as NSCopying, "creationDate" as NSCopying, "status" as NSCopying, "type"as NSCopying])
    }
    
//    MARK: - Send Messages
    
    func sendMessages(chatRoomId: String, messageDictionary: NSMutableDictionary, memberIds: [String], membersToPush: [String]){
        let messageId = UUID().uuidString
        messageDictionary["messageId"] = messageId
        
        for memberId in memberIds{
            MESSAGE_REF.document(memberId).collection(chatRoomId).document(messageId).setData(messageDictionary as! [String: Any])
        }
        
        //  Update Recent Chat
        ChatService.instance.updateRecent(chatRoomId: chatRoomId, recentMessage: messageDictionary["message"] as! String)
        
        //  Send Push Notifications
    }
    
    class func deleteMessage(withId: String, chatRoomId: String){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        MESSAGE_REF.document(currentUserId).collection(chatRoomId).document(withId).delete()
    }
    
    class func updateMessage(withId: String, chatRoomId: String, memberIds: [String]){
        let readDate = Int(NSDate().timeIntervalSince1970)
        let values = ["status": "read", "readDate": readDate] as [String : Any]
        for userId in memberIds{
            MESSAGE_REF.document(userId).collection(chatRoomId).document(withId).getDocument{ (snapshot, error) in
                if let _ = error{
                    return
                }
                
                guard let snapshot = snapshot else {return}
                if snapshot.exists{
                    MESSAGE_REF.document(userId).collection(chatRoomId).document(withId).updateData(values)
                }
            }
        }
    }
}
