//
//  UploadPostVC.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import YPImagePicker
import AVKit
import Photos
import SwiftToast
import Firebase


private let reuseIdentifier = "imageCollectionViewCell"

class UploadPostVC: UIViewController {
    
//    MARK: - Variables
    var toast = SwiftToast()
    //let locationPicker = LocationPicker()
    var selectedItems = [YPMediaItem]()
    var selectedImages = [UIImage]()
    var selectedImageUrls = [String]()
    var categoryData = [String]()
    var index = 0
    var postData = [String: Any]()
    var isGalleryOpen = false
//    MARK: - Views

    private let postButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 12))
    
    private let categoryPicker = UIPickerView()
    
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    private var imageCollectionView = FCollectionView()
    
    private let categoryTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Choose your post category")
    
    private let locationTextField = FTextField(backgroundColor: UIColor.clear, borderStyle: .roundedRect, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "Choose your location")
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.label
        tv.backgroundColor = UIColor.secondarySystemBackground
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        return tv
    }()
    
    private let placeholderLabel = FLabel(backgroundColor: UIColor.clear, text: "What's new?", font: UIFont.systemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.systemGray)
    
    private var textViewInputAccessoryView = UIView()
    
    private let pickButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
   
    private let locationButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 14))
    
    private let previewButton = FButton(backgroundColor: UIColor.clear, title: "Preview", cornerRadius: 0, titleColor: UIColor.systemRed, font: UIFont.boldSystemFont(ofSize: 14))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        categoryData = RemoteConfigManager.getExploreCategoryData(for: "explore_category")[0]
        
        configureNavigationBar()
        configureDescriptionTextView()
        configureTextViewInputAccessoryView()
        configurePickButton()
        configureLocationButton()
        configurePreviewButton()
        configureCategoryTextField()
        configureCategoryPicker()
        configureLocationTextField()
        configureImageCollectionView()
        
        if isGalleryOpen{
            showPicker()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != descriptionTextView{
            view.endEditing(true)
        }
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.purple
//        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Post", font: UIFont.boldSystemFont(ofSize: 20), textAlignment: .center, textColor: .white)
        navigationItem.titleView = titleLabel

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "uploadPost"), style: .done, target: self, action: #selector(handlePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "crossIcon"), style: .done, target: self, action: #selector(handleDiscard))

    }
    
    private func configureImageCollectionView(){
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(UploadPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        imageCollectionView.layer.shadowColor = UIColor.label.cgColor
        imageCollectionView.layer.shadowOpacity = 1
        imageCollectionView.layer.shadowOffset = .zero
        imageCollectionView.layer.shadowRadius = 3
        imageCollectionView.layer.cornerRadius = 10
        view.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 80)
    }
    
    private func configureCategoryTextField(){
        categoryTextField.inputView = categoryPicker
        view.addSubview(categoryTextField)
        categoryTextField.anchor(top: descriptionTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
    }
    
    private func configureLocationTextField(){
        locationTextField.inputView = UIView()
        view.addSubview(locationTextField)
        locationTextField.anchor(top: categoryTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        locationTextField.addTarget(self, action: #selector(handleLocationPicker), for: .touchDown)
        locationTextField.isHidden = true
    }
    
    private func configureDescriptionTextView(){
        descriptionTextView.delegate = self
        descriptionTextView.becomeFirstResponder()
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 200)
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: descriptionTextView.topAnchor, left: descriptionTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 100, height: 18)
    }
    
    private func configureTextViewInputAccessoryView(){
        textViewInputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 48))
        textViewInputAccessoryView.backgroundColor = UIColor.systemBackground
        descriptionTextView.inputAccessoryView = textViewInputAccessoryView
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.secondaryLabel
        textViewInputAccessoryView.addSubview(separatorView)
        separatorView.anchor(top: textViewInputAccessoryView.topAnchor, left: textViewInputAccessoryView.leftAnchor, bottom: nil, right: textViewInputAccessoryView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
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
    
    private func configurePickButton(){
        textViewInputAccessoryView.addSubview(pickButton)
        pickButton.anchor(top: textViewInputAccessoryView.topAnchor, left: textViewInputAccessoryView.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        pickButton.setImage(UIImage(named: "pickImagesIcon"), for: .normal)
        pickButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    }
    
    private func configureLocationButton(){
        textViewInputAccessoryView.addSubview(locationButton)
        locationButton.anchor(top: textViewInputAccessoryView.topAnchor, left: pickButton.rightAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        locationButton.setImage(UIImage(named: "locationIcon"), for: .normal)
        locationButton.addTarget(self, action: #selector(handleLocationPicker), for: .touchUpInside)
        locationButton.isHidden = true
    }
    
    private func configurePreviewButton(){
        textViewInputAccessoryView.addSubview(previewButton)
        previewButton.anchor(top: textViewInputAccessoryView.topAnchor, left: nil, bottom: textViewInputAccessoryView.bottomAnchor, right: textViewInputAccessoryView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 16, width: 60, height: 0)
        previewButton.addTarget(self, action: #selector(handlePreview), for: .touchUpInside)
    }
    
    private func configurePostButton(){
        view.addSubview(postButton)
        postButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 80, height: 80)
        postButton.setImage(UIImage(named: "postImage"), for: .normal)
        postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
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
    
    private func discardCurrentData(){
        self.postData.removeAll()
        self.selectedImages.removeAll()
        self.selectedItems.removeAll()
        self.selectedImageUrls.removeAll()
        self.imageCollectionView.reloadData()
        self.categoryTextField.text = ""
        self.locationTextField.text = ""
        self.descriptionTextView.text = ""
        self.index = 0
        self.imageCollectionView.reloadData()
        closeViewController()
    }
    
    private func closeViewController() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    @objc func handleDiscard(){
        let alertVC = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (action) in
            self.discardCurrentData()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func handlePreview(){
        if selectedImages.isEmpty{
            self.toast = SwiftToast(text: "No Images selected. Please add few images for preview.")
            self.present(self.toast, animated: true)
        }else{
            let previewVC = PreviewVC()
            previewVC.selectedImages = selectedImages
            previewVC.postDescription = descriptionTextView.text
            let presentVC = UINavigationController(rootViewController: previewVC)
            navigationController?.present(presentVC, animated: true)
        }
        
    }
    
    @objc func handleLocationPicker(){
//        locationTextField.isHidden = false
//        locationPicker.pickCompletion = { (pickedLocationItem) in
//            self.locationTextField.text = pickedLocationItem.name
//        }
//        locationPicker.addBarButtons()
//        let navigationController = UINavigationController(rootViewController: locationPicker)
//        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func handlePost(){
        if !selectedImages.isEmpty{
            if !categoryTextField.text!.isEmpty{
                if !descriptionTextView.text.isEmpty{
                    let alertVC = UIAlertController(title: nil, message: "Do you want to upload this post?", preferredStyle: .actionSheet)
                    alertVC.addAction(UIAlertAction(title: "Upload", style: .default, handler: { (action) in
                        self.uploadPost(forIndex: self.index)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    present(alertVC, animated: true, completion: nil)
                }else{
                    self.toast = SwiftToast(text: "Please add your post description.")
                    self.present(self.toast, animated: true)
                    return
                }
            }else{
                self.toast = SwiftToast(text: "Please choose your post category.")
                self.present(self.toast, animated: true)
                return
            }
        }else{
            self.toast = SwiftToast(text: "No Images selected! Please pick some images before uploading.")
            self.present(self.toast, animated: true)
            return
        }
       
    }
    
    @objc func donePicker(){
        categoryTextField.resignFirstResponder()
    }
    
    @objc func showResults() {
        if selectedItems.count > 0 {
            let gallery = YPSelectionsGalleryVC(items: selectedItems) { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
            let navC = UINavigationController(rootViewController: gallery)
            self.present(navC, animated: true, completion: nil)
        } else {
            print("No items selected yet.")
        }
    }
    
    // MARK: - Configuration
        @objc func showPicker() {
            selectedImages.removeAll()
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.wordings.libraryTitle = "Gallery"
            config.hidesStatusBar = true
            config.hidesBottomBar = true
            config.library.maxNumberOfItems = 5
            config.gallery.hidesRemoveButton = false
            config.library.preselectedItems = selectedItems
        
            let picker = YPImagePicker(configuration: config)

        /* Multiple media implementation */
            picker.didFinishPicking { [unowned picker] items, cancelled in
                
                if cancelled {
                    print("Picker was canceled")
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                _ = items.map { print("🧀 \($0)") }
                
                self.selectedItems = items
                for item in items{
                    switch item {
                        case .photo(p: let photo):
                            self.selectedImages.append(photo.image)
                        default:
                            print("Default statement")
                    }
                    picker.dismiss(animated: true) {
                        self.imageCollectionView.reloadData()
                    }
                }
            }
            
            //  Configure Picker NavBar
//            picker.navigationBar.barTintColor = UIColor.purple
//            picker.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
            picker.navigationBar.setGradientBackground(colors: [UIColor(red:16/255, green:143/255, blue:181/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1), UIColor(red:72/255, green:22/255, blue: 124/255, alpha:1)], startPoint: .topLeft, endPoint: .topRight)
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            picker.navigationBar.titleTextAttributes = textAttributes
            picker.navigationBar.tintColor = UIColor.white
            let titleLabel = FLabel(backgroundColor: UIColor.clear, text: "Gallert", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center, textColor: .white)
            picker.navigationItem.titleView = titleLabel
            present(picker, animated: true, completion: nil)
    }
}


extension UploadPostVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UploadPostCollectionViewCell
        if !selectedImages.isEmpty{
            cell.imageView.image = selectedImages[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showResults()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: self.imageCollectionView.bounds.height)
    }

}

extension UploadPostVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
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

extension UploadPostVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            placeholderLabel.isHidden = false
        }
        if textView.text.count > 0 {
            placeholderLabel.isHidden = true
        }
        if textView.text.count > 120{
            textView.font = UIFont.systemFont(ofSize: 16)
        }
        if textView.text.count > 240{
            textView.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    private func uploadImages(userDataUploadComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        self.showIndicatorView()
        guard let category = self.categoryTextField.text, let description = self.descriptionTextView.text, let userID = Auth.auth().currentUser?.uid, let username = UserDefaults.standard.string(forKey: USERNAME), let profileImageURL = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
        if profileImageURL.isEmpty{
            postData = ["category": category, "description": description, "likes": 0, "creationDate": creationDate, "userId": userID, "username": username, "postType": "images", "imageUrls": self.selectedImageUrls, "profileImageUrl": DEFAULT_PROFILE_IMAGE_URL] as [String : Any]
        }else{
            postData = ["category": category, "description": description, "likes": 0, "creationDate": creationDate, "userId": userID, "username": username, "postType": "images", "imageUrls": self.selectedImageUrls, "profileImageUrl": profileImageURL] as [String : Any]
        }
        
        let storagePostName = NSUUID().uuidString
        guard let uploadData = self.selectedImages[index].jpegData(compressionQuality: 0.4) else { return }
        let filename = NSUUID().uuidString
        STORAGE_REF_POST_IMAGES.child(storagePostName).child(userID+filename).putData(uploadData, metadata: nil) { (metaData, error) in

            if let error = error{
                self.dismissIndicatorView()
                self.toast = SwiftToast(text: "An error occured while uploading, Error description: \n\(error.localizedDescription)")
                self.present(self.toast, animated: true)
                userDataUploadComplete(false, error)
                return
            }
            STORAGE_REF_POST_IMAGES.child(storagePostName).child(userID+filename).downloadURL { (url, error) in
                if let error = error{
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "An error occured while uploading, Error description: \n\(error.localizedDescription)")
                    self.present(self.toast, animated: true)
                    userDataUploadComplete(false, error)
                    return
                }
                guard let imageUrl = url?.absoluteString else {return}
                self.selectedImageUrls.append(imageUrl)
                self.postData["imageUrls"] = self.selectedImageUrls
                self.dismissIndicatorView()
                userDataUploadComplete(true, nil)
            }
        }
    }


    private func uploadPost(forIndex index: Int){
        postButton.isEnabled = false
        pickButton.isEnabled = false
        if self.index < selectedImages.count{
            //  call the completion block
            uploadImages() { (success, error) in
                if success{
                    self.index = self.index + 1
                    print(self.index)
                    self.uploadPost(forIndex: self.index)
                    print(self.selectedImageUrls)
                }else{
                    self.uploadPost(forIndex: self.index)
                }
            }
        }else{
            self.showIndicatorView()
            let postDocument = POST_REF.document()
            postDocument.setData(postData, merge: true) { (error) in
                if let error = error{
                    self.dismissIndicatorView()
                    self.toast = SwiftToast(text: "An error occured while uploading. Error description: \n \(error.localizedDescription)")
                    self.present(self.toast, animated: true)
                    self.postButton.isEnabled = true
                    self.pickButton.isEnabled = true
                    return
                }
                self.uploadHashtagToServer(withPostId: postDocument.documentID)
                self.dismissIndicatorView()
                self.discardCurrentData()
                self.toast = SwiftToast(text: "Your post has been uploaded successfully!")
                self.present(self.toast, animated: true)
                self.postButton.isEnabled = true
                self.pickButton.isEnabled = true
            }
            return
        }
    }
    
    private func uploadHashtagToServer(withPostId postId: String) {
        guard let caption = descriptionTextView.text else { return }
        let words: [String] = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                let hashtagValues = [postId: "postId"]
                HASHTAG_POST_REF.document(word).setData(hashtagValues, merge: true)
            }
        }
    }
}
