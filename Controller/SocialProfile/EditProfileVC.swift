//
//  EditProfileVC.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import SwiftToast

class EditProfileVC: UIViewController {
    
//    MARK: - Variables
    var genderData = ["Female", "Male", "Custom", "Prefer not to say"]
    var imageSelected = false
    var toast = SwiftToast()
//    MARK: - Views
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let datePicker = UIDatePicker()
    private let genderPicker = UIPickerView()
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    private let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "verifyTopImage")!)
    
    private let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 60, image: UIImage(named: "imagePicker")!)
    
    private let changeProfileImageButton = FButton(backgroundColor: UIColor.clear, title: "Change Profile Photo", cornerRadius: 0, titleColor: .label, font: UIFont.boldSystemFont(ofSize: 16))

    private let nameTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Name")
    
    private let usernameTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .username, keyboardType: .alphabet, textAlignment: .left, placeholder: "Enter Username")
    
    private let dobTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Date Of Birth")
    
    private let genderTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Gender")
    
    private let emailTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .emailAddress, keyboardType: .emailAddress, textAlignment: .left, placeholder: "Enter Email")
    
    private let websiteTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .URL, keyboardType: .URL, textAlignment: .left, placeholder: "Enter Website URL")
    
    private let bioTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter About Yourself")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        contentView.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        configureNavigationBar()
//        configureTopImageView()
        configureProfileImageView()
        configureChangeProfileImageButton()
        configureNameTextField()
        configureusernameTextField()
        configureDobTextField()
        configureGenderTextField()
        configureEmailTextField()
        configureWebsiteTextField()
        configureBioTextField()
        configurePickerViews()
        
        fillUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
