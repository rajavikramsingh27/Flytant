//
//  AppliedInfluencerViewModel.swift
//  Flytant

//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase





class AppliedInfluencerViewModel{

var AppliedInfluencers =  [Users]()
var SelectedInfluencers = [Users]()
    
    func updateSelectedUserData(selected:Bool ,CampId:String,userId:String){
        var sponsorsData : [String: Any] = [:]
        
        if selected == true
        {
             sponsorsData = ["selectedUsers": FieldValue.arrayUnion([userId])] as [String: Any]
      
        }
        else{
            sponsorsData = ["selectedUsers": FieldValue.arrayRemove([userId])] as [String: Any]
        }
     
        SPONSORSHIP_REF.document(CampId).updateData(sponsorsData)
        
    }
    
   
    
    
    func getselectedUserData(CampId:String, completionHandler: @escaping ([String]?, Error?) -> Void) {
        
        let query = SPONSORSHIP_REF.whereField("campaignId", isEqualTo: CampId)
        
        query.getDocuments { (snapshot, error) in
            if let _ = error{
   
                completionHandler(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            
            for document in snapshot.documents{
                
                let data = document.data()
                let selectedUser = data["selectedUsers"] as? [String] ?? [String]()
              
                completionHandler(selectedUser, nil)
                
            }
            
       
            
        }
    }
    
    
    
    
func getAppliedInfluencerData(userIdList:[String], completionHandler: @escaping ([Users]?, Error?) -> Void) {
    
    USER_REF.whereField("userId", in: userIdList).getDocuments { (snapshot, error) in
        if let _ = error{

            completionHandler(nil, error)
            return
        }
        
        guard let snapshot = snapshot else {return}
        for document in snapshot.documents{
            let data = document.data()
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let socialScore = data["socialScore"] as? Int ?? 0
            let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
            let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userID = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let categories = data["categories"] as? [String] ?? [String]()
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
            
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
            print(user.username)
            
            self.AppliedInfluencers.append(user)
        }
        completionHandler(self.AppliedInfluencers, nil)
        
    }
}
    
    func getSelectedInfluencerData(userIdList:[String], completionHandler: @escaping ([Users]?, Error?) -> Void) {
        
        
        
        USER_REF.whereField("userId", in: userIdList).getDocuments { (snapshot, error) in
            if let _ = error{

                completionHandler(nil, error)
                return
            }
            print(userIdList,"SelectedInfluencers")
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let socialScore = data["socialScore"] as? Int ?? 0
                let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
                let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [String]()
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
   
                
                self.SelectedInfluencers.append(user)
              
            }
          
            completionHandler(self.SelectedInfluencers, nil)
            
        }
    }
    func getSingleUserData(userId:[String],index:Int, completionHandler: @escaping () -> Void) {
        
        
        
        USER_REF.whereField("userId", in: userId).getDocuments { (snapshot, error) in
            if let _ = error{

                completionHandler()
                return
            }
   
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let socialScore = data["socialScore"] as? Int ?? 0
                let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
                let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [String]()
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
   
                
                self.SelectedInfluencers.append(user)
             
              
            }
          
            completionHandler()
            
        }
    }



}
