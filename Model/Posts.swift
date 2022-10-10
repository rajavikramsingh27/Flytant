//
//  Posts.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Firebase

class Posts{
    var likes: Int!
    var upvotes: Int!
    var didLike = false
    var didUpvote = false
    var didFollow = false
    private(set) var postID: String!
    private(set) var category: String!
    private(set) var creationDate: Date!
    private(set) var description: String!
    private(set) var imageUrls: [String]!
    private(set) var userID: String!
    private(set) var username: String!
    private(set) var postType: String!
    private(set) var profileImageURL: String!
    private(set) var usersLiked: [String]!
    private(set) var usersUpvoted: [String]!
    private(set) var followersCount: Int!
    
    init(postID: String, category: String, creationDate: Double, description: String, imageUrls: [String], likes: Int, upvotes: Int, userID: String, username: String, postType: String, profileImageURL: String, usersLiked: [String], usersUpvoted: [String], followersCount: Int) {
        self.postID = postID
        self.category = category
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.description = description
        self.imageUrls = imageUrls
        self.likes = likes
        self.upvotes = upvotes
        self.userID = userID
        self.username = username
        self.postType = postType
        self.profileImageURL = profileImageURL
        self.usersLiked = usersLiked
        self.usersUpvoted = usersUpvoted
        self.followersCount = followersCount
    }
    
    func deletePost(deletionComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        guard let postId = self.postID else {return}
        POST_REF.document(postId).delete { (error) in
            if let error = error{
                deletionComplete(false, error)
                return
            }
            REPORT_POST_REF.whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
                if let _ = error{
                    deletionComplete(false, error)
                    return
                }
                guard let snapshot = snapshot else {
                    deletionComplete(true, nil)
                    return
                    
                }
                for document in snapshot.documents{
                    let documentId = document.documentID
                    
                    REPORT_POST_REF.document(documentId).delete()
                }
                
                COMMENT_REF.whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
                    if let _ = error{
                        deletionComplete(false, error)
                        return
                    }
                    guard let snapshot = snapshot else {
                         deletionComplete(true, nil)
                        return
                        
                    }
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        COMMENT_REF.document(documentId).delete()
                    }
                    
                    HASHTAG_POST_REF.whereField(postId, isEqualTo: "postId").getDocuments { (snapshot, error) in
                        if let _ = error{
                            deletionComplete(false, error)
                            return
                        }
                        guard let snapshot = snapshot else {
                            deletionComplete(true, nil)
                            return
                        }
                        for document in snapshot.documents{
                            let documentId = document.documentID
                            HASHTAG_POST_REF.document(documentId).updateData([postId: FieldValue.delete()]){ error in
                                if let error = error {
                                    deletionComplete(false, error)
                                    return
                                } else {
                                    self.imageUrls.forEach { (url) in
                                        Storage.storage().reference(forURL: url).delete(completion: nil)
                                    }
                                    deletionComplete(true, nil)
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    
}
