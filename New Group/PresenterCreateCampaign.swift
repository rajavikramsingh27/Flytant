


//  PresenterTrending.swift
//  Flytant-1
//  Created by GranzaX on 28/02/22.



import Foundation
import Firebase
import Alamofire



class PresenterCreateCampaign {
    static var campaignDocumentID = ""
    static var arrImages  = [UIImage]()
    
    class func createCampaign(completion: @escaping(Error) -> ()) {
        let errorFirebase = NSError()
        
        let dictData = [
            "userId": UserDefaults.standard.value(forKey: kUserIDFireBase)!,
            "price": strCampaignGiveAwayPay.contains("$") ? Int(strCampaignGiveAwayPay.replacingOccurrences(of: "$", with: ""))! : 0,
            "platforms": strCampaignPlateform.components(separatedBy: ","),
            "name": strCampaignName,
            "minFollowers": Int(strCampaignMinFollowers)!,
            "isApproved": false,
            "gender": strCampaignGender,
            "description": strCampaignDescription,
            "currency": "$",
            "creationDate": Int(Date().timeIntervalSince1970),
            "categories": strCampaignCategory.components(separatedBy: ","),
            "barterDescription": strCampaignGiveAwayPay.contains("$") ? "" : strCampaignGiveAwayPay,
            "barter": false,
            "applied": 0,
        ] as [String : Any]
        
        print(dictData)
        
        let campaign = Firestore.firestore().collection("sponsorship").addDocument(data: dictData)
        PresenterCreateCampaign.campaignDocumentID = campaign.documentID
        
        print(campaign.documentID)
        
        PresenterCreateCampaign.updateSponsorship([
            "campaignId": campaign.documentID
        ])
        
        PresenterCreateCampaign.uploadMedia {
            completion(errorFirebase)
        }
        
//        Firestore.firestore().collection("sponsorship").document(campaign.documentID).updateData([
//            "campaignId": campaign.documentID
//        ]) { (error) in
//            if let error = error {
//                print("error error error error error ")
//                print(error)
//                completion(error)
//            } else {
//                print("uploaded")
//                print(campaign.documentID)
//                completion(errorFirebase)
//            }
//        }
    }

    
    
    class func uploadMedia(completion: @escaping() -> ()) {
        var arrBlob = [[String: Any]]()
        
        for i in 0..<arrImages.count {
            let uniqueString = UUID().uuidString
            let storageRef = Storage.storage().reference()
                .child("sponsor_campaign_images")
                .child("\(UserDefaults.standard.value(forKey: kUserIDFireBase)!)")
                .child(uniqueString+".jpg")
            if let uploadData = arrImages[i].pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        storageRef.downloadURL { (url, error) in
                            let dictBlob = [
                                "path": url!.absoluteString,
                                "type": "image"
                            ]
                            
                            arrBlob.append(dictBlob)
                            
                            if arrImages.count == arrBlob.count {
                                PresenterCreateCampaign.updateSponsorship([
                                    "blob": arrBlob
                                ])
                                print("images uploaded")
                                completion()
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    class func updateSponsorship(_ dict: [String: Any]) {
        Firestore.firestore().collection("sponsorship").document(PresenterCreateCampaign.campaignDocumentID).updateData(dict) { (error) in
            if let error = error {
                print("error error error error error ")
                print(error)
            } else {
                print("updated")
            }
        }
        
    }
    
    
    
}

