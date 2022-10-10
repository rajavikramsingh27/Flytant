//
//  PaymentsVC.swift
//  Flytant
//
//  Created by Vivek Rai on 25/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

private let reuseIdentifier = "paymentsColelctionViewReuseIdentifier"

class PaymentsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK: - Properties
    
    var currentBalance: Double = 0
    var previousPaymentBalance: Double = 0
    var totalBalance: Double = 0
    var payments = [Payments]()
    
//    MARK: - Views
    
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    let navigationView = UIView()
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 16, image: UIImage(named: "avatarPlaceholder")!)
    
    let paymentCardImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "paymentsCard")!)
    let latestTransactionlabel = FLabel(backgroundColor: UIColor.clear, text: "Latest Transactions", font: UIFont.boldSystemFont(ofSize: 22), textAlignment: .left, textColor: UIColor.label)
    var transactionsCollectionView: UICollectionView!
    let currentBalanceLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.white)
    let withdrawButton = FButton(backgroundColor: UIColor.flatGreenColorDark(), title: "Withdraw", cornerRadius: 8, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        setNavigationView()
        configureViews()
        configureCollectionView()
        fetchUserCurrentBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
        navigationView.removeFromSuperview()
    }
        
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Payments"
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func setNavigationView(){
        navigationController?.navigationBar.addSubview(navigationView)
        navigationView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 112, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        navigationView.addSubview(profileImageView)
        profileImageView.anchor(top: navigationView.topAnchor, left: nil, bottom: nil, right: navigationView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 32, height: 32)
        
        navigationView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUserPaymentMode))
        navigationView.addGestureRecognizer(tapGesture)
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            self.profileImageView.loadImage(with: user.profileImageURL)
        }
    }
    
    private func configureViews(){
        view.addSubview(paymentCardImageView)
        paymentCardImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 200)
        paymentCardImageView.contentMode = .scaleToFill
        paymentCardImageView.layer.masksToBounds = true
        paymentCardImageView.layer.cornerRadius = 12
        
        view.addSubview(latestTransactionlabel)
        latestTransactionlabel.anchor(top: paymentCardImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 28)
        
        paymentCardImageView.addSubview(currentBalanceLabel)
        currentBalanceLabel.anchor(top: paymentCardImageView.topAnchor, left: paymentCardImageView.leftAnchor, bottom: paymentCardImageView.bottomAnchor, right: paymentCardImageView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        view.addSubview(withdrawButton)
        withdrawButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 8, paddingRight: 32, width: 0, height: 50)
        withdrawButton.addTarget(self, action: #selector(handleWithdraw), for: .touchUpInside)
        
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        transactionsCollectionView = UICollectionView(frame: frame, collectionViewLayout: UIHelper.createSingleVerticalFlowLayout(in: view))
        transactionsCollectionView.delegate = self
        transactionsCollectionView.dataSource = self
        transactionsCollectionView.backgroundColor = .clear
        transactionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        transactionsCollectionView.showsVerticalScrollIndicator = false
        transactionsCollectionView.register(PaymentsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(transactionsCollectionView)
        transactionsCollectionView.anchor(top: latestTransactionlabel.bottomAnchor, left: view.leftAnchor, bottom: withdrawButton.topAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        transactionsCollectionView.backgroundColor = UIColor.systemBackground
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
              
//    MARK: - CollectionView Dlelegate and Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PaymentsCollectionViewCell
        if !payments.isEmpty{
            cell.payments = self.payments[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
        
    
    
//    MARK: - Handlers
    
    @objc private func handleUserPaymentMode(){
        
    }
    
    @objc private func handleWithdraw(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
        
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            if user.monetizationEnabled{
                if self.currentBalance >= 100{
                    // Ask to choose the payment Mode
                    self.showIndicatorView()
                    let paymentId = PAYMENT_REF.document()
                    let creationDate = Int(NSDate().timeIntervalSince1970)
                    let values = ["userId": currentUserId, "username": username, "amount": self.currentBalance, "paymentMode": "paypal", "paymentId": paymentId.documentID, "status": "Processing", "creationDate": creationDate] as [String: Any]
                    paymentId.setData(values) { (error) in
                        if let _ = error{
                            self.dismissIndicatorView()
                            ProgressHUD.showError("Error while processing payment. Please try again!")
                            return
                        }
                        self.dismissIndicatorView()
                        ProgressHUD.showSuccess("You have successfully Withdrawn $\(self.currentBalance)")
                    }
                    
                }else{
                    ProgressHUD.showFailed("The payment threshold is 100$. Request payment upon reaching the threshold!")
                }
            }else{
                ProgressHUD.showFailed("Your monetization is not enabled yet! Visit Settings -> Monetize for more info.")
            }
        }
        
    }
    
    private func setUserCurrentBalanceLabel(currentBalance: Double){
        currentBalanceLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "Current Balance\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "$ \(currentBalance)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.white]))
        currentBalanceLabel.attributedText = attributedText
        
        //fetchUserCurrentBalance()
    }
    
    private func fetchLatestPayments(userLatestFetchComplete: @escaping (_ success: Bool, _ error: Error?) -> ()){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return }
        payments.removeAll()
        showIndicatorView()
        PAYMENT_REF.whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                userLatestFetchComplete(false, error)
                return
            }
            guard let snapshot = snapshot else {
                self.dismissIndicatorView()
                userLatestFetchComplete(false, error)
                return
            }
            
            for document in snapshot.documents{
                let data = document.data()
                let userId = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let amount = data["amount"] as? Double ?? 0
                let paymentMode = data["paymentMode"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                let creationDate = data["creationDate"] as? Double ?? 0
                let paymentId = data["paymentId"] as? String ?? ""
                self.previousPaymentBalance += amount
                let payment = Payments(userId: userId, username: username, amount: amount, paymentMode: paymentMode, status: status, paymentId: paymentId, creationDate: creationDate)
                self.payments.append(payment)
                self.payments.sort { (payment1, payment2) -> Bool in
                    payment1.creationDate > payment2.creationDate
                }
            }
            self.dismissIndicatorView()
            self.transactionsCollectionView.reloadData()
            userLatestFetchComplete(true, nil)
            debugPrint(self.previousPaymentBalance)
        }
    }
    
    private func fetchUserCurrentBalance() -> Double{
        guard let currentUserId = Auth.auth().currentUser?.uid else {return 0}
        DataService.instance.fetchPartnerUser(with: currentUserId) { (user) in
            if user.monetizationEnabled{
//                self.currentBalance = self.fetchTotalBalance() - self.previousPaymentBalance
                self.fetchTotalBalance { (totalBalance, error) in
                    if let _ = error{
                        return
                    }
                    debugPrint("Total Balance \(totalBalance)")
                    self.fetchLatestPayments { (success, error) in
                        if let _ = error{
                            return
                        }
                        if success{
                            self.currentBalance = totalBalance - self.previousPaymentBalance
                            self.setUserCurrentBalanceLabel(currentBalance: self.currentBalance)
                        }
                    }
                }
            }else{
                self.currentBalance = 0
                self.setUserCurrentBalanceLabel(currentBalance: self.currentBalance)
            }
        }
        return self.currentBalance
    }
    
    private func fetchTotalBalance(userTotalBalanceFetchComplete: @escaping (_ totalBalance: Double, _ error: Error?) -> ()){
        showIndicatorView()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        POST_REF.whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                userTotalBalanceFetchComplete(0, error)
                return
            }
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let likes = data["likes"] as? Int ?? 0
                let followersCount = data["followersCount"] as? Int ?? 10
                self.totalBalance += Analytics.getRevenue(followersCount: followersCount, likes: likes)
            }
        }
        self.dismissIndicatorView()
        userTotalBalanceFetchComplete(self.totalBalance, nil)
    }
    
}
//    private func fetchPreviousPayoutAmounts() -> Double{
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return 0}
//        PAYMENT_REF.whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
//            if let _ = error{
//                return
//            }
//
//            guard let snapshot = snapshot else {return}
//            for document in snapshot.documents{
//                let data = document.data()
//                let amount = data["amount"] as? Double ?? 0
//                self.previousPaymentBalance += amount
//            }
//        }
//        return self.previousPaymentBalance
//    }




// three things
// Make a payment model and enter payment through withdraw button in database and display in collectionView
// fetchTotalBalance
// fetchPreviousPayoutAmounts
// fetchUserCurrentBalance


