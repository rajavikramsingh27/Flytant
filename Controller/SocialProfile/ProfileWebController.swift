//
//  ProfileWebController.swift
//  Flytant
//
//  Created by Flytant on 24/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import WebKit

protocol ProfileWebDelegate: AnyObject {
    func returnInstagram(code: String)
    func userCanceled()
}

class ProfileWebController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    weak var delegate: ProfileWebDelegate?
    private var code: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewInit()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if code.isEmpty {
            delegate?.userCanceled()
        }
    }
    
    private func webViewInit() {
        let urlRequest = URLRequest(url: URL(string: "https://www.instagram.com/oauth/authorize?client_id=191312392530647&amp;redirect_uri=https://flytant.com/&amp;scope=user_profile,user_media&amp;response_type=code")!)
        webView.load(urlRequest)
        webView.navigationDelegate = self
    }


}
extension ProfileWebController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString, url.contains("https://flytant.com/?code=") {
            let temp = url.replacingOccurrences(of: "https://flytant.com/?code=", with: "")
            let code = temp.replacingOccurrences(of: "#_", with: "")
            self.code = code
            delegate?.returnInstagram(code: code)
            decisionHandler(.cancel)
            dismiss(animated: true, completion: nil)
        } else {
            decisionHandler(.allow)
        }
    }
}
