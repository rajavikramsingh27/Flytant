//
//  NotificationService.swift
//  Flytant
//
//  Created by Vivek Rai on 17/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class NotificationService{
    
    static let instance = NotificationService()
    
    func sendLikeNotification(post: Posts, didLike: Bool) {
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        guard let receiverId = post.userID else {return}
        guard let postId = post.postID else {return}
        guard let postImageUrl = post.imageUrls.first else {return}
        guard let senderProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        guard let senderUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        let type = 0
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let comment = ""
        
        if senderId != post.userID{
            if didLike{
                let values = ["checked": 0, "creationDate": creationDate, "senderId": senderId, "receiverId": receiverId, "type": type, "postId": postId, "postImageUrl": postImageUrl, "senderProfileImageUrl": senderProfileImageUrl, "senderUsername": senderUsername, "comment": comment] as [String : Any]
                NOTIFICATIONS_REF.document().setData(values)
                
            }else{
                NOTIFICATIONS_REF.whereField("senderId", isEqualTo: senderId).whereField("receiverId", isEqualTo: receiverId).whereField("postId", isEqualTo: postId).whereField("type", isEqualTo: type).getDocuments { (snapshot, error) in
                    if let _ = error{
                        return
                    }
                    guard let snapshot = snapshot else {return}
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        NOTIFICATIONS_REF.document(documentId).delete()
                    }
                }
            }
        }
    }
    
    
    
    func sendUpvoteNotification(post: Posts, didUpvote: Bool) {
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        guard let receiverId = post.userID else {return}
        guard let postId = post.postID else {return}
        guard let postImageUrl = post.imageUrls.first else {return}
        guard let senderProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        guard let senderUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        let type = 1
        let comment = ""
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        if senderId != post.userID{
            if didUpvote{
                let values = ["checked": 0, "creationDate": creationDate, "senderId": senderId, "receiverId": receiverId, "type": type, "postId": postId, "postImageUrl": postImageUrl, "senderProfileImageUrl": senderProfileImageUrl, "senderUsername": senderUsername, "comment": comment] as [String : Any]
                NOTIFICATIONS_REF.document().setData(values)
                
            }else{
                NOTIFICATIONS_REF.whereField("senderId", isEqualTo: senderId).whereField("receiverId", isEqualTo: receiverId).whereField("postId", isEqualTo: postId).whereField("type", isEqualTo: type).getDocuments { (snapshot, error) in
                    if let _ = error{
                        return
                    }
                    guard let snapshot = snapshot else {return}
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        NOTIFICATIONS_REF.document(documentId).delete()
                    }
                }
            }
        }
    }
    
    func sendCommentNotification(post: Posts, commentText: String){
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        guard let receiverId = post.userID else {return}
        guard let postId = post.postID else {return}
        guard let postImageUrl = post.imageUrls.first else {return}
        guard let senderProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        guard let senderUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        let type = 3
        let comment = commentText
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        if senderId != receiverId{
            let values = ["checked": 0, "creationDate": creationDate, "senderId": senderId, "receiverId": receiverId, "type": type, "postId": postId, "postImageUrl": postImageUrl, "senderProfileImageUrl": senderProfileImageUrl, "senderUsername": senderUsername, "comment": comment] as [String : Any]
            NOTIFICATIONS_REF.document().setData(values)
        }
    }
    
    func sendFollowNotification(userId: String, didFollow: Bool){
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        let receiverId = userId
        let postId = ""
        let postImageUrl = ""
        guard let senderProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        guard let senderUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        let type = 2
        let comment = ""
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        if senderId != receiverId{
            if didFollow{
                let values = ["checked": 0, "creationDate": creationDate, "senderId": senderId, "receiverId": receiverId, "type": type, "postId": postId, "postImageUrl": postImageUrl, "senderProfileImageUrl": senderProfileImageUrl, "senderUsername": senderUsername, "comment": comment] as [String : Any]
                NOTIFICATIONS_REF.document().setData(values)
            }else{
                NOTIFICATIONS_REF.whereField("senderId", isEqualTo: senderId).whereField("receiverId", isEqualTo: receiverId).whereField("type", isEqualTo: type).getDocuments { (snapshot, error) in
                    if let _ = error{
                        return
                    }
                    guard let snapshot = snapshot else {return}
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        NOTIFICATIONS_REF.document(documentId).delete()
                    }
                    
                }

            }
        }
    }
    
    func sendAppliedCampaignNotification(userId: String, campaignId: String){
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        let receiverId = userId
        let type = 5
        let creationDate = Int(NSDate().timeIntervalSince1970)
        guard let senderProfileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        guard let senderUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        if senderId != receiverId{
            let values = ["checked": 0, "creationDate": creationDate, "senderId": senderId, "receiverId": receiverId, "type": type, "senderProfileImageUrl": senderProfileImageUrl, "senderUsername": senderUsername, "campaignId": campaignId] as [String : Any]
            NOTIFICATIONS_REF.document().setData(values)
        }
    }
    
}
