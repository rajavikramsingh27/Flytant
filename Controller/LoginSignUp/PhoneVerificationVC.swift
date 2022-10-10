//
//  PhoneVerificationVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SKCountryPicker
import SwiftToast

class PhoneVerificationVC: UIViewController {

//    MARK: - Properties
    var toast = SwiftToast()
    
//    MARK: - Views
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    private let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyTopImage")!)
    
    private let topLabel = FLabel(backgroundColor: UIColor.clear, text: "Verify Your Number", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .center, textColor: UIColor.white)
    
    private let containerView = UIView()
    
    private let countryImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 10, image: UIImage(named: "countryFlag")!)
    
    private let countryCodeLabel = FLabel(backgroundColor: UIColor.systemBackground, text: "+91", font: UIFont.systemFont(ofSize: 18), textAlignment: .center, textColor: .label)
    
    private let separatorView = UIView()
    
    private let phoneTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .none, contentType: .oneTimeCode, keyboardType: .numberPad, textAlignment: .left, placeholder: "Enter phone number")

//    private let verifyButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Verify", cornerRadius: 20, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
//    private let verifyButton = FGradientButton(cgColors: [UIColor(red: 15/255, green: 145/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 72/255, green: 20/255, blue: 122/255, alpha: 1).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    
    private let verifyButton = FButton(backgroundColor: UIColor.systemBackground, title: "Verify", cornerRadius: 20, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!)

    //private let boyLogoImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyBoyLogo")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureNavigationBar()
//        configureTopImageView()
//        configureTopLabel()
        configureContainerView()
        configureCountryImageView()
        configureCountryCodeLabel()
        configureSeparatorView()
        configurePhoneTextField()
        configureVerifyButton()
        //configureBoyLogoImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
//    MARK: - Handlers
    
    @objc func handleVerify(){
        showIndicatorView()
        guard let countryCode = countryCodeLabel.text, let phoneNumber = phoneTextField.text else {
            self.dismissIndicatorView()
            return
        }
        if phoneTextField.text?.count == 10{
            PhoneAuthProvider.provider().verifyPhoneNumber(countryCode + phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error{
                    self.toast = SwiftToast(text: "An error occured while signing. Error description \n\(error.localizedDescription).")
                    self.present(self.toast, animated: true)
                    self.dismissIndicatorView()
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: AUTH_VERIFICATION_ID)
                self.dismissIndicatorView()
                let otpVC = OtpVC(phoneNumber: countryCode + phoneNumber)
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
        }else{
            dismissIndicatorView()
            self.toast = SwiftToast(text: "Incorrect phone number entered. Please enter correct number and try again.")
            self.present(self.toast, animated: true)
            return
        }

        
    }
    
    @objc func handleCountryCodePicker(){
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
        guard let self = self else { return }
            self.countryImageView.image = country.flag
            self.countryCodeLabel.text = country.dialingCode
        }

        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.label
        countryController.flagStyle = .circular
        countryController.navigationController?.navigationBar.barTintColor = UIColor.systemRed
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
        navigationItem.title = "Verify Your Number"
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
    
    private func configureContainerView(){
         view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 240, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.label.cgColor
    }
    
    private func configureCountryImageView(){
        containerView.addSubview(countryImageView)
        countryImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 12, paddingRight: 0, width: 40, height: 40)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCountryCodePicker))
        countryImageView.contentMode = .scaleAspectFill
        tapGesture.numberOfTapsRequired = 1
        countryImageView.isUserInteractionEnabled = true
        countryImageView.addGestureRecognizer(tapGesture)
    }
    private func configureCountryCodeLabel(){
        containerView.addSubview(countryCodeLabel)
        countryCodeLabel.anchor(top: containerView.topAnchor, left: countryImageView.rightAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 60, height: 40)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCountryCodePicker))
        tapGesture.numberOfTapsRequired = 1
        countryCodeLabel.isUserInteractionEnabled = true
        countryCodeLabel.addGestureRecognizer(tapGesture)
    }

    private func configureSeparatorView(){
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: countryCodeLabel.rightAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 12, paddingRight: 0, width: 2, height: 0)
        separatorView.backgroundColor = UIColor.label
    }
    
    private func configurePhoneTextField(){
        containerView.addSubview(phoneTextField)
        phoneTextField.anchor(top: containerView.topAnchor, left: separatorView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 2, paddingLeft: 24, paddingBottom: 2, paddingRight: 8, width: 0, height: 40)
        phoneTextField.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func configureVerifyButton(){
        view.addSubview(verifyButton)
        verifyButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        verifyButton.addTarget(self, action: #selector(handleVerify), for: .touchUpInside)
        verifyButton.layer.borderColor = UIColor.label.cgColor
        verifyButton.layer.borderWidth = 1
    }
    
//    private func configureBoyLogoImageView(){
//        view.addSubview(boyLogoImageView)
//        boyLogoImageView.anchor(top: verifyButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 350)
//        NSLayoutConstraint.activate([
//            boyLogoImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1)
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

