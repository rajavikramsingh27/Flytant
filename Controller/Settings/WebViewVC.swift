//
//  WebViewVC.swift
//  Flytant
//
//  Created by Vivek Rai on 08/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {

//    MARK: - Properties
    var urlString = ""
    
//    MARK: - Views
    var webView = WKWebView()
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
        
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }

    
    private func configureWebView(){
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc private func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissIndicatorView()
        self.navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showIndicatorView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dismissIndicatorView()
    }

}
