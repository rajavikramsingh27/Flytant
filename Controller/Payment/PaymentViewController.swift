//
//  PaymentViewController.swift
//  Flytant
//
//  Created by Nitish Kumar on 06/02/22.
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase


class PaymentViewController: UIViewController {
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
      //  view.backgroundColor = .red
        view.heightAnchor.constraint(equalToConstant: 180).isActive = true
      view.backgroundColor = .clear
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
       // view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
  view.backgroundColor = .clear
        return view
    }()
    
    var subscriptionCollectionView : UICollectionView!
    
    let topViewTitle = UILabel()
    let ApplyCreditImage = UIImageView()
    let MsgCreditImage = UIImageView()
    
    let ApplyCreditLabel = UILabel()
    let MsgCreditLabel = UILabel()
    
    let user = Users(bio: "String", dateOfBirth: "String", email: "String", gender: "String", name: "String", socialScore: 0, shouldShowInfluencer: false, shouldShowTrending: false, username: "String", userID: "String", profileImageURL: "String", websiteUrl: "String",numberOfApplies:0,messageCredits:0, blockedUsers: ["String"], geoPoint: GeoPoint(latitude: 0, longitude: 0),  categories: ["String"], linkedAccounts:Dictionary<String, Any>())
    
    
    var isYour: Query {
        
        let currentUserId = Auth.auth().currentUser!.uid
       
        return USER_REF.whereField("userId", isEqualTo: currentUserId)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        setNavBar()
       
        setScrollView()
        
        getselectedUserData(query: isYour){ response,error  in
            
            self.ApplyCreditLabel.text = "\(response?.numberOfApplies ?? 0) " + "Apply credits"
            self.MsgCreditLabel.text =  "\(response?.numberOfApplies ?? 0) " + "Message credits"
        
            
        }

    }
    
    
    func getselectedUserData(query:Query, completionHandler: @escaping (Users?, Error?) -> Void) {
        
       // let query = SPONSORSHIP_REF.whereField("campaignId", isEqualTo: CampId)
        
        query.getDocuments { (snapshot, error) in
            if let _ = error{
   
                completionHandler(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            
            for document in snapshot.documents{
                
                let data = document.data()
              
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let numberOfApplies = data["numberOfApplies"] as? Int ?? 0
                let messageCredits = data["messageCredits"] as? Int ?? 0
                let socialScore = data["socialScore"] as? Int ?? 0
                let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
                let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [String]()
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, numberOfApplies: numberOfApplies, messageCredits: messageCredits, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
                completionHandler(user, error)
            }
            
       
            
        }

    }
    func getCredits(){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showTabBar()
    }
    
    private func setNavBar(){
        self.hideTabBar()
        self.title =  "Subscription"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "paymentHistory"), style: .done, target: self, action:nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    func setScrollView(){
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollViewContainer.addArrangedSubview(topView)
        scrollViewContainer.addArrangedSubview(bottomView)
        setTopView()
        configureCollectionView()
    }
    
    
    private func setTopView(){
        
      
        let planView = UIView()
        topView.addSubview(planView)
        planView.layer.cornerRadius = 15
        planView.backgroundColor = .secondarySystemBackground
        planView.anchor(top: topView.topAnchor, left: topView.leftAnchor, bottom: nil, right: topView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 160)
        
        topViewTitle.text = "NO PLAN ACTIVE"
        topViewTitle.font = AppFont.font(type: .Bold, size: 16)
        topViewTitle.textAlignment = .center
        planView.addSubview(topViewTitle)
        topViewTitle.anchor(top: planView.topAnchor, left: planView.leftAnchor, bottom: nil, right: planView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 20)
        
        planView.addSubview(ApplyCreditImage)
        ApplyCreditImage.image = #imageLiteral(resourceName: "boolIcon")
        ApplyCreditImage.anchor(top: topViewTitle.bottomAnchor, left: planView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
  
        ApplyCreditLabel.font = AppFont.font(type: .Medium, size: 14)
        planView.addSubview(ApplyCreditLabel)
        ApplyCreditLabel.anchor(top: topViewTitle.bottomAnchor, left: ApplyCreditImage.rightAnchor, bottom: nil, right: planView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        planView.addSubview(MsgCreditImage)
        MsgCreditImage.image = #imageLiteral(resourceName: "boolIcon")
        MsgCreditImage.anchor(top: ApplyCreditImage.bottomAnchor, left: planView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        

        MsgCreditLabel.font = AppFont.font(type: .Medium, size: 14)
        planView.addSubview(MsgCreditLabel)
        MsgCreditLabel.anchor(top: ApplyCreditLabel.bottomAnchor, left: MsgCreditImage.rightAnchor, bottom: nil, right: planView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
    }
    
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height)
        subscriptionCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        subscriptionCollectionView.delegate = self
        subscriptionCollectionView.dataSource = self
        subscriptionCollectionView.backgroundColor = .clear
        subscriptionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subscriptionCollectionView.showsHorizontalScrollIndicator = false
        subscriptionCollectionView.register(subscriptionCollectionViewCell.self, forCellWithReuseIdentifier: "subscriptionCollectionViewCell")
     
    
        bottomView.addSubview(subscriptionCollectionView)
        subscriptionCollectionView.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: bottomView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        subscriptionCollectionView.backgroundColor = UIColor.systemBackground
    }
    
    

    
    
}
extension PaymentViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCollectionViewCell", for: indexPath)
   
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-65, height: collectionView.frame.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
