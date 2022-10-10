//
//  UsersAroundVC.swift
//  Flytant
//
//  Created by Vivek Rai on 27/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import ProgressHUD

private let reuseIdentifier = "usersAroundCollectionViewCell"
private let headerIdentifier = "usersAroundHeader"
class UsersAroundVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UsersAroundHeaderDelegate, AnonymousLoginViewDelegate {
    
//    MARK: - Properties
    
    var manager = CLLocationManager()
    var latitude = ""
    var longitude = ""
    var distance: Double = 100
    var users = [Users]()
    var gender = "Male"
    var currentLocation: CLLocation?
    
//    MARK: - Views
    
    private var anonymousView = AnonymousView()
    let navigationView = UIView()
//    let slider: UISlider = {
//        var slider = UISlider()
//        slider.minimumValue = 1
//        slider.maximumValue = 999
//        slider.isContinuous = true
//        slider.value = Float(100)
//        slider.tintColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
//        return slider
//    }()
//    let distanceLabel = FLabel(backgroundColor: UIColor.clear, text: "100 miles", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .center, textColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1))
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        anonymousView.delegate = self
        
        configureLocationManager()
        
        configureCollectionView()
        configureRefreshControl()
        //fetchNearbyUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        //navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationView.removeFromSuperview()
//    }
    
//    MARK: - ConfigureViews
    
    private func setUpNavigationBar(){
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.addSubview(navigationView)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.tintColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        navigationView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 32, paddingBottom: 32, paddingRight: 16, width: 0, height: 0)
        
        
//        navigationItem.title = "Find Users"

    
//        navigationView.addSubview(distanceLabel)
//        distanceLabel.anchor(top: navigationView.topAnchor, left: nil, bottom: nil, right: navigationView.rightAnchor, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 60, height: 20)
//
//        navigationView.addSubview(slider)
//        slider.anchor(top: navigationView.topAnchor, left: navigationView.leftAnchor, bottom: nil, right: distanceLabel.leftAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
//        slider.addTarget(self, action: #selector(handleSlider(slider:event:)), for: .valueChanged)
        
    }
    
    private func configureCollectionView(){
        self.collectionView.register(UsersAroundCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UsersAroundHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.contentInset = UIEdgeInsets(top: 72, left: 0, bottom: 0, right: 0)
    }
    
    private func configureRefreshControl(){
       let refreshControl = UIRefreshControl()
       refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
       collectionView?.refreshControl = refreshControl
    }
    
    private func addAnonymousView(){
        view.addSubview(anonymousView)
        anonymousView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    private func removeAnonymousView(){
        anonymousView.removeFromSuperview()
    }
    
       
    private func showIndicatorView() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }

    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }

    

//    MARK: - CollectionView Header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UsersAroundHeader
        header.delegate = self
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 96)
    }

