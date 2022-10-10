//
//  SponsorshipViewModel.swift
//  Flytant
//
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift


class  SponsorshipViewModel {
    
    //1. table must have only row with data.
    //2. banner comes according label
    //3. fill the collection cell
    
    let group = DispatchGroup()
    
    var slider = [Slider]()
    
    var sponsorships = [Sponsorships]()
    var isYourSponsorshipModel = [Sponsorships]()
    var latestSponsorshipModel = [Sponsorships]()
    var highPaidSponsorshipModel = [Sponsorships]()
    var barterSponsorshipModel = [Sponsorships]()
    var mostAppliedSponsorshipModel = [Sponsorships]()
    
    var sponsorshipArray = [[Sponsorships]()]
    
    var queryArray = [Query]()
    
    var SponsorshipSectionHeaderArray: [String] = []
    
    
    var subscriptionBanner: Query {
        return SLIDER_REF.order(by: "below", descending: true)
    }
    
    var isYour: Query {
        
        let currentUserId = Auth.auth().currentUser!.uid
       
        return SPONSORSHIP_REF.whereField("userId", isEqualTo: currentUserId).order(by: "creationDate", descending: true)
        
    }
    var isLatest: Query {
        return SPONSORSHIP_REF.whereField("isApproved", isEqualTo: true).order(by: "creationDate", descending: true)
    }
    
    
    var isPaid: Query {
        return SPONSORSHIP_REF.whereField("isApproved", isEqualTo: true).order(by: "price", descending: true)
    }
    
    var isBarter: Query {
        return SPONSORSHIP_REF.whereField("barter", isEqualTo: true).whereField("isApproved", isEqualTo: true).order(by: "creationDate", descending: true)
    }
    
    
    var isMostApplied: Query {
        return SPONSORSHIP_REF.whereField("isApproved", isEqualTo: true).order(by: "applied", descending: true)
    }

    
    
    //**IMP:-  use dispatch group here also **
    
    //    func firebase(dispatchGroup: DispatchGroup) {
    //        ...
    //        // this is an async call vv
    //        db.collection(test).getDocuments { (snapshot, err) in
    //            ... // all the code
    //            // NOW that you're done, leave the group
    //            dispatchGroup.leave()
    //        }
    //    }
    
  
    
    
    
    func getSponsorshipData(query:Query, completionHandler: @escaping ([Sponsorships]?, Error?) -> Void) {
        
        
        query.limit(to:10).getDocuments { (snapshot, error) in
            if let _ = error{
   
                completionHandler(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            self.sponsorships.removeAll()
            
            for document in snapshot.documents{
                let data = document.data()
                
                
                let userId = data["userId"] as? String ?? ""
                let price = data["price"] as? Int ?? 0
                let platforms = data["platforms"] as? [String] ?? [String]()
                let name = data["name"] as? String ?? ""
                let minFollowers = data["minFollowers"] as? Int ?? 0
                let gender = data["gender"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let currency = data["currency"] as? String ?? ""
                let creationDate = data["creationDate"] as? Double ?? 0
                let influencers = data["influencers"] as? [String] ?? [String]()
                let categories = data["categories"] as? [String] ?? [String]()
                let campaignId = data["campaignId"] as? String ?? ""
                let isApproved = data["isApproved"] as? Bool ?? false
                let selectedUser = data["selectedUsers"] as? [String] ?? [String]()
                let blob = data["blob"] as? [Dictionary<String, String>] ?? [Dictionary<String, String>]()
                let sponsorship = Sponsorships(userId: userId, price: price, platforms: platforms, name: name, gender: gender, minFollowers: minFollowers, description: description, currency: currency, creationDate: creationDate, influencers: influencers, categories: categories, campaignId: campaignId, isApproved: isApproved, selectedUsers: selectedUser, blob: blob)
                self.sponsorships.append(sponsorship)
                
            }
            
            completionHandler(self.sponsorships, nil)
            
        }
    }
    
    
    
    func sponsorshipArrayAppendTask(completion: @escaping () -> Void) {
        BannerApiCall()
        self.SponsorshipSectionHeaderArray.removeAll()
        self.sponsorshipArray.removeAll()
        self.queryArray.removeAll()
        
        SponsorshipSectionHeaderArray = ["Campaigns Posted By You","Latest Sponsorships","Highest Paid Sponsorships","Barter Sponsorships","Most Applied Sponsorships"]
        
        queryArray = [isYour,isLatest,isPaid,isBarter,isMostApplied]
        
        self.group.enter()
        
        
        getSponsorshipData(query : isYour, completionHandler: {
            result,error in
            
            self.isYourSponsorshipModel = result ?? []
            if self.isYourSponsorshipModel.count == 0 {
                self.SponsorshipSectionHeaderArray.remove(at: 0)
                self.queryArray.remove(at: 0)
            }
            
            self.group.leave()
            
            
        })
        
        
        self.group.enter()
        
        getSponsorshipData(query: isLatest, completionHandler: {
            result,error in
            
            self.latestSponsorshipModel = result ?? []
            if self.latestSponsorshipModel.count == 0 {
                self.SponsorshipSectionHeaderArray.remove(at: 1)
                self.queryArray.remove(at: 1)
                
            }
            
            
            self.group.leave()
            
        })
        
        self.group.enter()
        
        getSponsorshipData(query: isPaid, completionHandler: {
            result,error in
            self.highPaidSponsorshipModel = result ?? []
            if self.highPaidSponsorshipModel.count == 0 {
                self.SponsorshipSectionHeaderArray.remove(at: 2)
                self.queryArray.remove(at: 2)
            }
            
            self.group.leave()
            
        })
        
        
        
        self.group.enter()
        
        getSponsorshipData(query: isBarter, completionHandler: {
            result,error in
            
            self.barterSponsorshipModel = result ?? []
            if self.barterSponsorshipModel.count == 0 {
                self.SponsorshipSectionHeaderArray.remove(at: 3)
                self.queryArray.remove(at: 3)
            }
            
            self.group.leave()
            
        })
        
        self.group.enter()
        
        getSponsorshipData(query: isMostApplied, completionHandler: {
            result,error in
            
            self.mostAppliedSponsorshipModel = result ?? []
            if self.mostAppliedSponsorshipModel.count == 0 {
                self.SponsorshipSectionHeaderArray.remove(at: 4)
                self.queryArray.remove(at: 4)
            }
            print("task 5")
            self.group.leave()
            
        })
        
        
        self.group.notify(queue: .main) { [ self] in
            
            self.sponsorshipArray = [isYourSponsorshipModel,latestSponsorshipModel,highPaidSponsorshipModel,barterSponsorshipModel,mostAppliedSponsorshipModel].filter{$0.isEmpty==false}
            
            completion()
            
        }
        
        
    }
    
    
    func BannerApiCall()   {
        
        subscriptionBanner.getDocuments { (snapshot, error) in
            if let _ = error{
                
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            
            
            for document in snapshot.documents{
                let data = document.data()
        
                let imageURL = data["imageUrl"]  as? String ?? ""
                let sponsorship = data["sponsorship"] as? Int ?? 0
                let below = data["below"] as? String ?? ""
                let clickAction = data["clickAction"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                
                let slider = Slider(imageURL: imageURL , sponsorship: sponsorship, below: below, clickAction: clickAction, title: title)
                
                if below != "" {
                    self.slider.append(slider)
                }
                
                
            }
        }
        
    }
    
}
