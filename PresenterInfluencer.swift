//
//  PresenterTrending.swift
//  Flytant-1
//
//  Created by GranzaX on 28/02/22.
//

import Foundation
import Firebase
import Alamofire



class PresenterInfluencer {
    static var pageToken = ""
    static var limitTrending = 10
    static var limitTopInfluencers = 20
    static var limitTopStories = 3
    static var maxResults = 10
    static var totalResultsYoutube = 0
    
    class func getSlider(completion: @escaping([[String: Any]], Error) -> ()) {
        Firestore.firestore().collection("slider")
            .whereField("active", isEqualTo: true)
            .order(by: "preference", descending: false)
            .getDocuments{ (querySnapshot, error) in
                var errorFirebase = NSError()
                var arrSlider = [[String: Any]]()
                
                if let error = error {
                    print("error error error error error error error ")
                    print(error)
                    errorFirebase = error as NSError
                } else {
                    for document in querySnapshot!.documents {
                        var dictDocument = document.data() as [String: Any]
                        dictDocument["documentID"] = document.documentID
                        arrSlider.append(dictDocument)
                    }
                }
                
                print(arrSlider)
                completion(arrSlider, errorFirebase)
            }
    }
    
    class func trending(completion: @escaping([[String: Any]], Error) -> ()) {
        Firestore.firestore().collection("users")
            .whereField("shouldShowTrending", isEqualTo: true)
            .order(by: "socialScore", descending: true)
            .limit(to: limitTrending)
            .getDocuments{ (querySnapshot, error) in
                var errorFirebase = NSError()
                var arrTrendingUsers = [[String: Any]]()
                
                if let error = error {
                    print("error error error error error error error ")
                    print(error)
                    errorFirebase = error as NSError
                } else {
                    for document in querySnapshot!.documents {
                        let dictDocument = document.data() as [String: Any]
                        arrTrendingUsers.append(dictDocument)
                    }
                }
                
                print(arrTrendingUsers.count)
                completion(arrTrendingUsers, errorFirebase)
            }
    }
    
    class func topInfluencer(completion: @escaping([[String: Any]], Error) -> ()) {
        Firestore.firestore().collection("users")
            .whereField("shouldShowInfluencer", isEqualTo: true)
            .order(by: "socialScore", descending: true)
            .limit(to: limitTopInfluencers)
            .getDocuments{ (querySnapshot, error) in
                var errorFirebase = NSError()
                var arrTrendingUsers = [[String: Any]]()
                
                if let error = error {
                    print("error error error error error error error ")
                    print(error)
                    errorFirebase = error as NSError
                } else {
                    for document in querySnapshot!.documents {
                        let dictDocument = document.data() as [String: Any]
                        arrTrendingUsers.append(dictDocument)
                    }
                }
                
                print(arrTrendingUsers.count)
                completion(arrTrendingUsers, errorFirebase)
            }
    }
    
    class func topStories(completion: @escaping([[String: Any]], Error) -> ()) {
        Firestore.firestore().collection("blogs")
            .order(by: "creationDate", descending: true)
            .limit(to: limitTopStories)
            .getDocuments{ (querySnapshot, error) in
                var errorFirebase = NSError()
                var arrTrendingUsers = [[String: Any]]()
                
                if let error = error {
                    print("error error error error error error error ")
                    print(error)
                    errorFirebase = error as NSError
                } else {
                    for document in querySnapshot!.documents {
                        let dictDocument = document.data() as [String: Any]
                        arrTrendingUsers.append(dictDocument)
                    }
                }
                
                print(arrTrendingUsers.count)
                completion(arrTrendingUsers, errorFirebase)
            }
    }
    
    class func youTubeVideos(completion: @escaping([[String: Any]], Error) -> ()) {
        let baseURLYouTube = "https://www.googleapis.com/youtube/v3/search?"
        let key = "key=AIzaSyBTvE3AhvGvPU77j_Hb8GvFuxFFb4JIax0"
        let channelId = "channelId=UC_r46_UgBvaG2k94LDjEIWQ"
        let part = "part=id,snippet"
        let order = "order=date"
        let type = "type=video"
        
        let url = "\(baseURLYouTube)\(key)&\(channelId)&\(part)&\(order)&\(type)&maxResults=\(maxResults)&pageToken=\(pageToken)"
        print("url url url url url url url url url url url ")
        print(url)
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                var errorYouTube = NSError()
                var arrTrendingUsers = [[String: Any]]()
                
                switch response.result {
                
                case .success(let json):
                    let dictJSON = json as! [String: Any]
                    if let nextPageToken = dictJSON["nextPageToken"] as? String {
                        pageToken = nextPageToken
                    }
                    
                    if let items = dictJSON["items"] as? [[String: Any]] {
                        arrTrendingUsers = items
                    }
                    
                    if let pageInfo = dictJSON["pageInfo"] as? [String: Any] {
                        if let totalResults = pageInfo["totalResults"] as? Int {
                            totalResultsYoutube = totalResults
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    errorYouTube = error as NSError
                }
                
                completion(arrTrendingUsers, errorYouTube)
            }
    }
}

