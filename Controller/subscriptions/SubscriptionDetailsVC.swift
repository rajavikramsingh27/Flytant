

 //
 //  SubscriptionDetailsVC.swift
 //  Flytant-1
 //
 //  Created by GranzaX on 20/02/22.
 //

 import Foundation
 import UIKit
 import StoreKit


 class SubscriptionDetailsVC: UIViewController {
     var navBar:UINavigationBar!
     var scrollView: UIScrollView!
     var tblSubscription:UITableView!
     var viewNoPlanActive : UIView!
     var btnPlanType:UIButton!
     var viewNoPlanActiveYOrigin:CGFloat!
//     var viewNoPlanActiveYBottom:CGFloat!
     let tableCellHeight = 90
     
     let arrSubscriptionTime = ["", "3", "6", ""]
     let arrSubscriptionTimeUnit = ["monthly", "months", "months", "Annually"]
     var arrSubscriptionPrice = [Double]()
     var arrSubscriptionFullPrice = [Double]()
     var arrSubscriptionDiscount = [Double]()
     var arrSubscriptionPlanSelected = [Bool]()
     
    var price: Double = 0
    var subscriptionDays:Int = 0
    var priceIAP: Double = 0.0
    var detailsPlan:[String: Any] = [String: Any]()
     
    var arrProductIdentifiers: [String] = [String]()
     
    var arrPriceIAP: [Double] = [Double]()
     var indexPrice = 0
     
     var loader: FActivityIndicatorView!
     
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(btnBack(_:)), name: NSNotification.Name ("purchased"), object: nil)
        
         if arrProductIdentifiers.count > 0 {
             InAppPurchase.shared.planProductIdentifiers = arrProductIdentifiers[0]
             
             DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                 self.loader = self.showLoader()
                 
                 for i in 0..<self.arrProductIdentifiers.count {
                     self.validateProductIdentifiers(self.arrProductIdentifiers[i])
                 }
             }
         }
         
         makeUI()
     }
     
     override func viewWillAppear(_ animated: Bool) {
 //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
         self.navigationController?.navigationBar.isHidden = true
         self.tabBarController?.tabBar.isHidden = true
     }
     
 //    @objc func handlePopGesture(gesture: UIGestureRecognizer) {
 //        print("swiping swiping swiping swiping swiping swiping swiping ")
 //        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
 //            switch swipeGesture.direction {
 //            case .right:
 //                print("Swiped right")
 //            case .down:
 //                print("Swiped down")
 //            case .left:
 //                print("Swiped left")
 //            case .up:
 //                print("Swiped up")
 //            default:
 //                break
 //            }
 //        }
 //    }
     
     func makeUI() {
         setNavigationBar()
         setUI()
         tableViewUI()
         bottomUI()
     }
     
     func setNavigationBar() {
         let viewUpperNav = UIView (frame: CGRect (x: 0, y: 0, width: Int(view.frame.size.width), height: sageAreaHeight()))
         
         viewUpperNav.backgroundColor = .systemBackground
         view.addSubview(viewUpperNav)
         
         let screenSize: CGRect = UIScreen.main.bounds
         navBar = UINavigationBar(frame: CGRect(x: 0, y: sageAreaHeight(), width: Int(screenSize.width), height: 44))
         navBar.barTintColor = .systemBackground
         navBar.shadowImage = UIImage()
         
         navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: kFontBold, size: 20)!]
         
         let navItem = UINavigationItem(title: "Subscription")
         
         let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         btnBack.setImage(UIImage (named: "back_subscription.png"), for: .normal)
         btnBack.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
         
         let btnBarBack = UIBarButtonItem(customView: btnBack)
         
         navItem.leftBarButtonItem = btnBarBack
         navBar.setItems([navItem], animated: false)
         view.addSubview(navBar)
         
 //        if (iPhoneType() == "5 SE" || iPhoneType() == "6 7 8") {
             viewNoPlanActiveYOrigin = navBar.frame.origin.y+navBar.frame.size.height+30
