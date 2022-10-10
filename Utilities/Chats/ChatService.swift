//
//  ChatService.swift
//  Flytant
//
//  Created by Vivek Rai on 07/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatService{
    
    static let instance = ChatService()
    

    func startPrivateChat(user1: Users, user2: Users) -> String{
        
        var chatRoomId = ""
        if let userId1 = user1.userID, let userId2 = user2.userID{
            let value = userId1.compare(userId2).rawValue
            
            if value < 0{
                chatRoomId = userId1 + userId2
            }else{
                chatRoomId = userId2 + userId1
            }
            
            let members = [userId1, userId2]
            
            createRecentChat(members: members, chatRoomId: chatRoomId, withUsername: "", type: PRIVATE_CHAT, users: [user1, user2], groupImageUrl: nil)
            
            return chatRoomId
        }else{
            return ""
        }

    }

    func createRecentChat(members: [String], chatRoomId: String, withUsername: String, type: String, users: [Users]?, groupImageUrl: String?){
        
        var tempMembers = members
        
        RECENT_CHAT_REF.whereField(CHAT_ROOM_ID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty{
                for recent in snapshot.documents{
                    let data = recent.data()
                    if let currentUserId = data["userId"]{
                        if tempMembers.contains(currentUserId as! String){
                            tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!)
                        }
                    }
                }
            }
            
            for userId in tempMembers{
                self.createRecentItem(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUsername, type: type, users: users, groupImageUrl: groupImageUrl)
            }
            
        }
    }


    func createRecentItem(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type: String, users: [Users]?, groupImageUrl: String?){
        
        let reference = RECENT_CHAT_REF.document()
        let recentId = reference.documentID
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        var recent = [String: Any]()
        
        if type == PRIVATE_CHAT{
            var withUser: Users?
            
            guard let users = users else {return}
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            if users.count > 0{
                if userId == currentUserId{
                    withUser = users.last
                }else{
                    withUser = users.first
                }
            }
            recent = [RECENT_ID: recentId, USERID: userId, CHAT_ROOM_ID: chatRoomId, MEMBERS: members, MEMBERS_TO_PUSH: members, WITH_USERNAME: withUser!.username ?? "", WITH_USER_ID: withUser!.userID ?? "", LAST_MESSAGE: "", COUNTER: 0, CREATION_DATE: creationDate, TYPE: type, CHAT_IMAGE_URL: withUser!.profileImageURL ?? ""]
            
            
        }else{
            
            if groupImageUrl != nil{
                
                recent = [RECENT_ID: recentId, USERID: userId, CHAT_ROOM_ID: chatRoomId, MEMBERS: members, MEMBERS_TO_PUSH: members, WITH_USERNAME: withUserUserName, LAST_MESSAGE: "", COUNTER: 0, CREATION_DATE: creationDate, TYPE: type, CHAT_IMAGE_URL: groupImageUrl!]
            }
        }
        
        reference.setData(recent)
    }
    
    
    func restartRecentChat(recent: NSDictionary){
        
        if recent[TYPE] as! String == PRIVATE_CHAT{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
                self.createRecentChat(members: recent[MEMBERS_TO_PUSH] as! [String], chatRoomId: recent[CHAT_ROOM_ID] as! String, withUsername: user.username, type: PRIVATE_CHAT, users: [user], groupImageUrl: nil)
                return
            }
        }
        
        if recent[TYPE] as! String == GROUP_CHAT{
            createRecentChat(members: recent[MEMBERS_TO_PUSH] as! [String], chatRoomId: recent[CHAT_ROOM_ID] as! String, withUsername: recent[WITH_USERNAME] as! String, type: GROUP_CHAT, users: nil, groupImageUrl: recent[CHAT_IMAGE_URL] as? String)
        }
    }
    
    func dictionaryFromSnapshots(snapshots: [DocumentSnapshot]) -> [NSDictionary] {
        
        var allMessages: [NSDictionary] = []
        for snapshot in snapshots {
            allMessages.append(snapshot.data()! as NSDictionary)
        }
        return allMessages
    }
    
        
    private func clearRecentCounterItem(chat: Chats){
        RECENT_CHAT_REF.document(chat.recentId).updateData(["counter": 0])
    }
    
    func clearRecentCounter(chatRoomId: String){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        RECENT_CHAT_REF.whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments{ (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty{
                for document in snapshot.documents{
                    let data = document.data()
                    let chatImageUrl = data["chatImageUrl"] as? String ?? ""
                    let chatRoomId = data["chatRoomId"] as? String ?? ""
                    let counter = data["counter"] as? Int ?? 0
                    let creationDate = data["creationDate"] as? Double ?? 0
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let members = data["members"] as? [String] ?? [String]()
                    let membersToPush = data["membersToPush"] as? [String] ?? [String]()
                    let recentId = data["recentId"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    let withUserId = data["withUserId"] as? String ?? ""
                    let withUsername = data["withUsername"] as? String ?? ""
                    let chat = Chats(lastMessage: lastMessage, members: members, membersToPush: membersToPush, recentId: recentId, type: type, userId: userId, withUserId: withUserId, withUsername: withUsername, creationDate: creationDate, counter: counter, chatRoomId: chatRoomId, chatImageUrl: chatImageUrl)
                    if userId == currentUserId{
                        self.clearRecentCounterItem(chat: chat)
                    }
                }
            }
        }
    }
    
    func updateRecentItem(chat: Chats, lastMessage: String){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let date = Int(NSDate().timeIntervalSince1970)
        var counter = chat.counter!
        var recentId = chat.recentId!
        
        if chat.userId != currentUserId{
            counter += 1
        }
        
        let values = ["lastMessage": lastMessage, "counter": counter, "creationDate": date] as [String: Any]
        RECENT_CHAT_REF.document(recentId).updateData(values)
    }
    
    
    func updateRecent(chatRoomId: String, recentMessage: String){
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        RECENT_CHAT_REF.whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments{ (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty{
                for document in snapshot.documents{
                    let data = document.data()
                    let chatImageUrl = data["chatImageUrl"] as? String ?? ""
                    let chatRoomId = data["chatRoomId"] as? String ?? ""
                    let counter = data["counter"] as? Int ?? 0
                    let creationDate = data["creationDate"] as? Double ?? 0
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let members = data["members"] as? [String] ?? [String]()
                    let membersToPush = data["membersToPush"] as? [String] ?? [String]()
                    let recentId = data["recentId"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    let withUserId = data["withUserId"] as? String ?? ""
                    let withUsername = data["withUsername"] as? String ?? ""
                    let chat = Chats(lastMessage: lastMessage, members: members, membersToPush: membersToPush, recentId: recentId, type: type, userId: userId, withUserId: withUserId, withUsername: withUsername, creationDate: creationDate, counter: counter, chatRoomId: chatRoomId, chatImageUrl: chatImageUrl)
                    self.updateRecentItem(chat: chat, lastMessage: recentMessage)
                }
            }
        }
    }
    
}
