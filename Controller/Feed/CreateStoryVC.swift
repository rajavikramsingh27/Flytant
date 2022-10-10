//
//  CreateStoryVC.swift
//  Flytant
//
//  Created by Vivek Rai on 21/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import FMPhotoPicker
import ImageSlideshow
import Firebase
import ProgressHUD

class CreateStoryVC: UIViewController, FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate, ImageSlideshowDelegate {
    
//    MARK: - Properties
    
    var config = FMPhotoPickerConfig()
    var storyImage: UIImage?
    
//    MARK: - Views
    
    let dismissButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 24))
    let slideShow: ImageSlideshow = {
        let slideShow = ImageSlideshow()
        slideShow.backgroundColor = UIColor.randomFlat()
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        slideShow.contentMode = .center
        slideShow.zoomEnabled = true
        slideShow.slideshowInterval = 5
        slideShow.activityIndicator = DefaultActivityIndicator(style: .medium, color: UIColor(red: 250/255, green: 0, blue: 102/255, alpha: 1))
        return slideShow
    }()
    
    let imagePickerButton =  FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 24))

    let shareButton =  FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 24))

    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openImagePicker()
        configureViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - CongfigureViews
    
    private func configureViews(){
    
        view.addSubview(slideShow)
        slideShow.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        slideShow.delegate = self
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        dismissButton.setImage(UIImage(named: "crossIcon"), for: .normal)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        view.addSubview(imagePickerButton)
        imagePickerButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 12, paddingRight: 0, width: 40, height: 40)
        imagePickerButton.setImage(UIImage(named: "imagePickerImage"), for: .normal)
        imagePickerButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 50, height: 50)
        shareButton.setImage(UIImage(named: "send"), for: .normal)
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
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
    
//    MARK: - Picker Delegate
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        picker.dismiss(animated: true) {
            self.storyImage = photos[0]
            self.slideShow.setImageInputs([
                ImageSource(image: photos[0])
            ])
        }
    }
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        editor.dismiss(animated: true) {
            self.storyImage = photo
            self.slideShow.setImageInputs([
                ImageSource(image: photo)
            ])
        }
    }
    
    @objc private func openImagePicker(){
        config.mediaTypes = [.image]
        config.selectMode = .single
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
//    MARK: - Handlers
    
    @objc private func handleDismiss(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
   		navigationController?.view.layer.add(transition, forKey: nil)
   		navigationController?.popViewController(animated: false)
    }
    
    @objc private func handleShare(){
        if let storyImage = storyImage{
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            showIndicatorView()
            self.shareButton.isUserInteractionEnabled = false
            guard let uploadData = storyImage.jpegData(compressionQuality: 0.5) else { return }
            let filename = NSUUID().uuidString
            STORAGE_REF_STORY.child(currentUserId).child(filename).putData(uploadData, metadata: nil) { (metaData, error) in
                if let _ = error{
                    self.shareButton.isUserInteractionEnabled = true
                    self.dismissIndicatorView()
                    ProgressHUD.showError("An Error occured while uploading. Please try again!")
                    return
                }
                
                STORAGE_REF_STORY.child(currentUserId).child(filename).downloadURL { (url, error) in
                    if let _ = error{
                        self.shareButton.isUserInteractionEnabled = true
                        self.dismissIndicatorView()
                        ProgressHUD.showError("An Error occured while uploading. Please try again!")
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else {return}
                    guard let username = UserDefaults.standard.string(forKey: USERNAME) else {return}
                    guard let profileImageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE_URL) else {return}
                    let creationDate = Int(NSDate().timeIntervalSince1970)
                    let seenBy = [String]()
                    let storyData = ["imageUrl": imageUrl, "userId": currentUserId, "creationDate": creationDate, "username": username, "profileImageUrl": profileImageUrl, "seenBy": seenBy, "storyType": "images"] as [String: Any]
                    
                    STORY_REF.document().setData(storyData, merge: true) { (error) in
                        if let _ = error{
                            self.shareButton.isUserInteractionEnabled = true
                            self.dismissIndicatorView()
                            ProgressHUD.showError("An Error occured while uploading. Please try again!")
                            return
                        }
                        
                        self.dismissIndicatorView()
                        ProgressHUD.showSuccess("Yout story has been uploaded successfully!")
                        self.shareButton.isUserInteractionEnabled = true
                        self.handleDismiss()
                    }
                }
            }
        }else{
            ProgressHUD.showError("Please select an image for uploading.")
        }
        
    }

}
