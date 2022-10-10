//
//  AppDelegate.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import CoreLocation
import PushKit
import UserNotifications
import IQKeyboardManagerSwift
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    
    var locationManager: CLLocationManager?
    var coordinates: CLLocationCoordinate2D?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes =  [  NSAttributedString.Key.font: AppFont.font(type: .Bold, size: 22),NSAttributedString.Key.foregroundColor: UIColor.label]
        UINavigationBar.appearance().isTranslucent = false
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        RemoteConfigManager.configure(expirationDuration: 0)

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        //  Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //  Notification
        attemptToRegisterForNotification(application: application)
        
        var strRegionCode: String = ""
        
        if TARGET_IPHONE_SIMULATOR == 1 {
            //simulator
            strRegionCode = "IN"
            kLanguageCode = "en_US"
        } else {
            //device
            strRegionCode = Locale.current.regionCode!
            kLanguageCode  = Locale.preferredLanguages[0]
            kLanguageCode = kLanguageCode.replacingOccurrences(of: "-", with: "_")
        }
        
        let localThings = Locale.currency[strRegionCode]
        
        kCurrencySymbol = localThings!.symbol!
        kCurrencyCode = localThings!.code!
        kCurrencyName = localThings!.name!
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var google: Bool = false
        if let returnGoogle = (GIDSignIn.sharedInstance()?.handle(url)) {
         google = returnGoogle
        }
        let returnFB = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return google || returnFB
    }

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

//    MARK: - GoogleSignIn
    
   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error{
            return
        }
    }

    
//    MARK: - LocationManager
    
    func locationManagerStart(){
        if locationManager == nil{
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.startUpdatingLocation()
    }
    
    func locationManagerStop(){
        if locationManager != nil{
            locationManager?.stopUpdatingLocation()
        }
    }
    
//    MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed To Get Location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted:
            debugPrint("Restricted Location")
        case .denied:
            locationManager = nil
            debugPrint("Denied Location Access")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = locations.last?.coordinate
    }
    
//    MARK: - PushNotification Delegates
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return}
        sceneDelegate.push.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        //  Push Notifications
        debugPrint("Registered for notification with device token: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.canHandleNotification(userInfo){
            return
        }else{
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return}
            sceneDelegate.push.application(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
//    MARK: - Notifications
    
    func attemptToRegisterForNotification(application: UIApplication){
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, error) in
            if authorized{
                debugPrint("Successfully Registered for notifications")
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        debugPrint("Registered with FCM token: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}


