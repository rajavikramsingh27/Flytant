//
//  SceneDelegate.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import SwiftToast
import PushKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SINClientDelegate, SINCallClientDelegate, SINManagedPushDelegate, PKPushRegistryDelegate{
   
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer = Timer()
    var timeCount = 0
    
    var client: SINClient!
    var push: SINManagedPush!
    var callKitProvider: SINCallKitProvider!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = checkLogin()
        window?.makeKeyAndVisible()
        configureNavigationvBar()
        configureToast()
        
        self.voipRegistration()
        self.push = Sinch.managedPush(with: .development)
        self.push.delegate = self
        self.push.setDesiredPushTypeAutomatically()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {return}
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func configureNavigationvBar(){
//        UINavigationBar.appearance().barTintColor = UIColor(red:16/255, green:143/255, blue:181/255, alpha:1)
//        UINavigationBar.appearance().tintColor = .white
    }
    
    func configureToast(){
        SwiftToast.defaultValue.backgroundColor = UIColor.systemBlue
        SwiftToast.defaultValue.image = UIImage(named: "toastAlert")
        SwiftToast.defaultValue.style = .bottomToTop
        SwiftToast.defaultValue.font = UIFont.systemFont(ofSize: 16)
        SwiftToast.defaultValue.textColor = UIColor.white
        SwiftToast.defaultValue.duration = 3.0
        SwiftToast.defaultValue.minimumHeight = CGFloat(100.0)
        SwiftToast.defaultValue.statusBarStyle = .darkContent
    }
    
    func checkLogin() -> UIViewController? {
        if Auth.auth().currentUser != nil {
            guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
            //self.push.registerUserNotificationSetting()
            self.initSinchWithUserId(userId: currentUserId)
            let navigation = UINavigationController(rootViewController: MainTabVC())
            navigation.isNavigationBarHidden = true
            return navigation
        } else {
            let displayVC = DisplayVC()
            return UINavigationController(rootViewController: displayVC)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //Location
        //appDelegate.locationManagerStart()
        
        var top = self.window?.rootViewController
        
        while(top?.presentedViewController != nil){
            top = top?.presentedViewController
        }
        if top! is UITabBarController{
            setBadges(controller: top as! UITabBarController)
        }
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        USER_REF.document(currentUserId).updateData(["isOnline": true])
        
        
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        //Calculate time
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        debugPrint(UserDefaults.standard.integer(forKey: UPVOTE_CREDITS))
          if callKitProvider != nil {
               let call = callKitProvider.currentEstablishedCall()

               if call != nil {
                   var top = self.window?.rootViewController

                   while (top?.presentedViewController != nil) {
                       top = top?.presentedViewController
                   }


                   if !(top! is UITabBarController) {
                       let callVC = CallVC()

                       callVC.call = call

                       top?.present(callVC, animated: true, completion: nil)
                   }
               }
           }
    }

    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //timer
        let postInteractionCredit = UserDefaults.standard.integer(forKey: POST_INTERACTED)
        var upvoteCredits = UserDefaults.standard.integer(forKey: UPVOTE_CREDITS)
        upvoteCredits += Int(timeCount/100) * postInteractionCredit
        UserDefaults.standard.set(upvoteCredits, forKey: UPVOTE_CREDITS)
        UserDefaults.standard.set(0, forKey: POST_INTERACTED)
        timer.invalidate()
        timeCount = 0
        
        
        appDelegate.locationManagerStop()
        
        recentBadgeHandler?.remove()
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        USER_REF.document(currentUserId).updateData(["isOnline": false])
    }
    
    
//    MARK: - PushNotificationDelegates
    
    
//    MARK: - Sinch
    
    func initSinchWithUserId(userId: String){
        if client == nil{
            client = Sinch.client(withApplicationKey: SINCH_KEY, applicationSecret: SINCH_SECRET, environmentHost: "sandbox.sinch.com", userId: userId)
            client.delegate = self
            client.call()?.delegate = self
            client.setSupportCalling(true)
            client.enableManagedPushNotifications()
            client.start()
            client.startListeningOnActiveConnection()
            callKitProvider = SINCallKitProvider(withClient: client)
        }
    }
    
    func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
        let result = SINPushHelper.queryPushNotificationPayload(payload)
        if (result?.isCall())!{
            debugPrint("Incoming push payload")
            self.handleRemoteNotification(userInfo: payload as NSDictionary)
        }
    }
    
    func handleRemoteNotification(userInfo: NSDictionary){
        if client == nil{
            guard let userId = Auth.auth().currentUser?.uid else {return}
            self.initSinchWithUserId(userId: userId)
        }
        
        let result = client.relayRemotePushNotification(userInfo as? [AnyHashable: Any])
        if (result?.isCall())!{
            debugPrint("Handle Call Notification")
        }
        
//        Here
//        if (result?.isCall())! && ((result?.call()?.isCallCanceled) != nil){
//            debugPrint("")
//            self.presentMissedCallNotificationWithRemoteUserId(userId: (result?.call()?.callId)!)
//        }
        
    }
    
    func presentMissedCallNotificationWithRemoteUserId(userId: String){
        if UIApplication.shared.applicationState == .background{
            DataService.instance.fetchPartnerUser(with: userId) { (user) in
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Missed Call"
                content.body = ""
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let _ = error{
                        return
                    }
                }
            }
        }
    }
    
//    MARK: - SinchCallClientDelegate
    
    func client(_ client: SINCallClient!, willReceiveIncomingCall call: SINCall!) {
        debugPrint("Will recive incoming call")
        callKitProvider.reportNewIncomingCall(call: call)
    }
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        var top = self.window?.rootViewController
        while (top?.presentedViewController != nil) {
            top = top?.presentedViewController
        }
        
        let callVC = CallVC()
        callVC.call = call
        let navController = UINavigationController(rootViewController: callVC)
        navController.modalPresentationStyle = .fullScreen
        top?.present(navController, animated: true, completion: nil)
    }
    
//    MARK: - SinchClientDelegate
    
    func clientDidStart(_ client: SINClient!) {
        
    }
    
    func clientDidStop(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
    }
    
    func voipRegistration(){
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
//    MARK: - PKPushDelegate
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
           
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        self.handleRemoteNotification(userInfo: payload.dictionaryPayload as NSDictionary)
    }
    
    
//    MARK: - Timer Handler
    
    @objc func updateTimer(){
        timeCount += 1
    }
}

