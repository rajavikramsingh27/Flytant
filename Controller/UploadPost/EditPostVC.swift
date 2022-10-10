//
//  EditPostVC.swift
//  Flytant
//
//  Created by Vivek Rai on 06/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage
import SwiftToast

class EditPostVC: UIViewController {

//    MARK: Properties
    var sliderImages = [InputSource]()
    var toast = SwiftToast()
    let categoryData = ["Fox news", "Entertainment", "Beauty", "Fashion", "Education"]
    var postId: String?
    
//    MARK: - Views
//    private let topImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "navBarImage")!)
    
    private let cancelButton = FButton(backgroundColor: UIColor.clear, title: "Cancel", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
    
    private let saveButton = FButton(backgroundColor: UIColor.clear, title: "Save", cornerRadius: 0, titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 18))
    
    private let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Edit Post", font: UIFont.boldSystemFont(ofSize: 18), textAlignment: .center, textColor: UIColor.white)
    
    private let slideShow = FImageSlideShow(backgroundColor: UIColor.secondarySystemBackground)
    
    private let categoryPicker = UIPickerView()
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    private let categoryTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Choose your post category")
    
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
//        configureTopViews()
        configureSlideShow()
        configureCategoryTextField()
        configureDescriptionTextView()
        configureCategoryPicker()
        
        addKeyboardObservers()
        
        fetchPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != descriptionTextView{
            view.endEditing(true)
        }
    }
   
    
//    MARKL - Configure Views
    
//    private func configureTopViews(){
//        view.addSubview(topImageView)
//        topImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
//        topImageView.contentMode = .scaleAspectFill
//        topImageView.isUserInteractionEnabled = true
//
//        topImageView.addSubview(saveButton)
//        saveButton.anchor(top: topImageView.topAnchor, left: nil, bottom: nil, right: topImageView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 30)
//        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
//        topImageView.addSubview(cancelButton)
//        cancelButton.anchor(top: topImageView.topAnchor, left: topImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 30)
//        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//
//        topImageView.addSubview(titleLabel)
//        titleLabel.anchor(top: topImageView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 30)
//        titleLabel.centerXAnchor.constraint(equalTo: topImageView.centerXAnchor).isActive = true
//    }
    
    private func configureSlideShow(){
        view.addSubview(slideShow)
        slideShow.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    private func configureCategoryTextField(){
        categoryTextField.inputView = categoryPicker
        view.addSubview(categoryTextField)
        categoryTextField.anchor(top: slideShow.bottomAnchor, left: view.leftAnchor
            , bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    private func configureDescriptionTextView(){
        descriptionTextView.delegate = self
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: categoryTextField.bottomAnchor, left: view.leftAnchor
            , bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 32, paddingRight: 16, width: 0, height: 100)
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
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        guard let postId = self.postId else {return}
        if let description = descriptionTextView.text{
            if let category = categoryTextField.text{
                let newData = ["category": category, "description":  description] as [String : Any]
                POST_REF.document(postId).updateData(newData) { (error) in
                    if let error = error{
                        self.toast = SwiftToast(text: "Error occured while updating. Error description \n \(error.localizedDescription)")
                        self.present(self.toast, animated: true)
                        return
                    }
                    self.toast = SwiftToast(text: "Successfully updated post.")
                    self.present(self.toast, animated: true)
                    self.dismiss(animated: true, completion: nil)
                    return
                    
                }
            }else{
                self.toast = SwiftToast(text: "Please choose a category for the post.")
                self.present(self.toast, animated: true)
            }
        }else{
            self.toast = SwiftToast(text: "Enter a new description for the post.")
            self.present(self.toast, animated: true)
        }
        
        
        
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
        categoryTextField.resignFirstResponder()
    }
    
    @objc private func didTap() {
      slideShow.presentFullScreenController(from: self)
    }
    
    private func fetchPost(){
        guard let postId = self.postId else {return}
        showIndicatorView()
        POST_REF.document(postId).getDocument { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let description = data["description"] as? String ?? ""
            let category = data["category"] as? String ?? ""
            let imageUrls = data["imageUrls"] as? [String] ?? [String]()
            
            self.descriptionTextView.text = description
            self.categoryTextField.text = category
            imageUrls.forEach { (url) in
                self.sliderImages.append(AlamofireSource(urlString: url)!)
            }
            self.slideShow.setImageInputs(self.sliderImages)
            self.dismissIndicatorView()
        }
    }
    
}

extension EditPostVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
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

extension EditPostVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addKeyboardObservers()
    }
    
    private func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

