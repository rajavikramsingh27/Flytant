//
//  EditShopPostVC.swift
//  Flytant
//
//  Created by Vivek Rai on 01/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow
import Firebase
import SwiftToast

class EditShopPostVC: UIViewController {
    
//    MARK: - Properties
    var sliderImages = [InputSource]()
    var toast = SwiftToast()
    let categoryData = ["Fox news", "Entertainment", "Beauty", "Fashion", "Education"]
    var postId: String?
    var category: String?
    var imageUrls: [String]?
    var buttonTitle: String?
    var postDescription: String?
    var websiteLink: String?
    
//    MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let slideShow = FImageSlideShow(backgroundColor: UIColor.secondarySystemBackground)
    
    private let categoryPicker = UIPickerView()
    
    private let categoryTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "")
    
    private let customButtonTitleTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "")
    
    private let websiteTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "")
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = UIColor.label
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        
        configureViews()
        configureCategoryPicker()
        
        addKeyboardObservers()
        
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != descriptionTextView{
            view.endEditing(true)
        }
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Edit Shop Post"
        
        let rightBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = leftBarButton
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
    
    private func configureViews(){
        contentView.addSubview(slideShow)
        slideShow.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        
        contentView.addSubview(categoryTextField)
        categoryTextField.anchor(top: slideShow.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        categoryTextField.delegate = self
        categoryTextField.inputView = categoryPicker
        
        contentView.addSubview(websiteTextField)
        websiteTextField.anchor(top: categoryTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        websiteTextField.delegate = self
        
        contentView.addSubview(customButtonTitleTextField)
        customButtonTitleTextField.anchor(top: websiteTextField.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        customButtonTitleTextField.delegate = self
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: customButtonTitleTextField.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 32, paddingRight: 16, width: 0, height: 120)
        descriptionTextView.delegate = self
        
    }
    
    private func configureCategoryPicker(){
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
               
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemRed
        toolBar.sizeToFit()
               
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    
//    MARK: - Handlers
    
    @objc func donePicker(){
        categoryTextField.resignFirstResponder()
    }
    
    @objc func handleSave(){
        guard let shopPostId = self.postId else {return}
        if let descriptionText = self.descriptionTextView.text{
            if let category = categoryTextField.text{
                if let websiteLink = self.websiteTextField.text{
                    if let customButtonTitle = customButtonTitleTextField.text{
                        let newData = ["buttonTitle": customButtonTitle, "productWebsite": websiteLink, "category": category, "description": descriptionText]
                        SHOP_POST_REF.document(shopPostId).updateData(newData) { (error) in
                            if let _ = error{
                                self.toast = SwiftToast(text: "An error occured while updating. Please try again!")
                                self.present(self.toast, animated: true)
                            }
                            self.toast = SwiftToast(text: "Successfully updated your product details.")
                            self.present(self.toast, animated: true)
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                    }else{
                        self.toast = SwiftToast(text: "Please enter a button Title for the product.")
                        self.present(self.toast, animated: true)
                    }
                }else{
                    self.toast = SwiftToast(text: "Please enter a website link of the product.")
                    self.present(self.toast, animated: true)
                }
            }else{
                self.toast = SwiftToast(text: "Please choose a category of the product.")
                self.present(self.toast, animated: true)
            }
            
        }else{
            self.toast = SwiftToast(text: "Enter a new description of the product.")
            self.present(self.toast, animated: true)
        }
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true)
    }
    
    private func setData(){
        guard let imageUrls = self.imageUrls else {return}
        imageUrls.forEach { (url) in
            self.sliderImages.append(AlamofireSource(urlString: url)!)
        }
        self.slideShow.setImageInputs(self.sliderImages)
        
        guard let postDescription = self.postDescription else {return}
        self.descriptionTextView.text = postDescription
        
        guard let buttonTitle = self.buttonTitle else {return}
        self.customButtonTitleTextField.text = buttonTitle
        
        guard let websiteLink = self.websiteLink else {return}
        self.websiteTextField.text = websiteLink
        
        guard let category = self.category else {return}
        self.categoryTextField.text = category
    }

}

extension EditShopPostVC: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObservers()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        websiteTextField.resignFirstResponder()
        customButtonTitleTextField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addKeyboardObservers()
    }
    
    private func addKeyboardObservers(){
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
}


extension EditShopPostVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker{
            return categoryData.count
        }else{
            return 0
        }
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker{
            categoryTextField.text = categoryData[row]
        }
    }
}