//             viewNoPlanActiveYBottom = 20 + view.safeAreaInsets.bottom
         
 //        } else if (iPhoneType() == "X & mini Series") {
 //            viewNoPlanActiveYOrigin = navBar.frame.origin.y+navBar.frame.size.height+50
 //            viewNoPlanActiveYBottom = 100
 //        } else {
 //            viewNoPlanActiveYOrigin = navBar.frame.origin.y+navBar.frame.size.height+100
 //            viewNoPlanActiveYBottom = 120
 //        }
     }
     
     func setUI() {
         let sizeView = self.view.frame.size
         
         scrollView = UIScrollView(frame: CGRect())
         
         scrollView.frame.origin.x = 0
         scrollView.frame.origin.y = viewNoPlanActiveYOrigin
         scrollView.frame.size.width = sizeView.width
         scrollView.frame.size.height = sizeView.height-viewNoPlanActiveYOrigin//-viewNoPlanActiveYBottom
         self.view.addSubview(scrollView)
         
         viewNoPlanActive = UIView (frame: CGRect(
                                     x: 20,
                                     y: 10,
                                     width: scrollView.frame.size.width-40,
                                     height: CGFloat(600)))
        
         viewNoPlanActive.backgroundColor = .systemBackground
         viewNoPlanActive.defaultShadow()
         
         scrollView.addSubview(viewNoPlanActive)
        viewNoPlanActive.isHidden = true
        
         scrollView.contentSize = CGSize(
             width: UIScreen.main.bounds.width,
             height: viewNoPlanActive.frame.origin.y+viewNoPlanActive.frame.size.height+30
         )
         
         btnPlanType = UIButton(frame: CGRect (x: 30, y: 30, width: 140, height: 44))
         btnPlanType.backgroundColor = .systemBackground
         btnPlanType.setTitle("\(detailsPlan["name"] ?? "Wrong ...")", for: .normal)
         btnPlanType.titleLabel?.font = UIFont (name: kFontMedium, size: 20)
         btnPlanType.setTitleColor(.systemBackground, for: .normal)
         btnPlanType.backgroundColor = .label
         btnPlanType.frame.size.width = btnPlanType.titleLabel!.text!.textSize(UIFont (name: kFontBold, size: 24)!).width+10

         btnPlanType.layer.cornerRadius = 2
         btnPlanType.clipsToBounds = true
         
         viewNoPlanActive.addSubview(btnPlanType)
     }
     
     func tableViewUI() {
         cellWidth = Int(viewNoPlanActive.frame.size.width)-(36*2);
         
         let tblSubscriptionYOrigin = btnPlanType.frame.origin.y+btnPlanType.frame.size.height+40
         
         tblSubscription = UITableView (frame: CGRect (
                                         x: 36,
                                         y: Int(tblSubscriptionYOrigin),
                                         width: Int(viewNoPlanActive.frame.size.width)-(36*2),
                                         height: arrSubscriptionTime.count*tableCellHeight))
         
         tblSubscription.delegate = self
         tblSubscription.dataSource = self
         tblSubscription.register(SubscriptionDetailsTableViewCell.self, forCellReuseIdentifier: "SubscriptionDetails")
         tblSubscription.separatorStyle = .none
         tblSubscription.isScrollEnabled = false
         tblSubscription.backgroundColor = .clear
         
         viewNoPlanActive.addSubview(tblSubscription)
        
         for i in 0..<arrSubscriptionTime.count {
             arrSubscriptionPlanSelected.append((i == 0) ? true : false)
         }
     }
     
     func bottomUI() {
         let btnChoosePlanYOrigin = tblSubscription.frame.origin.y+tblSubscription.frame.size.height+30
         let btnBuyNow = UIButton (frame: CGRect (
                                         x: viewNoPlanActive.frame.size.width/2-(186/2),
                                         y: btnChoosePlanYOrigin,
                                         width: 186,
                                         height: 44))
         btnBuyNow.setTitle("Buy Now", for: .normal)
         btnBuyNow.titleLabel?.font = UIFont (name: kFontMedium, size: 16)
         btnBuyNow.setTitleColor(.systemBackground, for: .normal)
         btnBuyNow.backgroundColor = .label
         btnBuyNow.layer.cornerRadius = 2
         btnBuyNow.clipsToBounds = true
         btnBuyNow.addTarget(self, action: #selector(btnBuyNow(_:)), for: .touchUpInside)
         
         viewNoPlanActive.addSubview(btnBuyNow)
         
         let btnTermsOfUse = UIButton (frame: CGRect (x: viewNoPlanActive.frame.size.width/2-(186/2), y: btnBuyNow.frame.origin.y+btnBuyNow.frame.size.height, width: 186, height: 44))
         btnTermsOfUse.setTitleColor(UIColor.init("706C6C"), for: .normal)
         btnTermsOfUse.setTitle("Terms of use", for: .normal)
         btnTermsOfUse.titleLabel?.font = UIFont (name: kFontLight, size: 12)
         btnTermsOfUse.addTarget(self, action: #selector(btnTermsOfUse(_:)), for: .touchUpInside)
         
         viewNoPlanActive.addSubview(btnTermsOfUse)
     }
     
     @IBAction func btnBack(_ sedner:UIButton) {
         self.navigationController?.popViewController(animated: true)
     }
     
     @IBAction func btnTermsOfUse(_ sender:UIButton) {
         let termsOfUse = TermsOfUseViewController()
         termsOfUse.urlWeb = "https://flytant.com/terms"
         self.navigationController?.pushViewController(termsOfUse, animated: true)
     }
     
    @IBAction func btnBuyNow(_ sender:UIButton) {
        InAppPurchase.shared.viewController = self
        InAppPurchase.shared.price = price
        InAppPurchase.shared.subscriptionDays = subscriptionDays
        InAppPurchase.shared.detailsPlan = detailsPlan
        
        InAppPurchase.shared.validateProductIdentifiers()
    }
     
 }



 extension SubscriptionDetailsVC: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return CGFloat(tableCellHeight)
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrSubscriptionPrice.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionDetails", for: indexPath) as! SubscriptionDetailsTableViewCell
         
         let bgColorView = UIView()
         bgColorView.backgroundColor = UIColor.clear
         cell.selectedBackgroundView = bgColorView
         
         cell.viewBG.backgroundColor = arrSubscriptionPlanSelected[indexPath.row] ? .label : .systemBackground
         cell.viewBG.layer.borderColor = arrSubscriptionPlanSelected[indexPath.row] ? UIColor.systemBackground.cgColor : UIColor.label.cgColor
         
         cell.lblPlan.textColor = arrSubscriptionPlanSelected[indexPath.row] ? .systemBackground : .label
         cell.lblRSDisable.isHidden = (indexPath.row == 0) ? true : false
         
        let strPlanFormatted = String(format: "%.02f", Double(arrSubscriptionPrice[indexPath.row]))
        cell.lblPlan.text = "Price \(kCurrencySymbol) \(strPlanFormatted) / \(arrSubscriptionTime[indexPath.row]) \(arrSubscriptionTimeUnit[indexPath.row])"
        
//        let strPlanFormattedFullPrice = String(format: "%.02f", Double(arrSubscriptionFullPrice[indexPath.row]))
//        let attrTextStrikeOff = NSAttributedString(
//            string: "\(kCurrencySymbol) \(strPlanFormattedFullPrice) Flat \(arrSubscriptionDiscount[indexPath.row])% Off",
//            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
//        )
        
        let strPlanFormattedFullPrice = String(format: "%.02f", Double(arrSubscriptionFullPrice[indexPath.row]))
        let attrTextStrikeOff = NSMutableAttributedString(
            string: "\(kCurrencySymbol) \(strPlanFormattedFullPrice)",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        let attrTextNormal = NSAttributedString(
            string: " Flat \(arrSubscriptionDiscount[indexPath.row])% Off"
//            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        attrTextStrikeOff.append(attrTextNormal)
        cell.lblRSDisable.attributedText = attrTextStrikeOff
         
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         
        for i in 0..<arrSubscriptionPlanSelected.count {
            if (i == indexPath.row) {
                arrSubscriptionPlanSelected[i]  = true
                InAppPurchase.shared.planProductIdentifiers = arrProductIdentifiers[indexPath.row]
                
                price = arrSubscriptionPrice[i]
                
                if (i==0) {
                    subscriptionDays = 30
                    InAppPurchase.shared.subscriptionMonths = 1
                } else if (i==1) {
                    subscriptionDays = 90
                    InAppPurchase.shared.subscriptionMonths = 3
                } else if (i==2) {
                    subscriptionDays = 180
                    InAppPurchase.shared.subscriptionMonths = 6
                } else if (i==3) {
                    subscriptionDays = 360
                    InAppPurchase.shared.subscriptionMonths = 12
                }
            } else {
                arrSubscriptionPlanSelected[i] = false
            }
        }
         
         tblSubscription.reloadData()
     }
 }



 extension SubscriptionDetailsVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
     
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
         var validProduct: SKProduct!
         
         for i in 0..<count {
             validProduct = response.products[i]
//             let price  = validProduct.price
//
//             indexPrice = indexPrice+1
//             self.setPrice(Double(price))
            
            
            
            let currency_format = NumberFormatter()
            currency_format.numberStyle = .currency
//            currency_format.locale = validProduct.priceLocale
//            currency_format.locale = Locale(identifier: "en_US")
            currency_format.locale = Locale(identifier: kLanguageCode)
            var price = currency_format.string(from: validProduct.price)
            price = price?.replacingOccurrences(of: " ", with: "")
            price = price?.replacingOccurrences(of: ",", with: "")
            let index = price!.index(price!.startIndex, offsetBy: 1)
            price!.insert("-", at: index)
            let arrPriceDetails = price?.components(separatedBy: "-")
            kCurrencySymbol = (arrPriceDetails?[0])!
            
            let doublePrice = Double((arrPriceDetails?[1])!)
            indexPrice = indexPrice+1
            
            self.setPrice(doublePrice ?? 0)
         }
         
     }
     
     func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         
     }
     
     private func setPrice(_ priceIAP: Double) {
         arrSubscriptionPrice.append(priceIAP)
        
         let inPercentageOff = Double("\(detailsPlan["inPercentageOff"]!)")
         let usPercentageOff_3_Months = inPercentageOff!/4
         let usPercentageOff_6_Months = inPercentageOff!/2
         let usPercentageOff_Yearly = inPercentageOff!
         
         if indexPrice == 1 {
             arrSubscriptionDiscount.append(1)
             arrSubscriptionFullPrice.append(priceIAP)
         } else if indexPrice == 2 {
             arrSubscriptionDiscount.append(usPercentageOff_3_Months)
             let off_3_Months = (priceIAP*usPercentageOff_3_Months)/Double(100)
             arrSubscriptionFullPrice.append((priceIAP)+off_3_Months)
         } else if indexPrice == 3 {
             arrSubscriptionDiscount.append(usPercentageOff_6_Months)
             let off_6_Months = (priceIAP*usPercentageOff_6_Months)/Double(100)
             arrSubscriptionFullPrice.append((priceIAP)+off_6_Months)
         } else if indexPrice == 4 {
             arrSubscriptionDiscount.append(usPercentageOff_Yearly)
             let off_Yearly = (priceIAP*usPercentageOff_Yearly)/Double(100)
             arrSubscriptionFullPrice.append((priceIAP)+off_Yearly)
         }
         
        price = arrSubscriptionPrice[0]
        subscriptionDays = 30
        InAppPurchase.shared.subscriptionMonths = 1
        
        if arrSubscriptionPrice.count == arrSubscriptionTimeUnit.count {
             DispatchQueue.main.async {
                 self.tblSubscription.reloadData()
                 self.hideLoader(self.loader)
                self.viewNoPlanActive.isHidden = false
             }
         }
         
     }
    
 }



