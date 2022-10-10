//
//  EditShopVC.swift
//  Flytant
//
//  Created by Vivek Rai on 14/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class EditShopVC: UIViewController {
    
//    MARK: - Properties
    var isIconSelected = false
    var isBannerSelected = false
    var isIconButtonTapped = false
    var isBannerButtonTapped = false
    
//    MARK: Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    
    let headerImageView = FImageView(backgroundColor: UIColor.gray, cornerRadius: 0, image: UIImage(named: "defaultShopHeader")!)
    let shopIconImageView = FImageView(backgroundColor: UIColor.gray, cornerRadius: 50, image: UIImage(named: "defaultShopIcon")!)
    let editHeaderButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10))
    let editShopIconButton = FButton(backgroundColor: UIColor.clear, title: "Change Shop Icon", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 16))
    let shopNameTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter your store name")
    let shopWebsiteTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter your store website")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        contentView.backgroundColor = UIColor.systemBackground
        configureNavigationBar()
        setupScrollView()
        configureViews()
        fillShopDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor.secondarySystemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        tabBarController?.tabBar.isHidden = false
    }
    
    private func fillShopDetails(){
        guard let headerImageUrl = UserDefaults.standard.string(forKey: SHOP_BANNER_URL) else {return}
        guard let iconImageUrl = UserDefaults.standard.string(forKey: SHOP_ICON_URL) else {return}
        guard let storeName = UserDefaults.standard.string(forKey: SHOP_NAME) else {return}
        guard let storeWebsite = UserDefaults.standard.string(forKey: SHOP_WEBSITE) else {return}
        headerImageView.loadImage(with: headerImageUrl)
        shopIconImageView.loadImage(with: iconImageUrl)
        shopNameTextField.text = storeName
        shopWebsiteTextField.text = storeWebsite
        
    }
    