//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: CGFloat(exactly: width)!)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UsersAroundCollectionViewCell
        if !users.isEmpty{
            if let currentLocation = self.currentLocation{
                cell.loadUserData(user: users[indexPath.row], location: currentLocation)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            guard let userId = self.users[indexPath.row].userID else {return}
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Visit Profile", style: .default, handler: { (action) in
                DataService.instance.fetchPartnerUser(with: userId) { (user) in
                    let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                    profileVC.user = user
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Send Message", style: .default, handler: { (action) in
                DataService.instance.fetchPartnerUser(with: userId) { (user) in
                    self.showMessagesVC(user: user)
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

//    MARK: - Handlers
    
    func handleLogin() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DataService.instance.socialLogout()
            DataService.instance.resetDefaults()
            let displayVC = DisplayVC()
            displayVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(displayVC, animated: true)
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func handleCancel() {
        removeAnonymousView()
    }
    
    @objc private func handleRefresh(){
        saveUserCoordinateToDatabase()
    }
    
    @objc func handleRefresher(){
        fetchNearbyUsers()
    }
    
    func handleShowmap(for header: UsersAroundHeader) {
        if Auth.auth().currentUser!.isAnonymous{
            addAnonymousView()
        }else{
            let mapVC = MapVC()
            mapVC.users = self.users
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    func handleSegmentedControl(for header: UsersAroundHeader, sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gender = "Male"
            fetchNearbyUsers()
        case 1:
            self.gender = "Female"
            fetchNearbyUsers()
        case 2:
            self.gender = "Both"
            fetchNearbyUsers()
        default:
            break
        }
    }
    
    func handleSlider(for header: UsersAroundHeader, sender: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first{
            self.distance = Double(header.slider.value)
            header.distanceLabel.text = "\(Int(header.slider.value)) miles"

            switch touchEvent.phase {
            case .began:
                debugPrint("began")
            case .moved:
                debugPrint("moved")
            case .ended:
                self.fetchNearbyUsers()
            default:
                break
            }
        }
    }
    
    func configureLocationManager(){
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            manager.startUpdatingLocation()
        }
    }
}

extension UsersAroundVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse){
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("Location permission not given. Plase give location permission in setings.")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        guard let updatedLocations: CLLocation = locations.first else {return}
        let newCoordinate: CLLocationCoordinate2D = updatedLocations.coordinate
        self.currentLocation = updatedLocations
        debugPrint(newCoordinate.latitude, newCoordinate.longitude)
        UserDefaults.standard.set("\(newCoordinate.latitude)", forKey: LATITUDE_USERLOCATION)
        UserDefaults.standard.set("\(newCoordinate.longitude)", forKey: LONGITUDE_USERLOCATION)
        self.saveUserCoordinateToDatabase()
    }
    
    func saveUserCoordinateToDatabase(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if let latitude = UserDefaults.standard.string(forKey: LATITUDE_USERLOCATION), let longitude = UserDefaults.standard.string(forKey: LONGITUDE_USERLOCATION){
            let lat = Double(latitude) ?? 0
            let long = Double(longitude) ?? 0
            let geoPoint = GeoPoint(latitude: lat, longitude: long)
            let data = ["geoPoint": geoPoint] as [String: Any]
            USER_REF.document(currentUserId).updateData(data) { (error) in
                if let _ = error{
                    ProgressHUD.showError("An error occured while fetching users! Please try again.")
                }
                self.fetchNearbyUsers()
            }
            
        }else{
            
        }
    }
    
    private func fetchNearbyUsers(){
        if let latitude = UserDefaults.standard.string(forKey: LATITUDE_USERLOCATION), let longitude = UserDefaults.standard.string(forKey: LONGITUDE_USERLOCATION), let currentUserId = Auth.auth().currentUser?.uid{
            debugPrint("Come here")
            showIndicatorView()
            self.users.removeAll()
            
            let lat = Double(latitude) ?? 0
            let long = Double(longitude) ?? 0
            
            let convertedLat = 0.0144927536231884
            let convertedLon = 0.0181818181818182
            
            let lowerLat = lat - (convertedLat * self.distance)
            let lowerLon = long - (convertedLon * self.distance)
            
            
            let greaterLat = lat + (convertedLat * self.distance)
            let greaterLon = long + (convertedLon * self.distance)
            
            let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
            let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
            
            if lesserGeopoint.latitude >= -90 && lesserGeopoint.latitude <= 90 && lesserGeopoint.longitude >= -180 && lesserGeopoint.longitude <= 180 && greaterGeopoint.latitude >= -90 && greaterGeopoint.latitude <= 90 && greaterGeopoint.longitude >= -180 && greaterGeopoint.longitude <= 180{
                var query: Query = USER_REF
                if gender != "Both"{
                    query = USER_REF.whereField("gender", isEqualTo: self.gender)
                }
                query.whereField("geoPoint", isGreaterThan: lesserGeopoint).whereField("geoPoint", isLessThan: greaterGeopoint).getDocuments { (snapshot, error) in
                    if let _ = error{
                        self.dismissIndicatorView()
                        self.collectionView.refreshControl?.endRefreshing()
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        self.dismissIndicatorView()
                        self.collectionView.refreshControl?.endRefreshing()
                        return
                    }
                    
                    
                    for document in snapshot.documents{
                        let data = document.data()
                        debugPrint(data)
                        let bio = data["bio"] as? String ?? ""
                        let dateofBirth = data["dateOfBirth"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let gender = data["gender"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let profileImageURL = data["profileImageUrl"] as? String ?? ""
                        let userID = data["userId"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let websiteUrl = data["websiteUrl"] as? String ?? ""
                        let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                        let monetizationEnabled = data["monetizationEnabled"] as? Bool ?? false
                        let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                        let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, monetizationEnabled: monetizationEnabled, geoPoint: geoPoint)
                        if userID != currentUserId{
                            self.users.append(user)
                        }
                    }
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                    self.dismissIndicatorView()
                }
            }else{
                var query: Query = USER_REF
                if gender != "Both"{
                    query = USER_REF.whereField("gender", isEqualTo: self.gender)
                }
                query.getDocuments { (snapshot, error) in
                    if let _ = error{
                        self.dismissIndicatorView()
                        self.collectionView.refreshControl?.endRefreshing()
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        self.dismissIndicatorView()
                        self.collectionView.refreshControl?.endRefreshing()
                        return
                    }
                    
                    for document in snapshot.documents{
                        let data = document.data()
                        debugPrint(data)
                        let bio = data["bio"] as? String ?? ""
                        let dateofBirth = data["dateOfBirth"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let gender = data["gender"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let profileImageURL = data["profileImageUrl"] as? String ?? ""
                        let userID = data["userId"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let websiteUrl = data["websiteUrl"] as? String ?? ""
                        let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, phoneNumber: phoneNumber, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl)
                        if userID != currentUserId{
                            self.users.append(user)
                        }
                    }
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                    self.dismissIndicatorView()
                }
            }
            
        }
        
    }
    
    func showMessagesVC(user: Users){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (currentUser) in
            let messagesVC = MessagesVC()
            messagesVC.chatTitle = user.username
            messagesVC.memberIds = [currentUserId, user.userID]
            messagesVC.membersToPush = [currentUserId, user.userID]
            messagesVC.chatRoomId = ChatService.instance.startPrivateChat(user1: currentUser, user2: user)
            messagesVC.isGroup = false
            messagesVC.hidesBottomBarWhenPushed = true
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(messagesVC, animated: true)
        }
          
    }
}
