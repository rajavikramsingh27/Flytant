//
//  SubscriptionHistoryViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 21/02/22.
//

import UIKit
import Firebase

let cellHistoryHeight = 160


class SubscriptionHistoryViewController: UIViewController {
    var navBar:UINavigationBar!
    var tblSubscriptionHistory:UITableView!
    var arrSubscriptionHistory = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        makeUI()
        getUserSubscriptionHistory()
    }
    
    func makeUI() {
        setNavigationBar()
        tableViewUI()
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
        
        let navItem = UINavigationItem(title: "History")
        
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnBack.setImage(UIImage (named: "back_subscription.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
        
        let btnBarBack = UIBarButtonItem(customView: btnBack)
        
        navItem.leftBarButtonItem = btnBarBack
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    @IBAction func btnBack(_ sedner:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func tableViewUI()  {
        let tableHeight = self.view.frame.size.height - (navBar.frame.origin.y+navBar.frame.size.height)
        
        tblSubscriptionHistory = UITableView (frame: CGRect (
                                        x: 0,
                                        y: navBar.frame.origin.y+navBar.frame.size.height,
                                        width: self.view.frame.size.width,
                                        height: tableHeight))
        
        tblSubscriptionHistory.delegate = self
        tblSubscriptionHistory.dataSource = self
        tblSubscriptionHistory.register(SubscriptionHistoryTableViewCell.self, forCellReuseIdentifier: "SubscriptionHistry")
        tblSubscriptionHistory.separatorStyle = .none
        tblSubscriptionHistory.backgroundColor = .clear
        tblSubscriptionHistory.showsVerticalScrollIndicator = false
        self.view.addSubview(tblSubscriptionHistory)
    }
    
    

}



extension SubscriptionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHistoryHeight+10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscriptionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionHistry", for: indexPath) as! SubscriptionHistoryTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        cell.setUI(arrSubscriptionHistory[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        
        viewHeader.backgroundColor = .systemBackground
        let lblPlan = UILabel(frame: CGRect (x: 16, y: 0, width: tableView.frame.size.width, height: 50))
        lblPlan.font = UIFont (name: kFontBold, size: 20)
        lblPlan.text = "Subscriptions"
        
        viewHeader.addSubview(lblPlan)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}



extension SubscriptionHistoryViewController {
    func getUserSubscriptionHistory() {
        print("users list")
        print(kUsersDocumentID)
        
        Firestore.firestore().collection("users").document(kUsersDocumentID).getDocument { (querySnapshot, error) in
            if let error = error {
                print("error")
                print(error.localizedDescription)
            } else {
                arrUserSubscribed.removeAll()
                
                if let userData = querySnapshot?.data() {
                    if let subscriptions = userData["subscriptions"] as? [[String: Any]] {
                        self.arrSubscriptionHistory = subscriptions
                    }
                }
                
                DispatchQueue.main.async {
                    self.tblSubscriptionHistory.reloadData()
                }
            }
        }
    }

}
