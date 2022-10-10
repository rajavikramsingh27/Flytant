//
//  OtpVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//



import UIKit
import Firebase
import SwiftToast

class OtpVC: UIViewController {
    
//    MARK: - Properties
    var phoneNumber: String?
    var toast = SwiftToast()
//    MARK: - Views
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    private let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyTopImage")!)
       
    private let topLabel = FLabel(backgroundColor: UIColor.clear, text: "Enter the OTP", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: UIColor.white)
       
    private let otpTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .roundedRect, contentType: .oneTimeCode, keyboardType: .numberPad, textAlignment: .center, placeholder: "Enter the one time password")

//    private let confirmButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Confirm", cornerRadius: 20, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
//    private let confirmButton = FGradientButton(cgColors: [UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    private let confirmButton = FButton(backgroundColor: UIColor.systemBackground, title: "Verify", cornerRadius: 20, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!)
    
    private let resendOtpButton = FButton(backgroundColor: UIColor.clear, title: "Resend", cornerRadius: 0, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 18))
    
    //private let girlLogoImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "otpGirlLogo")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureNavigationBar()
//        configureTopImageView()
//        configureTopLabel()
        configureOtpTextField()
        configureConfirmButton()
        configureResendOtpButton()
        //configureGirlLogoImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    
    init(phoneNumber: String) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumber = phoneNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Handlers
    
    @objc func handleConfirm(){
        showIndicatorView()
        guard let otp = otpTextField.text, let verificationId = UserDefaults.standard.string(forKey: AUTH_VERIFICATION_ID), let phoneNumber = self.phoneNumber else {
            dismissIndicatorView()
            return
        }
        if otp.count == 6{
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otp)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                guard let userId = Auth.auth().currentUser?.uid else {
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "Wrong Otp entered. Please enter correct otp or try resending to receive new one.")
                    self.present(self.toast, animated: true)
                    return
                    
                }
                if let error = error {
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
                    self.present(self.toast, animated: true)
                    return
                }
                
                USER_REF.document(userId).getDocument { (document, error) in
                    if let error = error{
                        self.dismissIndicatorView()
                        self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
                        self.present(self.toast, animated: true)
                        return
                    }
                    
                    if let document = document{
                        if document.exists{
//                            login user
                            self.dismissIndicatorView()
                            let mainTabVC = MainTabVC()
                            self.navigationController?.pushViewController(mainTabVC, animated: true)
                        }else{
//                            signup user
                            self.dismissIndicatorView()
                            let usernameVC = UsernameVC()
                            usernameVC.phoneNumber = phoneNumber
                            let backItem = UIBarButtonItem()
                            backItem.title = ""
                            self.navigationItem.backBarButtonItem = backItem
                            self.navigationController?.pushViewController(usernameVC, animated: true)
                            
                        }
                    }
                }
            }
        }else{
            dismissIndicatorView()
            self.toast = SwiftToast(text: "Wrong Otp entered. Please enter correct otp or try resending to receive new one.")
            self.present(self.toast, animated: true)
            return
        }

    }
    
    @objc func handleResendOtp(){
        guard let phoneNumber = self.phoneNumber else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let error = error{
                self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
                self.present(self.toast, animated: true)
                return
            }
            guard let verificationId = verificationId else {return}
            UserDefaults.standard.set(verificationId, forKey: AUTH_VERIFICATION_ID)
            UserDefaults.standard.synchronize()
            self.toast = SwiftToast(text: "A new one time password has been resent on \(phoneNumber).")
            self.present(self.toast, animated: true)

        }
    }
    
//    private func configureNavigationBar(){
    //        navigationItem.largeTitleDisplayMode = .never
    //        navigationController?.navigationBar.barTintColor = UIColor.purple
    //        navigationController?.navigationBar.tintColor = UIColor.white
    //        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    //        navigationController?.navigationBar.titleTextAttributes = textAttributes
    //        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
    //        let titleView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "flytantIcon")!)
    //        navigationItem.titleView = titleView
    //        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    //        titleView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    //        navigationController?.setNavigationBarHidden(false, animated: true)
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
        navigationItem.title = "Enter OTP"
    }
    
    private func configureTopImageView(){
        view.addSubview(topImageView)
        topImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 64)
        topImageView.contentMode = .redraw
    }
    
    private func configureTopLabel(){
        topImageView.addSubview(topLabel)
        topLabel.anchor(top: topImageView.topAnchor, left: topImageView.leftAnchor, bottom: topImageView.bottomAnchor, right: topImageView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 16, paddingRight: 8, width: 0, height: 0)
    }
    
    private func configureOtpTextField(){
        view.addSubview(otpTextField)
        otpTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 240, paddingLeft: 32, paddingBottom: 2, paddingRight: 32, width: 0, height: 50)
        otpTextField.layer.cornerRadius = 20
        otpTextField.font = UIFont.systemFont(ofSize: 18)
    }
       
    private func configureConfirmButton(){
        view.addSubview(confirmButton)
        confirmButton.anchor(top: otpTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        confirmButton.layer.borderColor = UIColor.label.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
       
    private func configureResendOtpButton(){
        view.addSubview(resendOtpButton)
        resendOtpButton.anchor(top: confirmButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 40)
        NSLayoutConstraint.activate([
            resendOtpButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1)
        ])
        resendOtpButton.addTarget(self, action: #selector(handleResendOtp), for: .touchUpInside)
    }
    
//    private func configureGirlLogoImageView(){
//        view.addSubview(girlLogoImageView)
//        girlLogoImageView.anchor(top: resendOtpButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 300)
//        NSLayoutConstraint.activate([
//            girlLogoImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1)
//        ])
//    }
    
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
}
