//
//  SwipeSetting.swift
//  Flytant
//
//  Created by Vivek Rai on 31/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import SDWebImage

class SwipeSetting: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    MARK: - Properties
    
    var imageIndex = 0
    var genderData = ["Female", "Male", "Custom", "Prefer not to say"]
    let imagePicker = UIImagePickerController()
    var isFirstImageSelected = false
    var isSecondImageSelected = false
    var isThirdImageSelected = false
    var  showCancel = true
    var selectedImages = [UIImage]()
    var swipeImageUrls = [String]()
    var imageCount = 0
    var index = 0
    
    
//    MARK: - Views
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var buttonPicker1 = UIButton()
    private var buttonPicker2 = UIButton()
    private var buttonPicker3 = UIButton()
    private var buttons = [UIButton]()
    let saveButton = FButton(backgroundColor: UIColor.clear, title: "Save", cornerRadius: 0, titleColor: UIColor.label, font: UIFont.boldSystemFont(ofSize: 20))
    private let nameLabel = FLabel(backgroundColor: UIColor.secondarySystemBackground, text: "   Name", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    private let bioLabel = FLabel(backgroundColor: UIColor.secondarySystemBackground, text: "   Bio", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    private let genderLabel = FLabel(backgroundColor: UIColor.secondarySystemBackground, text: "   Gender", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    private let dobLabel = FLabel(backgroundColor: UIColor.secondarySystemBackground, text: "   Date of Birth", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.label)
    private let nameTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Name...")
    private let bioTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Bio...")
    private let genderTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Enter Gender...")
    private let dobTextField = FTextField(backgroundColor: UIColor.systemBackground, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Choose Date of Birth...")
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    private let datePicker = UIDatePicker()
    private let genderPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        view.backgroundColor = UIColor.systemBackground
        contentView.backgroundColor = UIColor.systemBackground
        configureNavigationBar()
        setupScrollView()
        configureViews()
        configurePickerViews()
        //fillUserDetails()
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Swipe Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        if showCancel{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
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
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 48).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func configureViews(){
        imagePicker.delegate = self
        
        contentView.addSubview(saveButton)
        saveButton.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 50, height: 32)
        saveButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        if showCancel{
            saveButton.isHidden = false
        }else{
            saveButton.isHidden = true
        }
        buttonPicker1 = createButton(index: 0)
        contentView.addSubview(buttonPicker1)
        buttonPicker1.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 48, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        buttonPicker1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        
        buttonPicker2 = createButton(index: 1)
        buttonPicker3 = createButton(index: 2)
        
        let stack = UIStackView(arrangedSubviews: [buttonPicker2, buttonPicker3])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        contentView.addSubview(stack)
        stack.anchor(top: contentView.topAnchor, left: buttonPicker1.rightAnchor, bottom: buttonPicker1.bottomAnchor, right: contentView.rightAnchor, paddingTop: 48, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        buttons.append(buttonPicker1)
        buttons.append(buttonPicker2)
        buttons.append(buttonPicker3)
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: buttonPicker1.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        contentView.addSubview(bioLabel)
        bioLabel.anchor(top: nameTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        bioTextField.delegate = self
        contentView.addSubview(bioTextField)
        bioTextField.anchor(top: bioLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        contentView.addSubview(genderLabel)
        genderLabel.anchor(top: bioTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        genderTextField.delegate = self
        genderTextField.inputView = genderPicker
        contentView.addSubview(genderTextField)
        genderTextField.anchor(top: genderLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        contentView.addSubview(dobLabel)
        dobLabel.anchor(top: genderTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        dobTextField.delegate = self
        dobTextField.inputView = datePicker
        contentView.addSubview(dobTextField)
        dobTextField.anchor(top: dobLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingBottom: 32, paddingRight: 0, width: 0, height: 40)
        
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
    
    private func createButton(index: Int) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .secondarySystemBackground
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
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
    
    private func fillUserDetails(){
        if let name = UserDefaults.standard.string(forKey: NAME), let dob = UserDefaults.standard.string(forKey: DATE_OF_BIRTH), let gender = UserDefaults.standard.string(forKey: GENDER), let bio = UserDefaults.standard.string(forKey: BIO), let swipeImageUrls = UserDefaults.standard.stringArray(forKey: SWIPE_IMAGE_URLS){
            bioTextField.text = bio
            nameTextField.text = name
            dobTextField.text = dob
            genderTextField.text = gender
            if !swipeImageUrls.isEmpty && swipeImageUrls.count > 2{
                guard let swipeImageUrls = UserDefaults.standard.stringArray(forKey: SWIPE_IMAGE_URLS) else {return}
                guard let firstUrl = URL(string: "\(swipeImageUrls[0])") else {return}
                let firstData = try? Data(contentsOf: firstUrl)
                if let imageData = firstData {
                    guard let image = UIImage(data: imageData) else {return}
                    buttonPicker1.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.selectedImages.insert(image, at: 0)
                }

                guard let secondUrl = URL(string: "\(swipeImageUrls[1])") else {return}
                let secondData = try? Data(contentsOf: secondUrl)
                if let imageData = secondData {
                    guard let image = UIImage(data: imageData) else {return}
                    buttonPicker2.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.selectedImages.insert(image, at: 1)
                }

                guard let thirdUrl = URL(string: "\(swipeImageUrls[2])") else {return}
                let thirdData = try? Data(contentsOf: thirdUrl)
                if let imageData = thirdData {
                    guard let image = UIImage(data: imageData) else {return}
                    buttonPicker3.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.selectedImages.insert(image, at: 2)
                }
            }
            
        }
        
    }
    
    
    
//    MARK: - Handlers
    
    
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone(){
        let alertController = UIAlertController(title: "Do you want save changes?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.saveData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleSelectPhoto(sender: UIButton){
        imageIndex = sender.tag
        present(imagePicker, animated: true, completion: nil)
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
    
    func saveData(){
        guard let swipeImageUrls = UserDefaults.standard.array(forKey: SWIPE_IMAGE_URLS) else {return}
        debugPrint(nameTextField.text)
        if nameTextField.text != ""{
            
            if bioTextField.text != ""{
                if genderTextField.text != ""{
                    if dobTextField.text != ""{
                        if self.imageCount == 3 || !swipeImageUrls.isEmpty{
                            self.uploadPost(forIndex: self.index)
                        }else{
                            ProgressHUD.showError("Please choose images for your profile.")
                        }
                        
//                        if self.imageCount > 0 {
//                            self.uploadPost(forIndex: self.index)
//                        }else if !swipeImageUrls.isEmpty{
//                            self.uplodadData()
//                        }else{
//                            ProgressHUD.showError("Please choose images for your profile.")
//                        }
                    }else{
                        ProgressHUD.showError("Please enter date of birth.")
                    }
                }else{
                    ProgressHUD.showError("Please choose your gender.")
                }
            }else{
                ProgressHUD.showError("Please enter a bio, describing yourself.")
            }
        }else{
            ProgressHUD.showError("Please enter your name.")
        }
        
    }
    
    
    private func uploadImages(userDataUploadComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
           self.showIndicatorView()

           guard let currentUserId = Auth.auth().currentUser?.uid else {return}
           guard let uploadData = self.selectedImages[index].jpegData(compressionQuality: 0.4) else { return }
           
           SWIPE_USER_IMAGES.child(currentUserId).child("\(index)").putData(uploadData, metadata: nil) { (metaData, error) in
            
               if let error = error{
                   self.dismissIndicatorView()
                   ProgressHUD.showError("An error occured while upldoading. Please try again.")
                   userDataUploadComplete(false, error)
                   return
               }
                SWIPE_USER_IMAGES.child(currentUserId).child("\(self.index)").downloadURL { (url, error) in
                   if let error = error{
                       self.dismissIndicatorView()
                       ProgressHUD.showError("An error occured while upldoading. Please try again.")
                       userDataUploadComplete(false, error)
                       return
                   }
                   guard let imageUrl = url?.absoluteString else {return}
                   self.swipeImageUrls.append(imageUrl)
                   self.dismissIndicatorView()
                   userDataUploadComplete(true, nil)
               }
           }
       }
        
        
   private func uploadPost(forIndex index: Int){
        //
       if self.index < selectedImages.count{
           //  call the completion block
           uploadImages() { (success, error) in
               if success{
                   self.index = self.index + 1
                   print(self.index)
                   self.uploadPost(forIndex: self.index)
                   
               }else{
                   self.uploadPost(forIndex: self.index)
               }
           }
       }else{
           self.showIndicatorView()
            guard let name = self.nameTextField.text, let bio = self.bioTextField.text, let gender = genderTextField.text, let dob = dobTextField.text, let currentUserId = Auth.auth().currentUser?.uid else {return}
            let data = ["name": name, "bio": bio, "gender": gender, "dateOfBirth": dob, "swipeImageUrls": swipeImageUrls] as [String: Any]
            USER_REF.document(currentUserId).updateData(data) { (error) in
                if let _ = error{
                    self.dismissIndicatorView()
                    return
                }
                //set User Defaults here
                UserDefaults.standard.set(name, forKey: NAME)
                UserDefaults.standard.set(bio, forKey: BIO)
                UserDefaults.standard.set(gender, forKey: GENDER)
                UserDefaults.standard.set(dob, forKey: DATE_OF_BIRTH)
                UserDefaults.standard.set(self.swipeImageUrls, forKey: SWIPE_IMAGE_URLS)
                ProgressHUD.showSuccess("Your profile has been updated successfully!")
                self.dismissIndicatorView()
                self.dismiss(animated: true)
            }
           return
       }
   }
    
    private func uplodadData(){
         self.showIndicatorView()
         guard let name = self.nameTextField.text, let bio = self.bioTextField.text, let gender = genderTextField.text, let dob = dobTextField.text, let currentUserId = Auth.auth().currentUser?.uid else {return}
         let data = ["name": name, "bio": bio, "gender": gender, "dateOfBirth": dob] as [String: Any]
         USER_REF.document(currentUserId).updateData(data) { (error) in
             if let _ = error{
                 self.dismissIndicatorView()
                 return
             }
             UserDefaults.standard.set(name, forKey: NAME)
             UserDefaults.standard.set(bio, forKey: BIO)
             UserDefaults.standard.set(gender, forKey: GENDER)
             UserDefaults.standard.set(dob, forKey: DATE_OF_BIRTH)
             ProgressHUD.showSuccess("Your profile has been updated successfully!")
             self.dismissIndicatorView()
             self.dismiss(animated: true)
         }
        
    }
    
    
//    MARK: - UITextFieldDelegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        dobTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField || textField == bioTextField || textField == genderTextField || textField == dobTextField{
            addKeyboardObservers()
        }else{
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
    
//    MARK: - UIPicker Delegate and DatsSource
    
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
    
//    MARK: - ImagePicker Delegate and DataSource
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        setHeaderImage(selectedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func setHeaderImage(_ image: UIImage?){
        guard let image = image else {return}
        buttons[imageIndex].setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        if imageIndex == 0{
            self.isFirstImageSelected = true
            self.imageCount += 1
            //self.selectedImages.append(image)
            self.selectedImages.insert(image, at: 0)
        }else if imageIndex == 1{
            self.isSecondImageSelected = true
            self.imageCount += 1
            //self.selectedImages.append(image)
            self.selectedImages.insert(image, at: 1)
        }else{
            self.isThirdImageSelected = true
            self.imageCount += 1
            //self.selectedImages.append(image)
            self.selectedImages.insert(image, at: 2)
        }
    }
    
}
