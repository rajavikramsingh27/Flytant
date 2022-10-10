//
//  LoginSignUpVC.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "loginSignUpCell"

class DisplayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK: - Variables
    
    //private var flowImages = [String]()
    
    private var flowImages = [
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F1.jpg?alt=media&token=9ae0c0a2-ffef-4c6c-a098-92447f9a8c58",
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F2.jpg?alt=media&token=6f7cfda9-73d7-46a4-a4f2-9617b79995d7",
     "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F3.jpg?alt=media&token=1bd4165d-80b4-4bbf-9e3f-9255083c79d9",
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F4.jpg?alt=media&token=dfb91bbd-8f4f-4db5-b5df-6fd2b1cbb1ec",
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F5.jpg?alt=media&token=f274b7a2-d3b9-4a63-a925-d7957f3d1edf",
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F6.jpg?alt=media&token=a816f549-788b-418a-8e78-b6e06ea761e0",
    "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F7.jpg?alt=media&token=6da2ee8e-117d-4fd6-9003-31e136b94ca9",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F8.jpg?alt=media&token=7f96e1b0-2e7d-4098-bf85-d80e3ee6f4a0",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F9.jpg?alt=media&token=90c8db7b-0693-47bc-b738-61ecf5330cec",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F10.jpg?alt=media&token=5d6b489f-ba07-402b-827d-86198908629b",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F11.jpg?alt=media&token=f32cbe17-6a65-4036-814a-02ae4fa47cab",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F12.jpg?alt=media&token=9fb3ba17-0cbc-40d5-bbe2-e785f8feb8dc",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F13.jpg?alt=media&token=86db043c-aa20-41f6-aee5-8abab93480f2",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F14.jpg?alt=media&token=43b8a7f8-74b7-499b-b99f-9a4ef16507db",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F15.jpg?alt=media&token=1da01d72-2e87-41dc-ab3a-067b6c8aaa1a",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F16.jpg?alt=media&token=1f1f0406-8add-484d-88ba-3ade3193c8d4",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F17.jpg?alt=media&token=512da76e-26bc-4d3e-87ba-33fd08f0f3f2",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F18.jpg?alt=media&token=316a4ef3-2cfa-49be-9a64-ad0c4ac2feda",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F19.jpg?alt=media&token=763616da-95c2-4895-9ef2-b3721b0cc3cc",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F20.jpg?alt=media&token=f12fb1fc-efdf-47af-8337-87f90a7773a9",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F21.jpg?alt=media&token=3b2a0209-0138-42a8-9c2f-81643eb94c7a",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F22.jpg?alt=media&token=9cb56456-386c-4e1d-a56a-1ed704b469e5",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F23.jpg?alt=media&token=650f2315-86ec-47b0-89aa-796e06a1dc04",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F24.jpg?alt=media&token=849ffe3f-4850-4ae3-8711-91bc11c5d578",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F25.jpg?alt=media&token=33d162d8-c38a-4164-8f46-08b2d03db9c0",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F26.jpg?alt=media&token=cc8a630d-f804-48ca-b663-387d5685a3a4",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F27.jpg?alt=media&token=240854c7-249d-44cc-88a5-4f772c6ef26a",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F28.jpg?alt=media&token=22346983-195c-4c18-89a3-bd8fb613de44",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F29.jpg?alt=media&token=889f6946-07fa-4a19-bbf4-d2e63e324e9c",
      "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/display_images%2F30.jpg?alt=media&token=62f5c41e-4907-4da9-9a4f-2f4bc4d0a049"
    ]
    var timer: Timer?
    
//    MARK: - Views
    
    private var flowCollectionView: UICollectionView!
    
    private let logoImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "flytantIcon")!)
    
//    private let textLabel = FLabel(backgroundColor: UIColor.clear, text: "Welcome to Flytant", font: UIFont.boldSystemFont(ofSize: 28), textAlignment: .center, textColor: .label)
    
