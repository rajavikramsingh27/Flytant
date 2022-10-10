

//  InAppPurchase.swift
//  ios_swift_in_app_purchases_sample
//  Created by Maxim Bilan on 7/27/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.


import Foundation
import StoreKit
import Firebase



class InAppPurchase : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = InAppPurchase()
    
    #if DEBUG
    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    
    var requestProd = SKProductsRequest()
    
    var planProductIdentifiers = ""
    var viewController = UIViewController()
    var price: Double = 0
    var subscriptionDays: Int = 0
    var detailsPlan = [String: Any]()
    var transactionID = 0
    
    var subscriptionMonths = 1
    
    func validateProductIdentifiers() {
        SKPaymentQueue.default().add(self)
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set([planProductIdentifiers]))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error %@ \(error)")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print("Got the request from Apple")
        
        let count = response.products.count
        print(count)
        
        var validProduct: SKProduct!
        
        for i in 0..<count {
            validProduct = response.products[i]
        }
        
        buyProduct(validProduct);
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple");
        print("paymentQueue paymentQueue paymentQueue paymentQueue paymentQueue paymentQueue")
        
        for transaction: AnyObject in transactions {
            print("transaction transaction transaction transaction transaction")
            
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    receiptValidation()
                    
                    break
                    
                case .failed:
                    print("Purchased Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .restored:
                    print("Product Restored")
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default:
                    print("default")
                    
                    break
                }
            }
        }
    }
    
    func savePurchasedProductIdentifier(_ productIdentifier: String!) {
        UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
        UserDefaults.standard.synchronize()
    }
    
    func receiptValidation() {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        
        if (receiptData == nil) {
            return
        }
        
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        if (recieptString == nil) {
            return
        }
        
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "dab3f8e770384d99ae7dda0096529a30" as AnyObject]
        
        do {
//            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options:[])
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    
                    print("jsonResponse jsonResponse jsonResponse jsonResponse jsonResponse jsonResponse jsonResponse jsonResponse jsonResponse ")
                    if let status = jsonResponse["status"] as? Int {
                        self?.transactionID = status
                        
                        DispatchQueue.main.async {
                            self?.updateFireBase()
                        }
                    }
                    
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as NSDictionary) {
                        print("date date date date date date date date date date date date date date date date ")
                        print(date)
                    }
                } catch let parseError {
                    print("parseError parseError parseError parseError parseError parseError parseError parseError parseError ")
                    print(parseError)
                }
            })
            task.resume()
        } catch let errorCatch {
            print("errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch errorCatch ")
            print(errorCatch)
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
}



