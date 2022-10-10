//
//  MessagesVC.swift
//  Flytant
//
//  Created by Vivek Rai on 08/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import IQAudioRecorderController
import AVKit
import SKPhotoBrowser
import ProgressHUD
import AVFoundation
import FirebaseFirestore

class MessagesVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IQAudioRecorderViewControllerDelegate {
    
//    MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var messages = [JSQMessage]()
    var objectMessages = [NSDictionary]()
    var loadedMessages = [NSDictionary]()
    var pictureMessages = [String]()
    var group: NSDictionary?
    var withUsers = [Users]()
    var blockedUsers = [String]()
    
    var typingCounter = 0
    var isGroup: Bool?
    var chatRoomId: String?
    var memberIds: [String]?
    var membersToPush: [String]?
    var chatTitle: String?
    var otherMemberUserId = ""
    
    var jsqAvatarDictionary: NSMutableDictionary?
    var avatarImageDictionary: NSMutableDictionary?
    var showAvatars = true
    var firstLoad: Bool?
    
    var typingListener: ListenerRegistration?
    var newChatListener: ListenerRegistration?
    var updatedChatListener: ListenerRegistration?
    
    let legitMessageTypes = ["text", "audio", "video", "location", "picture"]
    var isInitialLoadComplete = false
    var maxMessagesNumber = 0
    var minMessagesNumber = 0
    var isOldMessagesLoaded = false
    var loadedMessagesCount = 0
    
//    MARK: - Views
    
    var outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.label)
    var incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.systemGray3)

    let navigationTitleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 20, image: UIImage())
    
    let profileNameLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    
    let statusLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .left, textColor: UIColor.label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        
        createTypingObserver()
        setJSQInitials()
        loadMessages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let chatRoomId = self.chatRoomId else {return}
        setCustomNavBarView()
        configureNavigationBar()
        ChatService.instance.clearRecentCounter(chatRoomId: chatRoomId)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
        fetchBlockedUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let chatRoomId = self.chatRoomId else {return}
        navigationTitleView.removeFromSuperview()
        ChatService.instance.clearRecentCounter(chatRoomId: chatRoomId)
        //navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
        removeListeners()
    }
    
    override func viewDidLayoutSubviews() {
        perform(Selector(("jsq_updateCollectionViewInsets")))
    }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
    }
    
    private func setJSQInitials(){
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(delete))
        collectionView.backgroundColor = UIColor.systemBackground
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        self.senderId = currentUserId
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            self.senderDisplayName = user.username
        }
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //  Custom Send Button
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "microphone"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        
        jsqAvatarDictionary = [:]
        
        setChatBackgroundImage()
    }
    
    func setChatBackgroundImage() {
        if UserDefaults.standard.object(forKey: CHAT_BACKGROUND) != nil {
            self.collectionView.backgroundColor = .clear
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            imageView.image = UIImage(named: UserDefaults.standard.object(forKey: CHAT_BACKGROUND) as! String)!
            imageView.contentMode = .scaleAspectFill
            
            self.view.insertSubview(imageView, at: 0)
        }
    }
    
