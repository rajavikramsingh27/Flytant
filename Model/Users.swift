//
//  Users.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class Users{
    
    var didFollow = false
    private(set) var bio: String!
    private(set) var dateOfBirth: String!
    private(set) var email: String!
    private(set) var gender: String!
    private(set) var name: String!
    private(set) var phoneNumber: String!
    private(set) var numberOfApplies: Int!
    private(set) var messageCredits: Int!
    private(set) var username: String!
    private(set) var userID: String!
    private(set) var profileImageURL: String!
    private(set) var websiteUrl: String!
    private(set) var blockedUsers: [String]!
    private(set) var monetizationEnabled: Bool!
    private(set) var geoPoint: GeoPoint!
    private(set) var isOnline: Bool!
    private(set) var shouldShowInfluencer: Bool!
    private(set) var shouldShowTrending: Bool!
    private(set) var socialScore: Int!
    private(set) var swipeImageUrls: [String]!
    private(set) var twitterId: String!
    private(set) var youtubeId: String!
    private(set) var categories: [String]!
    private(set) var linkedAccounts: Dictionary<String, Any>!
    
     init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, phoneNumber: String, username: String, userID: String, profileImageURL: String, websiteUrl: String){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.phoneNumber = phoneNumber
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
    }
    
    init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, phoneNumber: String, username: String, userID: String, profileImageURL: String, websiteUrl: String, blockedUsers: [String], monetizationEnabled: Bool, geoPoint: GeoPoint){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.phoneNumber = phoneNumber
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
        self.blockedUsers = blockedUsers
        self.monetizationEnabled = monetizationEnabled
        self.geoPoint = geoPoint
    }
    
    init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, phoneNumber: String, username: String, userID: String, profileImageURL: String, websiteUrl: String, blockedUsers: [String], monetizationEnabled: Bool, geoPoint: GeoPoint, swipeImageUrls: [String]){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.phoneNumber = phoneNumber
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
        self.blockedUsers = blockedUsers
        self.monetizationEnabled = monetizationEnabled
        self.geoPoint = geoPoint
        self.swipeImageUrls = swipeImageUrls
    }
    
    init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, phoneNumber: String, username: String, userID: String, profileImageURL: String, websiteUrl: String, blockedUsers: [String], monetizationEnabled: Bool, geoPoint: GeoPoint, categories: [String]){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.phoneNumber = phoneNumber
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
        self.blockedUsers = blockedUsers
        self.monetizationEnabled = monetizationEnabled
        self.geoPoint = geoPoint
        self.categories = categories
    }
    
    init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, socialScore: Int, shouldShowInfluencer: Bool, shouldShowTrending: Bool, username: String, userID: String, profileImageURL: String, websiteUrl: String, blockedUsers: [String], geoPoint: GeoPoint, categories: [String], linkedAccounts: Dictionary<String, Any>){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
        self.blockedUsers = blockedUsers
        self.shouldShowTrending = shouldShowTrending
        self.shouldShowInfluencer = shouldShowInfluencer
        self.socialScore = socialScore
        self.geoPoint = geoPoint
        self.categories = categories
        self.linkedAccounts = linkedAccounts
    }
    
    
    init(bio: String, dateOfBirth: String, email: String, gender: String, name: String, socialScore: Int, shouldShowInfluencer: Bool, shouldShowTrending: Bool, username: String, userID: String, profileImageURL: String, websiteUrl: String,numberOfApplies:Int,messageCredits:Int, blockedUsers: [String], geoPoint: GeoPoint, categories: [String], linkedAccounts: Dictionary<String, Any>){
        self.bio = bio
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.name = name
        self.username = username
        self.userID = userID
        self.profileImageURL = profileImageURL
        self.websiteUrl = websiteUrl
        self.numberOfApplies = numberOfApplies
        self.messageCredits = messageCredits
        self.blockedUsers = blockedUsers
        self.shouldShowTrending = shouldShowTrending
        self.shouldShowInfluencer = shouldShowInfluencer
        self.socialScore = socialScore
        self.geoPoint = geoPoint
        self.categories = categories
        self.linkedAccounts = linkedAccounts
    }
}

