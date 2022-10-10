//
//  FirebaseUploadImages.swift
//  Flytant
//
//  Created by Flytant on 08/10/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseStorage


class FirebaseUploadImages {
    
    static let shared = FirebaseUploadImages()
    
    let foldername = UUID().uuidString
    
    var currentUploadTask: StorageUploadTask?
    
    
    func upload(data: Data, withName filename: String, block: @escaping(_ url:String?) -> Void) {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        
        let fileRef = STORAGE_REF_CAMPAIGN_IMAGES.child(currentID + foldername)
        
        upload(data: data, withName: filename, atPath: fileRef) { (url) in
            block(url)
        }
    }
    
    
    func upload(data: Data, withName fileName: String, atPath path: StorageReference, block: @escaping(_ url: String?) -> Void) {
        
        self.currentUploadTask = path.putData(data, metadata: nil) { metaData, error in
            guard let _ = metaData else {
                block(nil)
                return
            }
            
            path.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    block(nil)
                    return
                }
                block(downloadURL.absoluteString)
            }
            
        }
        
    }
    
    
}
