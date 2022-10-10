//
//  StoryVC.swift
//  Flytant
//
//  Created by Vivek Rai on 19/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import VHProgressBar
import GravitySliderFlowLayout
import ImageSlideshow

class StoryVC: UIViewController, ImageSlideshowDelegate{
    
//    MARK: - Properties
    
    let imagesArray = ["https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/post_images%2FBCF7C967-05E3-4D27-BB6B-72946382B320%2FjxxoED4ZCoTp7S7aCzTqMkk1QBw2063F5091-3AC7-44C7-BEB5-5548862D38CA?alt=media&token=2862bf78-ca1f-4c4e-b6a9-3c6724961f94", "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/post_images%2FF9A2F59E-D097-4AFC-8679-FA8E2EC30EAA%2FcsafugFIHKeSzVNtf1NTtKQ8TBE2603E3878-DD05-445F-BD27-50A363FA5F88?alt=media&token=9e401fae-8fc3-496a-9809-71cd7c895560", "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/post_images%2F5C8B9380-A62D-48BD-8179-E69605CC9276%2FcsafugFIHKeSzVNtf1NTtKQ8TBE29D8795E1-AFA4-40F0-8497-D6D37161F83B?alt=media&token=ebfd436f-3fef-4ae1-a775-6910208c0abb", "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/post_images%2F1EB6971C-2A8D-4FC1-B65A-E2853E1BB1BE%2FDXSyCujifffmRKyRZnzJE3H5Git2CE89A397-E23C-418B-B4AB-B0A62304F7E8?alt=media&token=337ee689-7940-46a7-8e55-a4ada09c15e1"]
    var timer = Timer()
    var currentCount = 0
    var sliderImages = [InputSource]()
    
//    MARK: - Views
    
    let horizontalProgress = HorizontalProgressBar()
    let dismissButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 14))
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 24, image: UIImage(named: "avatarPlaceholder")!)
    let usernameLabel = FLabel(backgroundColor: UIColor.clear, text: "vivekrai", font: UIFont.boldSystemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.white)
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "3 HOURS AGO", font: UIFont.systemFont(ofSize: 10), textAlignment: .left, textColor: UIColor.white)
    let slideShow: ImageSlideshow = {
        let slideShow = ImageSlideshow()
        slideShow.backgroundColor = UIColor.clear
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        slideShow.contentMode = .center
        slideShow.zoomEnabled = true
        slideShow.slideshowInterval = 5
        slideShow.activityIndicator = DefaultActivityIndicator(style: .medium, color: UIColor(red: 250/255, green: 0, blue: 102/255, alpha: 1))
        return slideShow
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        configureViews()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            self.updateProgress()
        })
        
        setStoryData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

//    MARK: - ConfigureViews
    
    private func configureViews(){
        
        view.addSubview(slideShow)
        slideShow.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        slideShow.delegate = self
        
        view.addSubview(horizontalProgress)
        horizontalProgress.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        horizontalProgress.pgHeight = 4
        horizontalProgress.pgWidth = view.frame.width-16
        horizontalProgress.barColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        horizontalProgress.frameColor = UIColor.clear
        horizontalProgress.backgroundColor = UIColor.white
        horizontalProgress.layer.borderColor = UIColor.clear.cgColor
        horizontalProgress.animateProgress(duration: 6.0, progressValue: 1)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: horizontalProgress.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 40, height: 40)
        dismissButton.setImage(UIImage(named: "crossIcon"), for: .normal)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)

        view.addSubview(profileImageView)
        profileImageView.anchor(top: horizontalProgress.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)

        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)

        view.addSubview(timeLabel)
        timeLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 16)
        
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
    
    private func updateProgress(){
        horizontalProgress.stopAnimation()
        currentCount += 1
        horizontalProgress.animateProgress(duration: 5.0, progressValue: 1)
        if currentCount == imagesArray.count{
            handleDismiss()
        }
    }
    
    private func setStoryData(){
        imagesArray.forEach { (image) in
            sliderImages.append(AlamofireSource(urlString: image)!)
        }
        slideShow.setImageInputs(sliderImages)
    }
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        currentCount = page
        horizontalProgress.stopAnimation()
        horizontalProgress.animateProgress(duration: 5.0, progressValue: 1)
        
    }
    
    func imageSlideshowDidEndDecelerating(_ imageSlideshow: ImageSlideshow) {
        horizontalProgress.stopAnimation()
        timer.invalidate()
    }
}
