


//  SubscriptionViewController.swift
//  Flytant-1
//  Created by GranzaX on 20/02/22.



import UIKit
import Foundation
import Firebase
import Alamofire
import StoreKit



let kFontBold = "RoundedMplus1c-Medium"
let kFontMedium = "RoundedMplus1c-Bold"
let kFontRegular = "RoundedMplus1c-Regular"
let kFontLight = "RoundedMplus1c-Light"

var arrUserSubscribed = [String]()

class SubscriptionViewController: UIViewController {
    
    var collectionview: UICollectionView!
    var scrollView: UIScrollView!
    
    var arrSubscription = [[String: Any]]()
    
    var lblActive :UILabel!
    var lblApplyCredits:UILabel!
    var lblMessageCredits:UILabel!
    
//    var arrPriceIAP = [Double]()
    
    var arrPriceIAP: [Double] = [Double]()
    let arrProductId = [kbasic_monthly_2, kstd_monthly_2, kadv_monthly_2, kprem_monthly_2, ]
    
    var loader: FActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView (frame: CGRect (x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        self.view.backgroundColor = .systemBackground
        
        scrollView.showsVerticalScrollIndicator = false
        //        scrollView.backgroundColor = UIColor.red
        self.view.addSubview(scrollView)
        
        loader = showLoader()
        
        for i in 0..<arrProductId.count {
            validateProductIdentifiers(arrProductId[i])
        }
        
        makeUI()
        currencylayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserDetails()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
//        if gesture.state == UIGestureRecognizer.State.began {
//             print("respond to beginning of pop gesture")
//        }
//    }
    
    
    @IBAction func btnHistory(_ sedner:UIButton) {
        let history = SubscriptionHistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
    
    @IBAction func btnBack(_ sedner:UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func makeUI() {
        setNavigationBar()
        topUI()
        collectionView()
    }
    
    func setNavigationBar() {
        let viewUpperNav = UIView (frame: CGRect (x: 0, y: 0, width: Int(view.frame.size.width), height: sageAreaHeight()))
        
        viewUpperNav.backgroundColor = .systemBackground
        view.addSubview(viewUpperNav)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: sageAreaHeight(), width: Int(screenSize.width), height: 44))
        navBar.barTintColor = UIColor.systemBackground
        navBar.shadowImage = UIImage()
        
        navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: kFontBold, size: 20)!]
        
        let navItem = UINavigationItem(title: "Subscription")
        
        
        let btnHistory = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnHistory.setImage(UIImage (named: "history_subscription.png"), for: .normal)
        btnHistory.addTarget(self, action: #selector(btnHistory(_:)), for: .touchUpInside)
        
        let btnBarHistory = UIBarButtonItem(customView: btnHistory)
        
        
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnBack.setImage(UIImage (named: "back_subscription.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
        
        let btnBarBack = UIBarButtonItem(customView: btnBack)
        
        navItem.leftBarButtonItem = btnBarBack
        navItem.rightBarButtonItem = btnBarHistory
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    func topUI() {
        let viewNoPlanActive = UIView (frame: CGRect(x: 20, y: 70, width: view.frame.size.width-50, height: 175))
        
        viewNoPlanActive.backgroundColor = .systemBackground
        
        viewNoPlanActive.defaultShadow()
        
        scrollView.addSubview(viewNoPlanActive)
        
        lblActive = UILabel (frame: CGRect (x: 0, y: 20, width: viewNoPlanActive.frame.size.width, height: 30))
        lblActive.textAlignment = .center
        lblActive.text = "NO PLAN ACTIVE"
        lblActive.textColor = .label
        lblActive.font = UIFont(name: kFontBold, size: 18)
        
        viewNoPlanActive.addSubview(lblActive)
        
        
        
        let viewBorderOuter = UIView (frame: CGRect(x: 40, y: 70,
                                                    width: 16,
                                                    height: 16))
        
        viewNoPlanActive.addSubview(viewBorderOuter)
        
        borderCircle(viewBorderOuter)
        
        
        let viewBorderInner = UIView (frame: CGRect(x: 4, y: 4,
                                                    width: 8,
                                                    height: 8))
        
        viewBorderInner.backgroundColor = .label
        
        viewBorderOuter.addSubview(viewBorderInner)
        
        roundCircle(viewBorderInner)
        
        lblApplyCredits = UILabel (frame: CGRect (x: 70, y: 63,
                                                      width: viewNoPlanActive.frame.size.width-70,
                                                      height: 30))
        lblApplyCredits.textAlignment = .left
        lblApplyCredits.text = "0 Apply credits"
        lblApplyCredits.textColor = .label
        lblApplyCredits.font = UIFont(name: kFontBold, size: 16)
        
        viewNoPlanActive.addSubview(lblApplyCredits)
        
        
        let viewBorderOuter2 = UIView (frame: CGRect(x: 40, y: 100,
                                                     width: 16,
                                                     height: 16))
        
        viewNoPlanActive.addSubview(viewBorderOuter2)
        
        borderCircle(viewBorderOuter2)
        
        
        let viewBorderInner2 = UIView (frame: CGRect(x: 4, y: 4,
                                                     width: 8,
                                                     height: 8))
        
        viewBorderInner2.backgroundColor = .label
        
        viewBorderOuter2.addSubview(viewBorderInner2)
        
        roundCircle(viewBorderInner2)
        
        lblMessageCredits = UILabel (frame: CGRect (x: 70, y: 93,
                                                        width: viewNoPlanActive.frame.size.width-70,
                                                        height: 30))
        lblMessageCredits.textAlignment = .left
        lblMessageCredits.text = "0 Message credits"
        lblMessageCredits.textColor = .label
        lblMessageCredits.font = UIFont(name: kFontBold, size: 16)
        
        viewNoPlanActive.addSubview(lblMessageCredits)
    }
    
    func collectionView() {
        let frameColl = CGRect (x: 0, y: 270, width: view.frame.size.width, height: 500)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: frameColl.size.width-60, height: frameColl.size.height)
        layout.scrollDirection = .horizontal
        
        
        
        collectionview = UICollectionView(frame: frameColl, collectionViewLayout: layout)
        
        collectionview.collectionViewLayout = layout
        
        
        collectionview.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: "subscription")
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = .systemBackground
        //        collectionview.isPagingEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        
        
        scrollView.addSubview(collectionview)
        
        scrollView.contentSize = CGSize (width: view.frame.size.width,
                                         height: collectionview.frame.origin.y+collectionview.frame.size.height+10)
        collectionview.isHidden = true
    }
    
    func borderCircle(_ view:UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    func roundCircle(_ view:UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
}



extension SubscriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubscription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscription", for: indexPath) as! SubscriptionCollectionViewCell
        
        cell.setData(arrSubscription[indexPath.row])
        cell.index = indexPath.row
        
        cell.btnChoosePlan.tag = indexPath.row
        cell.btnChoosePlan.addTarget(self, action: #selector(btnChoosePlan(_:)), for: .touchUpInside)
        cell.btnTermsOfUse.tag = indexPath.row
        cell.btnTermsOfUse.addTarget(self, action: #selector(btnTermsOfUse(_:)), for: .touchUpInside)
        
        if (arrUserSubscribed.count > 0) {
            cell.showImage()
        }
        
        print(arrPriceIAP.count)
        if arrPriceIAP.count > indexPath.row {
            cell.setPrice(arrPriceIAP[indexPath.row], arrSubscription[indexPath.row])
        }
        
        return cell
    }
    
    @IBAction func btnChoosePlan(_ sender:UIButton) {
        let subscriptionDetailsVC = SubscriptionDetailsVC()
        subscriptionDetailsVC.detailsPlan = arrSubscription[sender.tag]
        subscriptionDetailsVC.arrProductIdentifiers = allProductIdentifiers[sender.tag]
        if arrPriceIAP.count > 0 {
            subscriptionDetailsVC.priceIAP = arrPriceIAP[sender.tag]
        }
        
        self.navigationController?.pushViewController(subscriptionDetailsVC, animated: true)
    }
    
    @IBAction func btnTermsOfUse(_ sender:UIButton) {
        let termsOfUse = TermsOfUseViewController()
        termsOfUse.urlWeb = "https://flytant.com/terms"
        self.navigationController?.pushViewController(termsOfUse, animated: true)
    }
    
}



extension SubscriptionViewController {
    
    func currencylayer() {
        let todosEndpoint = "http://api.currencylayer.com/live?access_key=babaacb743f8acfb2a2c2de8fd2f9e30&format=1"
        
        let loader = showLoader()
        
        AF.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                self.hideLoader(loader)
                
                self.getsubscription()
                
                switch response.result {
                
                case .success(let json):
                    print(json)
                    
                    if let dictJSON = json as? [String: Any] {
                        if let dictQuotes = dictJSON["quotes"] as? [String: Any] {
                            usdToLocalPrice = Double("\(dictQuotes["usd\(kCurrencyCode)".uppercased()]!)")!
                            print(usdToLocalPrice)
                        }
                    } else {
                        print("erroring in json")
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    func getsubscription() {
        print("subscription list")
        
        let loader = showLoader()
        Firestore.firestore().collection("subscription").order(by: "inBasePrice").getDocuments { (querySnapshot, error) in
            self.hideLoader(loader)
            
            if let error = error {
                print("error")
                print(error.localizedDescription)
            } else {
                self.arrSubscription.removeAll()
                
                for document in querySnapshot!.documents {
                    let dictDocument = document.data() as [String: Any]
                    self.arrSubscription.append(dictDocument)
                }
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        self.getusers()
                    }
                }
            }
        }
    }
    
    func getusers() {
        print("users list")
        
        let imgDefault = "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/profile_images%2Fdefault_user_image.png?alt=media&token=45511585-2c3d-4997-a735-8a5f2073073d"
        
        Firestore.firestore().collection("users").whereField("profileImageUrl", isNotEqualTo: imgDefault).whereField("isSubscribed", isEqualTo: true).limit(to: 16).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error")
                print(error.localizedDescription)
            } else {
                arrUserSubscribed.removeAll()
                
                for document in querySnapshot!.documents {
                    let dictDocument = document.data() as [String: Any]
                    
                    if !("\(dictDocument["profileImageUrl"]!)".isEmpty) {
                        arrUserSubscribed.append("\(dictDocument["profileImageUrl"]!)")
                        
                        if arrUserSubscribed.count > 15 {
                            break
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
    }
    
    private func getUserDetails() {
        Firestore.firestore().collection("users").document(kUsersDocumentID).getDocument { (documentSnapshot, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error error error error error")
                    print(error)
                } else {
                    if let dictData = documentSnapshot?.data() {
                        print("dictData dictData dictData dictData dictData dictData ")
                        print(dictData)
                        
                        if let subscriptions = dictData["subscriptions"] as? [[String: Any]] {
                            self.lblActive.text = "\(subscriptions[0]["plan"]!) Plan"
                        }
                        
                        if let numberOfApplies = dictData["numberOfApplies"] as? Int {
                            self.lblApplyCredits.text = "\(numberOfApplies) Apply Credits"
                        }
                        
                        if let messageCredits = dictData["messageCredits"] as? Int {
                            self.lblMessageCredits.text = "\(messageCredits) Message Credits"
                        }
                    }
                }
            }
        }
    }
}


extension SubscriptionViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func validateProductIdentifiers(_ planProductIdentifiers: String) {
        SKPaymentQueue.default().add(self)
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set([planProductIdentifiers]))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error %@ \(error)")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count = response.products.count
        print(count)
        
        var validProduct: SKProduct!
        
        for i in 0..<count {
            validProduct = response.products[i]
            
            let currency_format = NumberFormatter()
            currency_format.numberStyle = .currency
//            currency_format.locale = validProduct.priceLocale
//            currency_format.locale = Locale(identifier: "en_US")
            currency_format.locale = Locale(identifier: kLanguageCode)
            var price = currency_format.string(from: validProduct.price)
            print("price is:-", price)
            price = price?.replacingOccurrences(of: " ", with: "")
            let index = price!.index(price!.startIndex, offsetBy: 1)
            price!.insert("-", at: index)
            let arrPriceDetails = price?.components(separatedBy: "-")
            kCurrencySymbol = (arrPriceDetails?[0])!
            let doublePrice = Double((arrPriceDetails?[1])!)
            
            arrPriceIAP.append(doublePrice ?? 0)
            
            if arrPriceIAP.count == arrProductId.count {
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    self.collectionview.isHidden = false
                    self.hideLoader(self.loader)
                }
            }
            
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
}


