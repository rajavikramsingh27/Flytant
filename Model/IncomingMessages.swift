//
//  IncomingMessages.swift
//  Flytant
//
//  Created by Vivek Rai on 08/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Firebase

class IncomingMessages{
    
    var collectionView: JSQMessagesCollectionView
    
    init(collectionView: JSQMessagesCollectionView){
        self.collectionView = collectionView
    }
    
    func createMessage(messageDictionary: NSDictionary, chatRoomId: String) -> JSQMessage?{
        var message: JSQMessage?
        
        let type = messageDictionary["type"] as? String ?? ""
        
        switch type {
        case "text":
            message = createTextMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case "picture":
            message = createPictureMessage(messageDictionary: messageDictionary)
        case "video":
            message = createVideoMessage(messageDictionary: messageDictionary)
        case "audio":
            message = createAudioMessage(messageDictionary: messageDictionary)
        case "location":
            message = createLocationMessage(messageDictionary: messageDictionary)
        default:
            debugPrint("Unknown message type")
        }
        
        if let message = message{
            return message
        }else{
            return nil
        }
    }
    
//    MARK: - Create Message Types
    
    // text
    func createTextMessage(messageDictionary: NSDictionary, chatRoomId: String) -> JSQMessage{
        let username = messageDictionary["senderUsername"] as? String
        let senderId = messageDictionary["senderId"] as? String
        let creationDate = messageDictionary["creationDate"] as? Double ?? 0
        let text = messageDictionary["message"] as? String ?? ""
        return JSQMessage(senderId: senderId, senderDisplayName: username, date: Date(timeIntervalSince1970: creationDate), text: text)
    }
    
    // picture
    func createPictureMessage(messageDictionary: NSDictionary) -> JSQMessage?{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
        let username = messageDictionary["senderUsername"] as? String
        let senderId = messageDictionary["senderId"] as? String
        let creationDate = messageDictionary["creationDate"] as? Double ?? 0
        let mediaItem = PhotoMediaItem(image: nil)
        mediaItem?.appliesMediaViewMaskAsOutgoing = (currentUserId == senderId)
        downloadImage(imageUrl: messageDictionary["picture"] as! String) { (image) in
            if image != nil{
                mediaItem?.image = image
                self.collectionView.reloadData()
            }
        }
        
        return JSQMessage(senderId: senderId, senderDisplayName: username, date: Date(timeIntervalSince1970: creationDate), media: mediaItem)
    }
    
    // video
    func createVideoMessage(messageDictionary: NSDictionary) -> JSQMessage?{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
        let username = messageDictionary["senderUsername"] as? String
        let senderId = messageDictionary["senderId"] as? String
        let creationDate = messageDictionary["creationDate"] as? Double ?? 0
        let videoUrl = NSURL(fileURLWithPath: messageDictionary["video"] as! String)
        let mediaItem = VideoMessage(withFileURL: videoUrl, maskOutgoing: (currentUserId == senderId))
           
        downloadVideo(videoUrl: messageDictionary["video"] as! String) { (isReadyToPlay, fileName) in
            let url = NSURL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
            mediaItem.status = SUCCESS
            mediaItem.fileURL = url
            
            imageFromData(pictureData: messageDictionary["picture"] as! String) { (image) in
                if image != nil{
                    mediaItem.image = image
                    self.collectionView.reloadData()
                    
                }
            }
            self.collectionView.reloadData()
        }
           
           return JSQMessage(senderId: senderId, senderDisplayName: username, date: Date(timeIntervalSince1970: creationDate), media: mediaItem)
     }
    
     // audio
     func createAudioMessage(messageDictionary: NSDictionary) -> JSQMessage?{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
        let username = messageDictionary["senderUsername"] as? String
        let senderId = messageDictionary["senderId"] as? String
        let _ = messageDictionary["creationDate"] as? Double ?? 0
        let audioItem = JSQAudioMediaItem(data: nil)
        audioItem.appliesMediaViewMaskAsOutgoing = (currentUserId == senderId)
          
        let audioMessage = JSQMessage(senderId: senderId, displayName: username, media: audioItem)
        
        downloadAudio(audioUrl: messageDictionary["audio"] as! String) { (fileName) in
            let url = NSURL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
            let audioData = try? Data(contentsOf: url as URL)
            audioItem.audioData = audioData
            self.collectionView.reloadData()
        }
        
        return audioMessage!
     }
    
     // location
     func createLocationMessage(messageDictionary: NSDictionary) -> JSQMessage?{
         guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
         let username = messageDictionary["senderUsername"] as? String
         let senderId = messageDictionary["senderId"] as? String
         let creationDate = messageDictionary["creationDate"] as? Double ?? 0
         let latitude = messageDictionary["latitude"] as? Double
         let longitude = messageDictionary["longitude"] as? Double
         
         let mediaItem = JSQLocationMediaItem(location: nil)
         mediaItem?.appliesMediaViewMaskAsOutgoing = (currentUserId == senderId)
         let location = CLLocation(latitude: latitude!, longitude: longitude!)
         mediaItem?.setLocation(location, withCompletionHandler: {
             self.collectionView.reloadData()
         })
         return JSQMessage(senderId: senderId, senderDisplayName: username, date: Date(timeIntervalSince1970: creationDate), media: mediaItem)
     }
}