//    MARK: - JSQMessages DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if let currentUserId = Auth.auth().currentUser?.uid{
            let data = messages[indexPath.row]
            if data.senderId == currentUserId{
                cell.textView?.textColor = UIColor.systemBackground
            }else{
                cell.textView?.textColor = UIColor.label
            }
            return cell
        }
        return JSQMessagesCollectionViewCell()
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if let currentUserId = Auth.auth().currentUser?.uid{
            let data = messages[indexPath.row]
            if data.senderId == currentUserId{
                return outgoingBubble
            }else{
                return incomingBubble
            }
        }
        return outgoingBubble
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.row % 3 == 0{
            let message = messages[indexPath.row]
            return JSQMessagesTimestampFormatter.shared()?.attributedTimestamp(for: message.date)
        }
        return nil
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.row % 3 == 0{
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = objectMessages[indexPath.row]

        let status: NSAttributedString!
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        switch message["status"] as! String{
        case "delivered":
            status = NSAttributedString(string: "delivered")
        case "read":
            let statusText = "Read \(Date(timeIntervalSince1970: (message["creationDate"] as! Double)).timeAgoToDisplay())"
            status = NSAttributedString(string: statusText, attributes: attributedStringColor)
        default:
            status = NSAttributedString(string: "☑️")
        }
        
        if indexPath.row == messages.count-1{
            return status
        }else{
            return NSAttributedString(string: "")
        }
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {

        let message = messages[indexPath.row]
        if let currentUserId = Auth.auth().currentUser?.uid{
            if message.senderId == currentUserId{
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
//    MARK: - JSQMessgaes Delegates
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if self.blockedUsers.contains(currentUserId){
            ProgressHUD.showFailed("Unable to send message to this user.")
        }else{
            
             let camera = Camera(delegate_: self)
                    
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let takePhotOrVideo = UIAlertAction(title: "Camera", style: .default) { (action) in
                camera.PresentMultyCamera(target: self, canEdit: true)
            }
    //        camera.setValue(UIImage(named: "cameraAddIcon"), forKey: "image")
            let photo = UIAlertAction(title: "Photo", style: .default) { (action) in
                camera.PresentPhotoLibrary(target: self, canEdit: true)
            }
    //        photo.setValue(UIImage(named: "pickImagesIcon"), forKey: "image")
            let video = UIAlertAction(title: "Video", style: .default) { (action) in
                camera.PresentVideoLibrary(target: self, canEdit: true)
            }
    //        video.setValue(UIImage(named: "pickImagesIcon"), forKey: "image")
            let location = UIAlertAction(title: "Location", style: .default) { (action) in
                if self.haveAccessToUserLocation(){
                    self.sendMessages(text: nil, creationDate: Int(NSDate().timeIntervalSince1970), picture: nil, location: "location", video: nil, audio: nil)
                }
            }
    //        location.setValue(UIImage(named: "locationIcon"), forKey: "location")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.addAction(takePhotOrVideo)
            optionMenu.addAction(photo)
            optionMenu.addAction(video)
            optionMenu.addAction(location)
            optionMenu.addAction(cancel)

            //for iPad not to crash
            if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                    currentPopoverpresentioncontroller.sourceView = self.inputToolbar.contentView.leftBarButtonItem
                    currentPopoverpresentioncontroller.sourceRect = self.inputToolbar.contentView.leftBarButtonItem.bounds
                    currentPopoverpresentioncontroller.permittedArrowDirections = .up
                    self.present(optionMenu, animated: true, completion: nil)
                }
            }else{
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if self.blockedUsers.contains(currentUserId){
            ProgressHUD.showFailed("Unable to send message to this user.")
        }else{
            if text != ""{
                self.sendMessages(text: text, creationDate: Int(NSDate().timeIntervalSince1970), picture: nil, location: nil, video: nil, audio: nil)
                updateSendButton(isSend: false)
            }else{
                let audioVC = AudioViewController(delegate_: self)
                audioVC.presentAudioRecorder(target: self)
            }
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        self.loadMoreMessages(maxNumber: maxMessagesNumber, minNumber: minMessagesNumber)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let messageDictionary = objectMessages[indexPath.row]
        let messageType = messageDictionary["type"] as! String
        
        switch messageType{
            case "picture":
                let message = messages[indexPath.row]
                let mediaItem = message.media as! JSQPhotoMediaItem
                var images = [SKPhoto]()
                if mediaItem != nil{
                    let photo = SKPhoto.photoWithImage(mediaItem.image)
                    images.append(photo)
                    let browser = SKPhotoBrowser(photos: images)
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: {})
                }else{
                    return
                }
            case "video":
                let message = messages[indexPath.row]
                let mediaItem = message.media as! VideoMessage
                let player = AVPlayer(url: mediaItem.fileURL! as URL)
                let moviePlayer = AVPlayerViewController()
                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                moviePlayer.player = player
                self.present(moviePlayer, animated: true) {
                    moviePlayer.player?.play()
                }
            case "location":
                let message = messages[indexPath.row]
                let mediaItem = message.media as! JSQLocationMediaItem
                let mapViewVC = MapViewVC()
                mapViewVC.location = mediaItem.location
                self.navigationController?.pushViewController(mapViewVC, animated: true)
            case "audio":
                debugPrint("Audio Tapped")
            default:
                debugPrint("Unknown message Tapped")
        }
            
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        super.collectionView(collectionView, shouldShowMenuForItemAt: indexPath)
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if messages[indexPath.row].isMediaMessage{
            if action.description == "delete:"{
                return true
            }else{
                return false
            }
        }else{
            if action.description == "delete:" || action.description == "copy:"{
                return true
            }else{
                return false
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        guard let chatRoomId = self.chatRoomId else {return}
        let messageId = objectMessages[indexPath.row]["messageId"] as! String
        objectMessages.remove(at: indexPath.row)
        messages.remove(at: indexPath.row)
        OutgoingMessages.deleteMessage(withId: messageId, chatRoomId: chatRoomId)
    }
    
//    MARK: - Custom Send Button
    
    override func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty{
            updateSendButton(isSend: true)
        }else{
            updateSendButton(isSend: false)
        }
    }
    
    private func updateSendButton(isSend: Bool){
        if isSend{
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "send"), for: .normal)
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }else{
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "microphone"), for: .normal)
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
    
//    MARK: - IQAudioDelegate
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        controller.dismiss(animated: true)
        self.sendMessages(text: nil, creationDate: Int(NSDate().timeIntervalSince1970), picture: nil, location: nil, video: nil, audio: filePath)
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        controller.dismiss(animated: true)
    }
    
//    MARK: - Location Access
    
    func haveAccessToUserLocation() -> Bool{
        if appDelegate.locationManager != nil{
            return true
        }else{
            ProgressHUD.showError("Please give access to Location in settings.")
            return false
        }
    }
    
//    MARK: - Typing Indicator
    
    private func createTypingObserver(){
        guard let chatRoomId = self.chatRoomId else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        typingListener = TYPING_REF.document(chatRoomId).addSnapshotListener({ (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            if snapshot.exists{
                for data in snapshot.data()!{
                    if data.key != currentUserId{
                        let typing = data.value as! Bool
                        self.showTypingIndicator = typing
                        if typing{
                            self.scrollToBottom(animated: true)
                        }
                    }
                }
            }else{
                TYPING_REF.document(chatRoomId).setData([currentUserId: false])
            }
        })
    }
    
    private func typingCounterStart(){
        typingCounter += 1
        typingCounterSave(typing: true)
        self.perform(#selector(self.typingCounterStop), with: nil, afterDelay: 2.0)
    }
    
    @objc private func typingCounterStop(){
        typingCounter -= 1
        if typingCounter == 0{
            typingCounterSave(typing: false)
        }
    }
    
    private func typingCounterSave(typing: Bool){
        guard let chatRoomId = self.chatRoomId else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        TYPING_REF.document(chatRoomId).updateData([currentUserId: typing])
    }

//    MARK: - UITextViewDelegate
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        typingCounterStart()
        
        return true
    }
    
//    MARK: - Send Messages
    
    private func sendMessages(text: String?, creationDate: Int, picture: UIImage?, location: String?, video: NSURL?, audio: String?){
        var outgoingMessage: OutgoingMessages!
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let currentUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        guard let chatRoomId = self.chatRoomId else {return}
        guard let memberIds = self.memberIds else {return}
        guard let membersToPush = self.membersToPush else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            // text
            if let text = text{
                outgoingMessage = OutgoingMessages(message: text, senderId: currentUserId, senderUsername: user.username, creationDate: Double(creationDate), status: "delivered", type: "text")
            }
            // picture
            if let pic = picture{
                uploadImage(image: pic, chatRoomId: chatRoomId, view: (self.navigationController?.view)!) { (imageLink) in
                    if imageLink != nil{
                        let text = "🌄 Photo"
                        outgoingMessage = OutgoingMessages(message: text, pictureLink: imageLink!, senderId: currentUserId, senderUsername: currentUsername, creationDate: Double(creationDate), status: "delivered", type: "picture")
                        JSQSystemSoundPlayer.jsq_playMessageSentSound()
                        self.finishSendingMessage()
                        outgoingMessage.sendMessages(chatRoomId: chatRoomId, messageDictionary: outgoingMessage.messageDictionary, memberIds: memberIds, membersToPush: membersToPush)
                    }
                }
                return
            }
            // video
            if let video = video{
                let videoData = NSData(contentsOfFile: video.path!)
                let thumbnailData = videoThumbnail(video: video).jpegData(compressionQuality: 0.3)
                uploadVideo(video: videoData!, chatRoomId: chatRoomId, view: (self.navigationController?.view)!) { (videoLink) in
                    if videoLink != nil{
                        let text = "📹 Video"
                        outgoingMessage = OutgoingMessages(message: text, videoLink: videoLink!, thumbnail: thumbnailData! as NSData, senderId: currentUserId, senderUsername: currentUsername, creationDate: Double(creationDate), status: "delivered", type: "video")
                        JSQSystemSoundPlayer.jsq_playMessageSentSound()
                        self.finishSendingMessage()
                        outgoingMessage.sendMessages(chatRoomId: chatRoomId, messageDictionary: outgoingMessage.messageDictionary, memberIds: memberIds, membersToPush: membersToPush)
                    }
                }
                return
            }
            // audio
            if let audioPath = audio{
                uploadAudio(autioPath: audioPath, chatRoomId: chatRoomId, view: (self.navigationController?.view)!) { (audioLink) in
                    if audioLink != nil{
                        let text = "🎙️ Audio"
                        outgoingMessage = OutgoingMessages(message: text, audioLink: audioLink!, senderId: currentUserId, senderUsername: currentUsername, creationDate: Double(creationDate), status: "delivered", type: "audio")
                        JSQSystemSoundPlayer.jsq_playMessageSentSound()
                        self.finishSendingMessage()
                        outgoingMessage.sendMessages(chatRoomId: chatRoomId, messageDictionary: outgoingMessage.messageDictionary, memberIds: memberIds, membersToPush: membersToPush)
                    }
                }
                return
            }
            
            // location
            if location != nil{
                let latitude: NSNumber = NSNumber(value: self.appDelegate.coordinates!.latitude)
                let longitude: NSNumber = NSNumber(value: self.appDelegate.coordinates!.longitude)
                let text = "🗺️ Location"
                outgoingMessage = OutgoingMessages(message: text, latitude: latitude, longitude: longitude, senderId: currentUserId, senderUsername: currentUsername, creationDate: Double(creationDate), status: "delivered", type: "location")
            }
            
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.finishSendingMessage()
            outgoingMessage.sendMessages(chatRoomId: chatRoomId, messageDictionary: outgoingMessage.messageDictionary, memberIds: memberIds, membersToPush: membersToPush)
            
        }
    }
    
//    MARK: - Load Messages
    
    private func fetchBlockedUsers(){
        guard let otherMemberUserId = self.memberIds?.last else {return}
        USER_REF.document(otherMemberUserId).getDocument { (snapshot, error) in
            if let _ = error{
                return
            }
            guard let snapshot = snapshot else {return}
            let data = snapshot.data()
            let blockedUsers = data?["blockedUsers"] as? [String] ?? [String]()
            self.blockedUsers = blockedUsers
        }
    }
    
    private func loadMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let chatRoomId = self.chatRoomId else {return}
        
        // update message status
        updatedChatListener = MESSAGE_REF.document(currentUserId).collection(chatRoomId).addSnapshotListener{ (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            snapshot.documentChanges.forEach({ (diff) in
                if diff.type == .modified{
                    self.updateMessage(messageDictionary: diff.document.data() as NSDictionary)
                }
                
            })
        }
        
        //  Get last 11 messages
        MESSAGE_REF.document(currentUserId).collection(chatRoomId).order(by: "creationDate", descending: true).limit(to: 11).getDocuments{ (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {
                self.isInitialLoadComplete = true
                self.listenForNewChats()
                return
            }
            
            let sorted = (ChatService.instance.dictionaryFromSnapshots(snapshots: snapshot.documents) as NSArray).sortedArray(using: [NSSortDescriptor(key: "creationDate", ascending: true)]) as! [NSDictionary]
            self.loadedMessages = self.removeBadMessages(allMessages: sorted)
            self.insertMessages()
            self.finishReceivingMessage(animated: true)
            self.isInitialLoadComplete = true
            self.getPictureMessages()
            self.loadOldMessagesInBackground()
            self.listenForNewChats()
        }
    }
    
    private func listenForNewChats(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let chatRoomId = self.chatRoomId else {return}
        var lastMessageDate = 0
        
        if loadedMessages.count > 0 {
            lastMessageDate = (loadedMessages.last!["creationDate"] as! Int)
        }
        
        newChatListener = MESSAGE_REF.document(currentUserId).collection(chatRoomId).whereField("creationDate", isGreaterThan: lastMessageDate).addSnapshotListener{ (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty{
                for diff in snapshot.documentChanges{
                    if diff.type == .added{
                        let item = diff.document.data() as NSDictionary
                        if let type = item["type"]{
                            if self.legitMessageTypes.contains(type as! String){
                                if type as! String == "picture"{
                                    self.addNewPictureMessageLink(link: item["picture"] as! String)
                                }
                                
                                if self.insertInitialLoadMessages(messageDictionary: item) ?? false{
                                    JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                                }
                                self.finishReceivingMessage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadOldMessagesInBackground(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let chatRoomId = self.chatRoomId else {return}
        if loadedMessages.count > 10{
            let firstMessageDate = (loadedMessages.first!["creationDate"] as! Int)
            
            MESSAGE_REF.document(currentUserId).collection(chatRoomId).whereField("creationDate", isLessThan: firstMessageDate).getDocuments{ (snapshot, error) in
                if let _ = error{
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                let sorted = (ChatService.instance.dictionaryFromSnapshots(snapshots: snapshot.documents) as NSArray).sortedArray(using: [NSSortDescriptor(key: "creationDate", ascending: true)]) as! [NSDictionary]
                self.loadedMessages = self.removeBadMessages(allMessages: sorted) + self.loadedMessages
                
                self.getPictureMessages()
                
                self.maxMessagesNumber = self.loadedMessages.count - self.loadedMessagesCount - 1
                self.minMessagesNumber = self.maxMessagesNumber - NUMBER_OF_MESSAGES
                
            }
        }
    }
    
    private func updateMessage(messageDictionary: NSDictionary){
        for index in (0..<objectMessages.count){
            let temp = objectMessages[index]
            if messageDictionary["messageId"] as! String == temp["messageId"] as! String{
                objectMessages[index] = messageDictionary
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadMoreMessages(maxNumber: Int, minNumber: Int){
        if isOldMessagesLoaded{
            maxMessagesNumber = minNumber - 1
            minMessagesNumber = maxMessagesNumber - NUMBER_OF_MESSAGES
        }
        
        if minMessagesNumber < 0{
            minMessagesNumber = 0
        }
        
        for i in (minMessagesNumber...maxMessagesNumber).reversed(){
            let messageDictionary = loadedMessages[i]
            self.insertNewMessages(messageDictionary: messageDictionary)
            loadedMessagesCount += 1
        }
        
        isOldMessagesLoaded = true
        self.showLoadEarlierMessagesHeader = (loadedMessagesCount != loadedMessages.count)
    }
    
    private func insertNewMessages(messageDictionary: NSDictionary){
        guard let chatRoomId = self.chatRoomId else {return}
        let incomingMessage = IncomingMessages(collectionView: self.collectionView)
        let message = incomingMessage.createMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)!
        objectMessages.insert(messageDictionary, at: 0)
        messages.insert(message, at: 0)
    }
    
    private func insertMessages(){
        maxMessagesNumber = loadedMessages.count - loadedMessagesCount
        minMessagesNumber = maxMessagesNumber - NUMBER_OF_MESSAGES
        if minMessagesNumber < 0{
            minMessagesNumber = 0
        }
        for i in (minMessagesNumber..<maxMessagesNumber){
            let messageDictionary = loadedMessages[i]
            insertInitialLoadMessages(messageDictionary: messageDictionary)
            loadedMessagesCount += 1
        }
        self.showLoadEarlierMessagesHeader = (loadedMessagesCount != loadedMessages.count)
    }
    
    private func insertInitialLoadMessages(messageDictionary: NSDictionary) -> Bool?{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
        guard let chatRoomId = self.chatRoomId else {return nil}
        guard let memberIds = self.memberIds else {return nil}
        let incomingMessage = IncomingMessages(collectionView: self.collectionView)
        if ((messageDictionary["senderId"] as! String) != currentUserId){
            OutgoingMessages.updateMessage(withId: messageDictionary["messageId"] as! String, chatRoomId: chatRoomId, memberIds: memberIds)
        }
        guard let message = incomingMessage.createMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId) else {return nil}
        objectMessages.append(messageDictionary)
        messages.append(message)
        return isIncoming(messageDictionary: messageDictionary)
    }
    
    private func isIncoming(messageDictionary: NSDictionary) -> Bool?{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return nil}
        if (messageDictionary["senderId"] as! String) != currentUserId{
            return false
        }else{
            return true
        }
    }
   
    
    private func removeBadMessages(allMessages: [NSDictionary]) -> [NSDictionary]{
        var tempMessages = allMessages
        for message in tempMessages{
            if message["type"] != nil{
                if !self.legitMessageTypes.contains(message["type"] as! String){
                    tempMessages.remove(at: tempMessages.index(of: message)!)
                }
            }else{
                tempMessages.remove(at: tempMessages.index(of: message)!)
            }
        }
        return tempMessages
    }
    
    private func addNewPictureMessageLink(link: String){
        pictureMessages.append(link)
    }

    private func getPictureMessages(){
        pictureMessages.removeAll()
        for message in loadedMessages{
            if (message["type"] as! String) == "picture"{
                pictureMessages.append(message["picture"] as! String)
            }
        }
    }
    
//    MARK: - Custom Header
    
    private func setCustomNavBarView(){
        navigationController?.navigationBar.addSubview(navigationTitleView)
        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 56, paddingBottom: 0, paddingRight: 56, width: 0, height: 0)
        
        navigationTitleView.addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: navigationTitleView.leftAnchor, bottom: navigationTitleView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 40, height: 40)
        
        navigationTitleView.addSubview(profileNameLabel)
        profileNameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: navigationTitleView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        navigationTitleView.addSubview(statusLabel)
        statusLabel.anchor(top: profileNameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: navigationTitleView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
        
        navigationTitleView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        navigationTitleView.addGestureRecognizer(tapGesture)
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = UIColor.label
        infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButtonItem
        
        
        guard let firstMemberUserId = self.memberIds?.last else {return}
        guard let secondMemberUserId = self.memberIds?.first else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if currentUserId == firstMemberUserId{
            otherMemberUserId = secondMemberUserId
        }else{
            otherMemberUserId = firstMemberUserId
        }
        USER_REF.document(otherMemberUserId).addSnapshotListener { (snapshot, error) in
            if let _ = error{
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            
            let profileImageUrl = data["profileImageUrl"] as? String ?? DEFAULT_PROFILE_IMAGE_URL
            let username = data["username"] as? String ?? "unknown"
            let isOnline = data["isOnline"] as? Bool ?? false
            self.profileImageView.loadImage(with: profileImageUrl)
            self.profileNameLabel.text = username
            if isOnline{
                self.statusLabel.text = "Online"
            }else{
                self.statusLabel.text = ""
            }
        }
        
        
//        DataService.instance.fetchPartnerUser(with: otherMemberUserId) { (user) in
//            self.profileImageView.loadImage(with: user.profileImageURL)
//            self.profileNameLabel.text = user.username
//            self.statusLabel.text = "Online"
//        }
        
    }
    
//    MARK: -  Handlers
    
    @objc private func handleInfoTapped(){
        let mediaMessageVC = MediaMessageVC(collectionViewLayout: UICollectionViewFlowLayout())
        mediaMessageVC.allImageLinks = pictureMessages
        navigationController?.pushViewController(mediaMessageVC, animated: true)
        
    }
    
    @objc private func showGroup(){
        debugPrint("Show Group")
    }
    
    @objc private func showUserProfile(){
        let chatProfileVC = ChatProfileVC()
        chatProfileVC.userId = otherMemberUserId
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(chatProfileVC, animated: true)
    }
    
    private func removeListeners(){
        if typingListener != nil{
            typingListener?.remove()
        }
        if newChatListener != nil{
            newChatListener?.remove()
        }
        if updatedChatListener != nil{
            updatedChatListener?.remove()
        }
    }
    
//    MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let video = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        sendMessages(text: nil, creationDate: Int(NSDate().timeIntervalSince1970), picture: picture, location: nil, video: video, audio: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
}


//  Fix for iPhoneX
extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = window else { return }
        if #available(iOS 11.0, *) {
            let anchor = window.safeAreaLayoutGuide.bottomAnchor
            bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0).isActive = true
        }
    }
}