//    MARK: - ConfigureViews
    
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Edit Shop"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }
    
    private func configureViews(){
        contentView.addSubview(headerImageView)
        headerImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 100)
        headerImageView.layer.cornerRadius = 10
        
        contentView.addSubview(shopIconImageView)
        shopIconImageView.anchor(top: headerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        shopIconImageView.contentMode = .scaleAspectFill
        shopIconImageView.layer.borderColor = UIColor.systemBackground.cgColor
        shopIconImageView.layer.borderWidth = 2
        shopIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(editHeaderButton)
        editHeaderButton.anchor(top: headerImageView.topAnchor, left: nil, bottom: nil, right: headerImageView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 30, height: 30)
        editHeaderButton.setImage(UIImage(named: "editIcon"), for: .normal)
        editHeaderButton.addTarget(self, action: #selector(handleEditHeader), for: .touchUpInside)
        
        contentView.addSubview(editShopIconButton)
        editShopIconButton.anchor(top: shopIconImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 30)
        editShopIconButton.addTarget(self, action: #selector(handleEditIcon), for: .touchUpInside)
        editShopIconButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(shopNameTextField)
        shopNameTextField.delegate = self
        shopNameTextField.anchor(top: editShopIconButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        contentView.addSubview(shopWebsiteTextField)
        shopWebsiteTextField.delegate = self
        shopWebsiteTextField.anchor(top: shopNameTextField.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        
    }
    
    private func showIndicatorView() {
        contentView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
    
//    MARK: - Handlers
    
    @objc private func handleSave(){
        showIndicatorView()
        if let shopName = shopNameTextField.text, let shopWebsite = shopWebsiteTextField.text?.lowercased(), let userId = Auth.auth().currentUser?.uid{
            if self.isBannerSelected || self.isIconSelected{
                guard let bannerImage = self.headerImageView.image else {return}
                guard let bannerImageData = bannerImage.jpegData(compressionQuality: 0.4) else {return}
                let fileName = "\(userId)\(NSUUID().uuidString)"
                
                STORAGE_REF_SHOP_IMAGES.child(fileName).putData(bannerImageData, metadata: nil) { (metaData, error) in
                    if let _ = error{
                        self.dismissIndicatorView()
                        return
                    }
                    
                    STORAGE_REF_SHOP_IMAGES.child(fileName).downloadURL { (downloadUrl, error) in
                        if let _ = error{
                            self.dismissIndicatorView()
                            return
                        }
                        guard let bannerUrl = downloadUrl?.absoluteString else {return}
                        
                        guard let iconImage = self.shopIconImageView.image else {return}
                        guard let iconImageData = iconImage.jpegData(compressionQuality: 0.4) else {return}
                        let iconFileName = "\(userId)\("shopIcon")\(NSUUID().uuidString)"
                        STORAGE_REF_SHOP_IMAGES.child(iconFileName).putData(iconImageData, metadata: nil) { (metaData, error) in
                            if let _ = error{
                                self.dismissIndicatorView()
                                return
                            }
                            STORAGE_REF_SHOP_IMAGES.child(iconFileName).downloadURL { (downloadUrl, error) in
                                if let _ = error{
                                    self.dismissIndicatorView()
                                    return
                                }
                                guard let iconUrl = downloadUrl?.absoluteString else {return}
                                
                                let shopData = ["storeName": shopName, "storeWebsite": shopWebsite, "storeIcon": iconUrl, "storeBanner": bannerUrl]
                                
                                SHOP_REF.document(userId).setData(shopData) { (error) in
                                    if let _ = error{
                                        self.dismissIndicatorView()
                                        return
                                    }
                                    
                                    let alertVC = UIAlertController(title: "Updated", message: "Your details have been successfully updated.", preferredStyle: .alert)
                                    
                                    UserDefaults.standard.set(shopName, forKey: SHOP_NAME)
                                    UserDefaults.standard.set(shopWebsite, forKey: SHOP_WEBSITE)
                                    UserDefaults.standard.set(iconUrl, forKey: SHOP_ICON_URL)
                                    UserDefaults.standard.set(bannerUrl, forKey: SHOP_BANNER_URL)
                                    NotificationCenter.default.post(name: NSNotification.Name(RELOAD_SHOP_DATA), object: nil, userInfo: nil)
                                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alertVC, animated: true, completion: nil)
                                    self.dismissIndicatorView()
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                }
                
            }else{
                guard let bannerUrl = UserDefaults.standard.string(forKey: SHOP_BANNER_URL) else {return}
                guard let iconUrl = UserDefaults.standard.string(forKey: SHOP_ICON_URL) else {return}
                
                let shopData = ["storeName": shopName, "storeWebsite": shopWebsite, "storeIcon": iconUrl, "storeBanner": bannerUrl]
                
                SHOP_REF.document(userId).setData(shopData) { (error) in
                    if let _ = error{
                        self.dismissIndicatorView()
                        return
                    }
                    
                    let alertVC = UIAlertController(title: "Updated", message: "Your details have been successfully updated.", preferredStyle: .alert)
                    
                    UserDefaults.standard.set(shopName, forKey: SHOP_NAME)
                    UserDefaults.standard.set(shopWebsite, forKey: SHOP_WEBSITE)
                    UserDefaults.standard.set(iconUrl, forKey: SHOP_ICON_URL)
                    UserDefaults.standard.set(bannerUrl, forKey: SHOP_BANNER_URL)
                    NotificationCenter.default.post(name: NSNotification.Name(RELOAD_SHOP_DATA), object: nil, userInfo: nil)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                    self.dismissIndicatorView()
                }
                
            }
        }
    }

    @objc private func handleEditHeader(){
        self.isBannerButtonTapped = true
        handleImagePicker()
    }
    
    @objc private func handleEditIcon(){
        self.isIconButtonTapped = true
        handleImagePicker()
    }
    
    @objc private func handleImagePicker(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension EditShopVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shopNameTextField.resignFirstResponder()
        shopWebsiteTextField.resignFirstResponder()
        return true
    }
}

extension EditShopVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            if isIconButtonTapped{
                shopIconImageView.image = selectedImage
                self.isIconSelected = true
                self.isIconButtonTapped = false
            }
            if isBannerButtonTapped{
                headerImageView.image = selectedImage
                self.isBannerSelected = true
                self.isBannerButtonTapped = false
            }
                   
        }
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
