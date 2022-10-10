//
//  LoginSignUpVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import SwiftToast
import AuthenticationServices
import CryptoKit

class LoginSignUpVC: UIViewController, GIDSignInDelegate, LoginButtonDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
   
//    MARK: - Properties
    var toast = SwiftToast()
    var currentNonce: String?
    
//    MARK: - Views
    let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyTopImage")!)
    
    let topLabel = FLabel(backgroundColor: UIColor.clear, text: "Login | Sign Up", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .center, textColor: UIColor.white)
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    let dismissButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont())
    let containerView = UIView()
    let googleSignInButton = FButton(backgroundColor:  UIColor.systemBackground, title: "", cornerRadius: 10, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 16))
    let facebookSignInButton = FButton(backgroundColor:  UIColor.systemBackground, title: "", cornerRadius: 10, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 16))
    let appleSignInButton = FButton(backgroundColor:  UIColor.systemBackground, title: "", cornerRadius: 10, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 16))
    let phoneSignInButton = FButton(backgroundColor:  UIColor.systemBackground, title: "", cornerRadius: 10, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 16))
    let orLabel = FLabel(backgroundColor:  UIColor.systemBackground, text: "OR", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
//        configureTopImageView()
//        configureTopLabel()
        configureContianerView()
        configureGoogleSignInButton()
        configureFacebookSignInButton()
        configureAppleSignInButton()
        configureOrLabel()
        configurePhoneSignInButton()
        
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//    MARK: - Configure Views
    
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.label
//        navigationController?.navigationBar.tintColor = UIColor.label
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
//        navigationItem.title = "Login | Sign Up"
//
//    }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Login | Sign Up"
    }

    
    private func configureTopImageView(){
        view.addSubview(topImageView)
        topImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 64)
        topImageView.contentMode = .redraw
    }
    
    private func configureTopLabel(){
        topImageView.addSubview(topLabel)
        topLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: topImageView.leftAnchor, bottom: nil, right: topImageView.rightAnchor, paddingTop: 24, paddingLeft: 8, paddingBottom: 16, paddingRight: 8, width: 0, height: 20)
    }
    
    private func configureContianerView(){
        view.addSubview(containerView)
        containerView.backgroundColor =  UIColor.systemBackground
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 10
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 240, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 400)
    }
    
    private func configureGoogleSignInButton() {
        containerView.addSubview(googleSignInButton)
        googleSignInButton.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 32, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        googleSignInButton.backgroundColor = UIColor.systemBackground
        googleSignInButton.setAttributedTitle(AttributedTextwithImagePrefix(AttributeImage: UIImage(named: "googleSignIn")!, AttributedText: "Continue with Google", buttonBound: self.googleSignInButton), for: .normal)
        googleSignInButton.layer.borderColor = UIColor.label.cgColor
        googleSignInButton.layer.borderWidth = 1
        googleSignInButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }
    
    private func configureFacebookSignInButton(){
        containerView.addSubview(facebookSignInButton)
        facebookSignInButton.anchor(top: googleSignInButton.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        facebookSignInButton.backgroundColor = UIColor.systemBackground
        facebookSignInButton.setAttributedTitle(AttributedTextwithImagePrefix(AttributeImage: UIImage(named: "facebookSignIn")!, AttributedText: "Continue with Facebook", buttonBound: self.facebookSignInButton), for: .normal)
        facebookSignInButton.layer.borderColor = UIColor.label.cgColor
        facebookSignInButton.layer.borderWidth = 1
        facebookSignInButton.addTarget(self, action: #selector(facebookSignIn), for: .touchUpInside)
    }
    
    private func configureAppleSignInButton(){
        containerView.addSubview(appleSignInButton)
        appleSignInButton.anchor(top: facebookSignInButton.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        appleSignInButton.backgroundColor = UIColor.systemBackground
        appleSignInButton.setAttributedTitle(AttributedTextwithImagePrefix(AttributeImage: UIImage(named: "appleSignIn")!, AttributedText: "Continue with Apple", buttonBound: self.appleSignInButton), for: .normal)
        appleSignInButton.layer.borderColor = UIColor.label.cgColor
        appleSignInButton.layer.borderWidth = 1
        appleSignInButton.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
    }
    
    private func configureOrLabel(){
        containerView.addSubview(orLabel)
        orLabel.anchor(top: appleSignInButton.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
    }
    
    private func configurePhoneSignInButton(){
        containerView.addSubview(phoneSignInButton)
        phoneSignInButton.anchor(top: orLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        phoneSignInButton.backgroundColor = UIColor.systemBackground
        phoneSignInButton.setAttributedTitle(AttributedTextwithImagePrefix(AttributeImage: UIImage(named: "phoneSignIn")!, AttributedText: "Continue with Phone", buttonBound: self.phoneSignInButton), for: .normal)
        phoneSignInButton.layer.borderColor = UIColor.label.cgColor
        phoneSignInButton.layer.borderWidth = 1
        phoneSignInButton.addTarget(self, action: #selector(phoneSignIn), for: .touchUpInside)
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
    
//    MARK: - Handlers
    
    @objc private func googleSignIn(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc private func facebookSignIn(){
        DataService.instance.loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            guard let result = result else {return}
            guard let token = result.token?.tokenString else {return}
            if let _ = error {
                self.toast = SwiftToast(text: "An error occured while signing. Please try again.")
                self.present(self.toast, animated: true)
                return
            } else if result.isCancelled {
                self.toast = SwiftToast(text: "SignIn cancelled. Please try again.")
                self.present(self.toast, animated: true)
                return
            } else {
                self.showIndicatorView()
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                self.firebaseLogin(credential)
            }
        }
    }
    
    @objc private func appleSignIn(){
        let request = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc private func phoneSignIn(){
        let phoneVerificationVC = PhoneVerificationVC()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(phoneVerificationVC, animated: true)
        
    }
    
//    MARK: - GoogleSignIn
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error{
            toast = SwiftToast(text: "An error occured while signing. Please try again.")
            present(toast, animated: true)
            return
        }
        showIndicatorView()
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        firebaseLogin(credential)
    }
    
    
//    MARK: - FacebookSignIn
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let _ = error{
            toast = SwiftToast(text: "An error occured while signing. Please try again.")
            present(toast, animated: true)
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
//    MARK: - FirebasLogin
    private func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [self] (result, error) in
            
            guard let result = result else {return}
            guard let isNewUser = result.additionalUserInfo?.isNewUser else {return}
            
            if isNewUser {
                let usernameVC = UsernameVC()
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                                
                self.navigationController?.pushViewController(usernameVC, animated: true)
                self.dismissIndicatorView()
            } else {
                let mainTabVC = MainTabVC()
                self.navigationController?.pushViewController(mainTabVC, animated: true)
                self.dismissIndicatorView()
            }
        }
    }
    
    
    func AttributedTextwithImagePrefix(AttributeImage : UIImage , AttributedText : String , buttonBound : UIButton) -> NSMutableAttributedString{
        let fullString = NSMutableAttributedString(string: "   ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: ((buttonBound.titleLabel?.font.capHeight)! - AttributeImage.size.height).rounded() / 2, width: AttributeImage.size.width, height: AttributeImage.size.height)
        image1Attachment.image = AttributeImage
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: "  " + AttributedText))
        return fullString
    }
    
//    MARK: - Apple SignIn Helper Method
    
    private func createAppleIdRequest() -> ASAuthorizationAppleIDRequest{
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
          precondition(length > 0)
          let charset: Array<Character> =
              Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
          var result = ""
          var remainingLength = length

          while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
              var random: UInt8 = 0
              let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
              if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
              }
              return random
            }

            randoms.forEach { random in
              if remainingLength == 0 {
                return
              }

              if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
              }
            }
          }

          return result
    }

    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
//    MARK: - Apple signIn Delegates
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else {
                fatalError("Invalid state")
            }
            guard let appleIdToken = appleIdCredential.identityToken else {return}
            guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else {return}
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            firebaseLogin(credential)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


