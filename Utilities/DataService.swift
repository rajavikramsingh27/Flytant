//
//  DataService.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class DataService{
    
    static let instance = DataService()
    var loginManager = LoginManager()
    var appliedCampaigns = [String]()
    
    private init() {}
    
    
    func createNewUser(userID: String, username: String, phoneNumber: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        
        guard let fcmToken = Messaging.messaging().fcmToken else {return}
        let userData: [String: Any] = ["username": username, "userId": userID, "phoneNumber": phoneNumber, "bio": "", "dateOfBirth": "", "email": "", "profileImageUrl": DEFAULT_PROFILE_IMAGE_URL, "websiteUrl": "", "gender": "", "name": "", "fcmToken": fcmToken]
        
        USER_REF.document(userID).setData(userData) { (error) in
            if let error = error{
                userCreationComplete(false, error)
                return
            }
            userCreationComplete(true, nil)
        }
    }
    
    func fetchShopDetails(userId: String){
        SHOP_REF.document(userId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let storeName = data["storeName"] as? String ?? ""
            let storeWebsite = data["storeWebsite"] as? String ?? ""
            let storeIcon = data["storeIcon"] as? String ?? ""
            let storeBanner = data["storeBanner"] as? String ?? ""
            self.setShopDetails(storeName: storeName, storeWebsite: storeWebsite, storeIcon: storeIcon, storeBanner: storeBanner)
        }
    }
    
    func fetchUserDetails(userId: String){
        USER_REF.document(userId).getDocument { (snapshot, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let name = data["name"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let bio = data["bio"] as? String ?? ""
            let dateOfBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let swipeImageUrls = data["swipeImageUrls"] as? [String] ?? [String]()
            let linkedAccounts = data["linkedAccounts"] as? [String: [String: String]] ?? [:]
            let youtubeId = linkedAccounts["Youtube"]?["channelId"] ?? ""
            let twitterId = linkedAccounts["Twitter"]?["socialId"] ?? ""
            let categories = data["categories"] as? [String] ?? [String]()
            self.setDefaults(profileImageUrl: profileImageURL, name: name, username: username, phoneNumber: phoneNumber, dob: dateOfBirth, gender: gender, email: email, website: websiteUrl, bio: bio, swipeImageUrls: swipeImageUrls, youtubeId: youtubeId, twitterId: twitterId, categories: categories)
        }
    }
    
    func fetchShopData(with userId: String, completion: @escaping(Shop) -> ()){
        SHOP_REF.document(userId).getDocument { (snapshot, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let storeName = data["storeName"] as? String ?? ""
            let storeWebsite = data["storeWebsite"] as? String ?? ""
            let storeIcon = data["storeIcon"] as? String ?? ""
            let storeBanner = data["storeBanner"] as? String ?? ""
            
            let shop = Shop(storeName: storeName, storeWebsite: storeWebsite, storeIcon: storeIcon, storeBanner: storeBanner)
            completion(shop)
        }
    }
    
    func fetchPartnerUser(with uid: String, completion: @escaping(Users) -> ()) {

        USER_REF.document(uid).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
            let categories = data["categories"] as? [String] ?? [String]()
            
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint)
            completion(user)
        }
    }
    
    func fetchPartnerUserWithCompletion(with uid: String, completion: @escaping(Users, _ status: Bool) -> ()) {

        USER_REF.document(uid).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
            let categories = data["categories"] as? [String] ?? [String]()
            
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint)
            completion(user, true)
        }
    }
    
    func fetchUserSocialProfile(with uid: String, completion: @escaping(Users) -> ()) {

        USER_REF.document(uid).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let data = snapshot?.data() else {return}
            let bio = data["bio"] as? String ?? ""
            let dateofBirth = data["dateOfBirth"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let websiteUrl = data["websiteUrl"] as? String ?? ""
            let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
            let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
            let categories = data["categories"] as? [String] ?? [String]()
            let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
            let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userId, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint, categories: categories)
            completion(user)
        }
    }

    func fetchUserWithUserId(with userId: String, completion: @escaping(Users) -> ()) {

        USER_REF.whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let _ = error{
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
                completion(user)
            }

        }
    }

    func fetchUserWithUsername(with username: String, completion: @escaping(Users) -> ()) {

        USER_REF.whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
//                let data = document.data()
//                let bio = data["bio"] as? String ?? ""
//                let dateofBirth = data["dateOfBirth"] as? String ?? ""
//                let email = data["email"] as? String ?? ""
//                let gender = data["gender"] as? String ?? ""
//                let name = data["name"] as? String ?? ""
//                let phoneNumber = data["phoneNumber"] as? String ?? ""
//                let profileImageURL = data["profileImageUrl"] as? String ?? ""
//                let userID = data["userId"] as? String ?? ""
//                let username = data["username"] as? String ?? ""
//                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
//                let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
//                let websiteUrl = data["websiteUrl"] as? String ?? ""
//                let categories = data["categories"] as? [String] ?? [String]()
//                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
//                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint, categories: categories)
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
                completion(user)
            }

        }
    }
    
    func fetchPost(with postId: String, completion: @escaping(Posts) -> ()){
        POST_REF.document(postId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let postID = snapshot.documentID
            let category = data["category"] as? String ?? "Other"
            let creationDate = data["creationDate"] as? Double ?? 0
            let description = data["description"] as? String ?? ""
            let imageUrls = data["imageUrls"] as? [String] ?? [String]()
            let likes = data["likes"] as? Int ?? 0
            let upvotes = data["upvotes"] as? Int ?? 0
            let userID = data["userId"] as? String ?? "userID"
            let username = data["username"] as? String ?? "username"
            let postType = data["postType"] as? String ?? ""
            let profileImageURL = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
            let usersLiked  = data["usersLiked"] as? [String] ?? [String]()
            let usersUpvoted = data["usersUpvoted"] as? [String] ?? [String]()
            let followersCount = data["followersCount"] as? Int ?? 10
            let posts = Posts(postID: postID, category: category, creationDate: creationDate, description: description, imageUrls: imageUrls, likes: likes, upvotes: upvotes, userID: userID, username: username, postType: postType, profileImageURL: profileImageURL, usersLiked: usersLiked, usersUpvoted: usersUpvoted, followersCount: followersCount)
            completion(posts)
        }
        
    }
    
    
    func setDefaults(profileImageUrl: String, name: String, username: String, phoneNumber: String, dob: String, gender: String, email: String, website: String, bio: String, swipeImageUrls: [String]? = nil, youtubeId: String, twitterId: String, categories: [String]){
        UserDefaults.standard.set(profileImageUrl, forKey: PROFILE_IMAGE_URL)
        UserDefaults.standard.set(name, forKey: NAME)
        UserDefaults.standard.set(username, forKey: USERNAME)
        UserDefaults.standard.set(phoneNumber, forKey: PHONE_NUMBER)
        UserDefaults.standard.set(dob, forKey: DATE_OF_BIRTH)
        UserDefaults.standard.set(gender, forKey: GENDER)
        UserDefaults.standard.set(email, forKey: EMAIL)
        UserDefaults.standard.set(website, forKey: WEBSITE)
        UserDefaults.standard.set(bio, forKey: BIO)
        UserDefaults.standard.set(swipeImageUrls, forKey: SWIPE_IMAGE_URLS)
        UserDefaults.standard.set(youtubeId, forKey: YOUTUBE_ID)
        UserDefaults.standard.set(twitterId, forKey: TWITTER_ID)
        UserDefaults.standard.set(categories, forKey: CATEGORIES)
    }
    
    func setShopDetails(storeName: String, storeWebsite: String, storeIcon: String, storeBanner: String){
        UserDefaults.standard.set(storeName, forKey: SHOP_NAME)
        UserDefaults.standard.set(storeWebsite, forKey: SHOP_WEBSITE)
        UserDefaults.standard.set(storeIcon, forKey: SHOP_ICON_URL)
        UserDefaults.standard.set(storeBanner, forKey: SHOP_BANNER_URL)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func socialLogout(){
        guard let user = Auth.auth().currentUser else {return}
        for info in (user.providerData){
            switch info.providerID{
            case GoogleAuthProviderID:
                GIDSignIn.sharedInstance()?.signOut()
                print("google")
            case FacebookAuthProviderID:
                loginManager.logOut()
                print("Facebook")
            case TwitterAuthProviderID:
                print("Twitter")
                
            default:
                break
            }
        }
    }
    
}
