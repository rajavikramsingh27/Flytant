//
//  Swipes.swift
//  Flytant
//
//  Created by Vivek Rai on 01/09/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase

class Swipes {
    
    static func saveSwipes(forUser user: Users, isLike: Bool, completion: ((Error?) -> Void)?){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        SWIPES_REF.document(currentUserId).getDocument { (snapshot, error) in
            let data = [user.userID: isLike] as! [String: Any]
            if snapshot?.exists ?? false{
                SWIPES_REF.document(currentUserId).updateData(data , completion: completion)
            }else{
                SWIPES_REF.document(currentUserId).setData(data, completion: completion)
            }
        }
    }
    
    static func checkForMatches(forUser user: Users, completion: @escaping(Bool) -> Void){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        SWIPES_REF.document(user.userID).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let data = snapshot?.data() else {return}
            guard let didMatch = data[currentUserId] as? Bool else {return}
            completion(didMatch)
        }
    }
}
