//
//  TermsOfUseViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 21/02/22.
//

import UIKit
import WebKit



class TermsOfUseViewController: UIViewController {
    var navBar:UINavigationBar!
    var navTitle = ""
    var urlWeb = ""
    
    var loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        makeUI()
        setWebView()
    }
    
    func makeUI() {
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let viewUpperNav = UIView (frame: CGRect (x: 0, y: 0, width: Int(view.frame.size.width), height: sageAreaHeight()))
        
        viewUpperNav.backgroundColor = .systemBackground
        view.addSubview(viewUpperNav)
        
        let screenSize: CGRect = UIScreen.main.bounds
        navBar = UINavigationBar(frame: CGRect(x: 0, y: sageAreaHeight(), width: Int(screenSize.width), height: 44))
        navBar.barTintColor = UIColor.systemBackground
        navBar.shadowImage = UIImage()
        
        navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: kFontBold, size: 20)!]
        
        let navItem = UINavigationItem(title: navTitle)
                
        
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnBack.setImage(UIImage (named: "back_subscription.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
        
        let btnBarBack = UIBarButtonItem(customView: btnBack)
        
        navItem.leftBarButtonItem = btnBarBack
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    func setWebView()  {
        let url = URL(string: urlWeb)
        let request = URLRequest(url: url!)
        
        let webView = WKWebView(frame: self.view.frame)
        webView.frame.origin.y = navBar.frame.origin.y+navBar.frame.size.height
        webView.frame.size.height = self.view.frame.size.height - (navBar.frame.origin.y+navBar.frame.size.height)
        webView.navigationDelegate = self
        webView.load(request)
        
        self.view.addSubview(webView)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension TermsOfUseViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loader = showLoader()
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.removeFromSuperview()
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