//    private let loginSignUpButton = FButton(backgroundColor: UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1), title: "Login | Sign up", cornerRadius: 20, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))\
    private let loginSignUpButton = FButton(backgroundColor: UIColor.systemBackground, title: "Let's Start", cornerRadius: 20, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!)
    
    private let skipButton = FButton(backgroundColor: UIColor.clear, title: "Skip", cornerRadius: 0, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 18))
    
    private let eulaLabel = FLabel(backgroundColor: UIColor.clear, text: "By continuing, you agree to Flytant's", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
    let termsButton = FButton(backgroundColor: UIColor.clear, title: "Terms of Service", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 12))
    let privacyButton = FButton(backgroundColor: UIColor.clear, title: "Privacy", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 12))
    let andLabel = FLabel(backgroundColor: UIColor.clear, text: "and", font: UIFont.systemFont(ofSize: 12), textAlignment: .center, textColor: UIColor.label)
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureFlowCollectionView()
        configureEULA()
        configureSkipButton()
        configureLoginSignUpButton()
        configureLogoImageView()
        showIndicatorView()
        handleTimer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //setRemoteConfigData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    MARK: - Handlers
    
    private func setRemoteConfigData(){
        let remoteConfigData = RemoteConfigManager.getExploreCategoryData(for: "display_images")
        if !remoteConfigData.isEmpty{
            flowImages = remoteConfigData[1]
        }else{
            setRemoteConfigData()
            flowCollectionView.reloadData()
        }
    }
    
    @objc private func handleLoginSignUp(){
        let loginSignUpVC = LoginSignUpVC()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(loginSignUpVC, animated: true)
    }
    
    @objc private func handleSkip(){
        showIndicatorView()
        Auth.auth().signInAnonymously { (result, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            let mainTabVC = MainTabVC()
            self.navigationController?.pushViewController(mainTabVC, animated: true)
            self.dismissIndicatorView()
            
        }
    }
    
    private func configureFlowCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 320)
        flowCollectionView = UICollectionView(frame: frame, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        flowCollectionView.delegate = self
        flowCollectionView.dataSource = self
        flowCollectionView.backgroundColor = .clear
        flowCollectionView.translatesAutoresizingMaskIntoConstraints = false
        flowCollectionView.showsVerticalScrollIndicator = false
        flowCollectionView.register(LoginSignUpCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(flowCollectionView)
        flowCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height - 320)

    }
    
    private func configureLoginSignUpButton(){
        view.addSubview(loginSignUpButton)
        loginSignUpButton.anchor(top: nil, left: view.leftAnchor, bottom: skipButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 50)
        loginSignUpButton.addTarget(self, action: #selector(handleLoginSignUp), for: .touchUpInside)
        loginSignUpButton.setTitle("Let's Start", for: .normal)
        loginSignUpButton.layer.borderWidth = 1
        loginSignUpButton.layer.shadowColor = UIColor.systemGray.cgColor
        loginSignUpButton.layer.shadowOpacity = 0.4
        loginSignUpButton.titleLabel?.font = UIFont(name: "RoundedMplus1c-Bold", size: 18)
        loginSignUpButton.layer.borderColor = UIColor.label.cgColor
        
    }
    
    private func configureEULA(){
        let stackView = UIStackView(arrangedSubviews: [termsButton, andLabel, privacyButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 2, paddingRight: 0, width: 180, height: 20)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        view.addSubview(eulaLabel)
        eulaLabel.anchor(top: nil, left: view.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 16)
        termsButton.addTarget(self, action: #selector(handleTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
    }
    
    
    
    private func configureSkipButton(){
        view.addSubview(skipButton)
        skipButton.anchor(top: nil, left: view.leftAnchor, bottom: eulaLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 64, paddingBottom: 8, paddingRight: 64, width: 0, height: 30)
        skipButton.titleLabel?.font = UIFont(name: "RoundedMplus1c-Bold", size: 16)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        skipButton.isHidden = true
    }
    
//    private func configureTextLabel(){
//        view.addSubview(textLabel)
//        textLabel.anchor(top: nil, left: view.leftAnchor, bottom: loginSignUpButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 32, paddingRight: 32, width: 0, height: 30)
//    }
    
    private func configureLogoImageView(){
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.bottomAnchor.constraint(equalTo: loginSignUpButton.topAnchor, constant: 32),
            logoImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        logoImageView.contentMode = .scaleAspectFit
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
        timer?.invalidate()
    }
    
//    MARK: - CollectionView Delegate and DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flowImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LoginSignUpCollectionViewCell
        cell.imageView.loadImage(with: flowImages[indexPath.row])
        return cell
    }
    
//    MARK: - Handlers
    
    private func handleTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
            self.dismissIndicatorView()
        }
    }
    
    @objc private func handleTerms(){
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://flytant.com/terms/"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @objc private func handlePrivacy(){
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://flytant.com/privacy-policy/"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    
}