extension InAppPurchase {
    func updateFireBase() {
        if detailsPlan.isEmpty {
            return
        } 
        
        let planName = "\(detailsPlan["name"]!)"
        var messageCredits = "\(detailsPlan["messageCredits"]!)"
        var numberOfApplies = "\(detailsPlan["numberOfApplies"]!)"
        
        let creationDate = Date().timeIntervalSince1970
        let timeInterval = TimeInterval(creationDate)
        
//        let todayDate = Date(timeIntervalSince1970: timeInterval)
//        let subscribedEndingDate = Calendar.current.date(byAdding: .day, value: 3, to: todayDate)
//        let subscriptionEndingDate = Int(subscribedEndingDate!.timeIntervalSince1970)
        
        getUserDetails(viewController) { (messageCreditsOld, numberOfAppliesOld ,subscriptionEndingDateOld ,subscriptionsListOld)  in
            DispatchQueue.main.async { [self] in
                
                messageCredits = "\(messageCreditsOld+Int(messageCredits)!*subscriptionMonths)"
                numberOfApplies = "\(numberOfAppliesOld+Int(numberOfApplies)!*subscriptionMonths)"
                
                let priceFormated = String(format: "%.02f", price)
                
                let dictSubscription = [
                    "couponCode":"",
                    "currencyCode": kCurrencyCode,
                    "orderDate": Int(timeInterval),
                    "orderId": self.transactionID,
                    "plan": planName,
                    "price": Double(priceFormated)!,
                    "subscriptionDays": subscriptionDays,
                ] as [String : Any]
                print("dictSubscription dictSubscription dictSubscription dictSubscription dictSubscription dictSubscription dictSubscription dictSubscription ")
                print(dictSubscription)
                
                if var arrSubscriptionsListOld = subscriptionsListOld as? [[String: Any]] {
                    arrSubscriptionsListOld.insert(dictSubscription, at: 0)
                    self.updateSubscription(self.viewController, arrSubscriptions: arrSubscriptionsListOld)
                } else {
                    self.updateSubscription(self.viewController, arrSubscriptions: [dictSubscription])
                }
                
                print(subscriptionDays)
                let timeInterval = TimeInterval(subscriptionEndingDateOld)
                let orderDate = (timeInterval == 0) ? Date() : Date(timeIntervalSince1970: timeInterval)
//                print("orderDate orderDate orderDate orderDate orderDate orderDate ")
//                print(orderDate)
                
                let finalOrderDate = Calendar.current.date(byAdding: .day, value: subscriptionDays, to: orderDate)
//                print(finalOrderDate)
                
                let dictUpdateData = [
                    "isSubscribed": true,
                    "subscriptionEndingDate": Int(finalOrderDate!.timeIntervalSince1970),
                    "deviceType": "iOS",
                    "messageCredits": Int(messageCredits)!,
                    "numberOfApplies": Int(numberOfApplies)!,
                ] as [String : Any]
                print("dictUpdateData dictUpdateData dictUpdateData dictUpdateData dictUpdateData dictUpdateData")
                print(dictUpdateData)
                
                self.updateData(self.viewController, dictUpdateData)
            }
        }
        
    }
    
    func updateData(_ viewController: UIViewController, _ dictUpdateData: [String: Any] ) {
        Firestore.firestore().collection("users").document(kUsersDocumentID).updateData(dictUpdateData) { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController (title: "Purchased!", message: "Plan purchased successfully!", preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        NotificationCenter.default.post(name: NSNotification.Name ("purchased"), object: nil)
                    })
                )
                
                UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                
                if let error = error {
                    print("error error error error error ")
                    print(error)
                } else {
                    
                }
            }
        }
    }
    
    func updateSubscription(_ viewController: UIViewController, arrSubscriptions: [[String: Any]])  {
        Firestore.firestore().collection("users").document(kUsersDocumentID).updateData([
            "subscriptions": arrSubscriptions
        ]) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error error error error error ")
                    print(error)
                } else {
                    
                }
            }
        }
    }
    
    private func getUserDetails(_ viewController: UIViewController, completion: @escaping(Int, Int, Int, [[String: Any]]) -> ()) {
        Firestore.firestore().collection("users").document(kUsersDocumentID).getDocument { (documentSnapshot, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error error error error error")
                    print(error)
                } else {
                    var messageCreditsOld = 0
                    var numberOfAppliesOld = 0
                    var subscriptionEndingDateOld = 0
                    var subscriptionsListOld = [[String: Any]]()
                    
                    if let dictData = documentSnapshot?.data() {
                        if let subscriptions = dictData["subscriptions"] as? [[String: Any]] {
                            subscriptionsListOld = subscriptions
                        }
                        
                        if let messageCredits = dictData["messageCredits"] as? Int {
                            messageCreditsOld = messageCredits
                        }
                        
                        if let numberOfApplies = dictData["numberOfApplies"] as? Int {
                            numberOfAppliesOld = numberOfApplies
                        }
                        
                        if let subscriptionEndingDate = dictData["subscriptionEndingDate"] as? Int {
                            subscriptionEndingDateOld = subscriptionEndingDate
                        }
                    }
                    
                    completion(messageCreditsOld, numberOfAppliesOld, subscriptionEndingDateOld,subscriptionsListOld)
                }
            }
        }
    }
    
}