//    MARK: - Handlers
    
    @objc private func handleImagePicker(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0{
               self.view.frame.origin.y -= keyboardSize.height
           }
       }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }
    }
    
    @objc func donePicker(){
        genderTextField.resignFirstResponder()
        dobTextField.resignFirstResponder()
        if let datePicker = self.dobTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.dobTextField.text = dateformatter.string(from: datePicker.date)
        }
    }
    
    @objc private func handleSave(){
        showIndicatorView()
        guard let name = nameTextField.text, let username = usernameTextField.text?.lowercased(), let dob = dobTextField.text, let gender = genderTextField.text, let email = emailTextField.text?.lowercased(), let websiteUrl = websiteTextField.text?.lowercased(), let bio = bioTextField.text, let userID = Auth.auth().currentUser?.uid else {return}
        
        var userData = ["email": email, "name": name, "username": username, "dateOfBirth": dob, "gender": gender, "bio": bio, "websiteUrl": websiteUrl]
        
        if username.isAlphanumeric && username.count > 3 && username.count < 16 && bio.count < 144{
            USER_REF.getDocuments { (snapshot, error) in
                if let error = error{
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "Error occured. Error description: \n \(error.localizedDescription)")
                    self.present(self.toast, animated: true)
                    return
                }
                        
                guard let snapshot = snapshot else {self.dismissIndicatorView(); return}
                for document in snapshot.documents{
                    let data = document.data()
                    let usernameEntered = data["username"] as? String ?? ""
        
                    if usernameEntered == username && document.documentID != userID{
                        self.toast = SwiftToast(text: "An error occured. Please try again.")
                        self.present(self.toast, animated: true)
                        self.dismissIndicatorView()
                        return
                    }
                }
                
                if self.imageSelected{
                    guard let profileImage = self.profileImageView.image else {return}
                    guard let profileImageData = profileImage.jpegData(compressionQuality: 0.4) else {return}
                    let fileName = "\(userID)\(NSUUID().uuidString)"
                    
                    STORAGE_REF_PROFILE_IMAGES.child(fileName).putData(profileImageData, metadata: nil) { (metaData, error) in
                        if let error = error{
                            self.dismissIndicatorView()
                            self.toast = SwiftToast(text: "Error occured. Error description: \n \(error.localizedDescription)")
                            self.present(self.toast, animated: true)
                            return
                        }
                        
                        STORAGE_REF_PROFILE_IMAGES.child(fileName).downloadURL { (downloadURL, error) in
                            if let error = error{
                                self.dismissIndicatorView()
                                self.toast = SwiftToast(text: "Error occured. Error description: \n \(error.localizedDescription)")
                                self.present(self.toast, animated: true)
                                return
                            }
                            guard let profileImageURL = downloadURL?.absoluteString else {
                                self.dismissIndicatorView()
                                return
                            }
                            
                            userData = ["email": email, "name": name, "username": username, "dateOfBirth": dob, "gender": gender, "bio": bio, "websiteUrl": websiteUrl, "profileImageUrl": profileImageURL]

                            USER_REF.document(userID).updateData(userData) { (error) in
                                if let error = error{
                                    self.dismissIndicatorView()
                                    self.toast = SwiftToast(text: "Error occured. Error description: \n \(error.localizedDescription)")
                                    self.present(self.toast, animated: true)
                                    return
                                }
                                self.dismissIndicatorView()
                                let alertVC = UIAlertController(title: "Updated", message: "Your details have been successfully updated.", preferredStyle: .alert)
                                UserDefaults.standard.set(profileImageURL, forKey: PROFILE_IMAGE_URL)
//                                DataService.instance.setDefaults(profileImageUrl: profileImageURL, name: name, username: username, phoneNumber: UserDefaults.standard.string(forKey: PHONE_NUMBER) ?? "", dob: dob, gender: gender, email: email, website: websiteUrl, bio: bio, youtubeId: "", twitterId: "", categories: [String]())
                                NotificationCenter.default.post(name: NSNotification.Name(RELOAD_PROFILE_DATA), object: nil, userInfo: nil)
                                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }))
                                self.present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }else{

                    USER_REF.document(userID).updateData(userData) { (error) in
                        if let error = error{
                            self.dismissIndicatorView()
                            self.toast = SwiftToast(text: "Error occured. Error description: \n \(error.localizedDescription)")
                            self.present(self.toast, animated: true)
                            return
                        }
                        self.dismissIndicatorView()
                        let alertVC = UIAlertController(title: "Updated", message: "Your details have been successfully updated.", preferredStyle: .alert)
                        if let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL){
//                            DataService.instance.setDefaults(profileImageUrl: profileImageUrl, name: name, username: username, phoneNumber: UserDefaults.standard.string(forKey: PHONE_NUMBER) ?? "", dob: dob, gender: gender, email: email, website: websiteUrl, bio: bio)
                        }else{
//                            DataService.instance.setDefaults(profileImageUrl: DEFAULT_PROFILE_IMAGE_URL, name: name, username: username, phoneNumber: UserDefaults.standard.string(forKey: PHONE_NUMBER) ?? "", dob: dob, gender: gender, email: email, website: websiteUrl, bio: bio)
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(RELOAD_PROFILE_DATA), object: nil, userInfo: nil)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }else{
            dismissIndicatorView()
            if bio.count > 143{
                self.toast = SwiftToast(text: "Bio Too Long. About yourself can have maximum 143 charcters.")
                self.present(self.toast, animated: true)
                return
            }else{
                self.toast = SwiftToast(text: "Invalid username. Username must be alphanumeric and 4 to 15 charcters long.")
                self.present(self.toast, animated: true)
                return
            }
        }
        
    }
    
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
    
    
//    private func configureNavigationBar(){
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
//        navigationItem.title = "Edit Profile"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
//    }
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }

    
    private func configureTopImageView(){
        contentView.addSubview(topImageView)
        topImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 64)
        topImageView.contentMode = .redraw
    }
    
    
    private func configureProfileImageView(){
        contentView.addSubview(profileImageView)
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 64, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.borderWidth = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImagePicker))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 1)
        ])
    }
    
    private func configureChangeProfileImageButton(){
        contentView.addSubview(changeProfileImageButton)
        changeProfileImageButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 30)
        NSLayoutConstraint.activate([
            changeProfileImageButton.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 1)
        ])
        changeProfileImageButton.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
    }
    
    private func configureNameTextField(){
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)
        nameTextField.anchor(top: changeProfileImageButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureusernameTextField(){
        usernameTextField.delegate = self
        contentView.addSubview(usernameTextField)
        usernameTextField.anchor(top: nameTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureDobTextField(){
        dobTextField.inputView = datePicker
        contentView.addSubview(dobTextField)
        dobTextField.anchor(top: usernameTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureGenderTextField(){
        genderTextField.inputView = genderPicker
        contentView.addSubview(genderTextField)
        genderTextField.anchor(top: dobTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureEmailTextField(){
        emailTextField.delegate = self
        contentView.addSubview(emailTextField)
        emailTextField.anchor(top: genderTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureWebsiteTextField(){
        websiteTextField.delegate = self
        contentView.addSubview(websiteTextField)
        websiteTextField.anchor(top: emailTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureBioTextField(){
        bioTextField.delegate = self
        contentView.addSubview(bioTextField)
        bioTextField.anchor(top: websiteTextField.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 48, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configurePickerViews(){
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemRed
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        genderTextField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = .date
        dobTextField.inputAccessoryView = toolBar
        
    }
    
    private func fillUserDetails(){
        if let name = UserDefaults.standard.string(forKey: NAME), let username = UserDefaults.standard.string(forKey: USERNAME), let dob = UserDefaults.standard.string(forKey: DATE_OF_BIRTH), let gender = UserDefaults.standard.string(forKey: GENDER), let email = UserDefaults.standard.string(forKey: EMAIL), let websiteUrl = UserDefaults.standard.string(forKey: WEBSITE), let bio = UserDefaults.standard.string(forKey: BIO), let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL){
            profileImageView.loadImage(with: profileImageUrl)
            nameTextField.text = name
            usernameTextField.text = username
            dobTextField.text = dob
            genderTextField.text = gender
            emailTextField.text = email
            websiteTextField.text = websiteUrl
            bioTextField.text = bio
        }
        
    }
}

extension EditProfileVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        websiteTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == websiteTextField || textField == bioTextField{
            addKeyboardObservers()
        }
        if textField == nameTextField || textField == usernameTextField || textField == genderTextField || textField == dobTextField{
            keyboardWillHide(notification: NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil) )
            removeKeyboardObservers()
        }
    }
    
    private func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            profileImageView.image = selectedImage
            self.imageSelected = true
            
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

extension EditProfileVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPicker{
            return genderData.count
        }else{
            return 0
        }
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker{
            genderTextField.text = genderData[row]
        }
    }
    
}
