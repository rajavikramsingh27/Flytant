//
//  CampaignDetailViewController.swift
//  DynamicTableView
//

//

import UIKit
import Firebase
import ImageSlideshow

class CampaignDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Properties
    
    var sponsorship = Sponsorships(userId: "", price: 0, platforms: [String](), name: "", gender: "", minFollowers: 0, description: "", currency: "", creationDate: 0, influencers: [String](), categories: [String](), campaignId: "", isApproved: false, selectedUsers: [String](), blob: [Dictionary<String, String>]())
    
    
    var sliderImages = [InputSource]()
    
    var campaignPostedByMe : Bool = true
    
    let imageSlideShow = FImageSlideShow(backgroundColor: UIColor.lightGray)
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    let topView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        view.backgroundColor = .clear
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let bottomView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 360).isActive = true
        view.backgroundColor = .clear
        return view
    }()
    
    let newCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.darkGray
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    let bannerView = UIView()
    
    let CampaignLabel:UILabel = {
        let label = UILabel()
        label.text = "new camp for amazon"
        label.font = AppFont.font(type: .Bold, size: 18)
        return label
    }()
    
    let PostDateLabel:UILabel = {
        let label = UILabel()
        
        label.text = "Posted: Jan 26,2022"
        label.font = AppFont.font(type: .Medium, size: 12)
        return label
    }()
    
    let tagButton:UILabel = {
        let label = UILabel()
        
        label.text = "$400"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.label.cgColor
        label.font = AppFont.font(type: .Bold, size: 12)
        return label
    }()
    
    var categoriesCollectionView = FCollectionView()
    
    var messageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Message", for: .normal)
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.titleLabel?.font = AppFont.font(type: .Medium, size: 18)
        button.setTitleColor(.label, for: .normal)
        // button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
    var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 24
        
        button.titleLabel?.font = AppFont.font(type: .Bold, size: 18)
        button.setTitleColor(.systemBackground, for: .normal)
        // button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
    var viewInfluencerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.setTitle("View Influencers", for: .normal)
        button.layer.cornerRadius = 10
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemBackground, for: .normal)
       button.addTarget(self, action: #selector(openAppliedInfluencerVC), for: .touchUpInside)
        return button
    }()
    

    var heighCons2 = NSLayoutConstraint()
    
    let campDetailDescLabel = UILabel()
    
    var isViewMore:Bool = false
    
    var viewMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("...view more", for: .normal)
        button.backgroundColor = .clear
        
        button.titleLabel?.font = AppFont.font(type: .Medium, size: 14)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(viewMoreClicked), for: .touchUpInside)
        return button
    }()
    
    let categoriesLabel = UILabel()
    
    private func configureCategoriesCollectionView(){
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoreiesReuseIdentifier")
        bottomView.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, paddingTop: 30, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 35)
    }
    
    var genderTypeLabel = UILabel()
    var minFollowerLabel = UILabel()
    
    var SocialStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        return stackView
    }()
    
    var youtubeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()
    var facebookStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()
    var instaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()
    var twitterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()
    var linkedinStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserId = Auth.auth().currentUser!.uid
        
        guard let sponUserId = sponsorship.userId else {return}
         
        if sponUserId == currentUserId {
            campaignPostedByMe = true
        }
        else{
            campaignPostedByMe = false
        }
        
        
        
        guard let imageUrls = sponsorship.blob else {return}
        imageUrls.forEach { (url) in
            sliderImages.append(AlamofireSource(urlString: url["path"] ?? "")!)
        }
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(createNavBar(navTitle: "Campaigns", isBack: true))
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        setScrollView()
        setTopView()
        setMiddleView()
        setBottomView()
        
    }
    
    func setScrollView(){
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor,constant: getStatusBarHeight()+50).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    
    func setTopView(){
      
        bannerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 280)
        imageSlideShow.frame = bannerView.frame
        bannerView.addSubview(imageSlideShow)
        topView.addSubview(bannerView)
        imageSlideShow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        imageSlideShow.setImageInputs(sliderImages)
        
        //add title
        CampaignLabel.frame = CGRect(x: 20, y: 280, width: view.frame.width-20, height: 35)
        CampaignLabel.text = sponsorship.name
        
        //add posted date
        PostDateLabel.frame = CGRect(x: 20, y: 320, width: view.frame.width-20, height: 30)
        PostDateLabel.text =  "\(sponsorship.creationDate.timeAgoToDisplay())"
        
        
        // add tag
        tagButton.frame = CGRect(x: 20, y: 360, width: 80, height: 40)
        if sponsorship.price == 0{
            tagButton.text = "Barter"
            
        }else{
            if  let price =  sponsorship.price {
                
                tagButton.text = "$ " + "\(price)"
                
            }
        }
        
        messageButton.frame = CGRect(x: 20, y: 420, width: view.frame.width/2-30, height: 45)
        
        applyButton.frame = CGRect(x: view.frame.width/2, y: 420, width: view.frame.width/2-30, height: 45)
        
        viewInfluencerButton.frame = CGRect(x: 20, y: 420, width: view.frame.width-40, height: 50)
        
        topView.addSubview(CampaignLabel)
        topView.addSubview(PostDateLabel)
        topView.addSubview(tagButton)
        
        if campaignPostedByMe == true{
            
            topView.addSubview(viewInfluencerButton)
            
        }
        else{
            
            topView.addSubview(messageButton)
            topView.addSubview(applyButton)
            
        }
        
        scrollViewContainer.addArrangedSubview(topView)
        
    }
    
    func setMiddleView(){
        
        let courseDetailLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width-20, height: 30))
        courseDetailLabel.text =  "Description"
        courseDetailLabel.font = AppFont.font(type: .Bold, size: 16)
        middleView.addSubview(courseDetailLabel)
        
        campDetailDescLabel.frame = CGRect(x: 10, y: 50, width: view.frame.width-20, height: 30)
        campDetailDescLabel.text =  sponsorship.description
        campDetailDescLabel.translatesAutoresizingMaskIntoConstraints = false
        campDetailDescLabel.numberOfLines = 2
        campDetailDescLabel.font = AppFont.font(type: .Medium, size: 14)
        heighCons2 = middleView.heightAnchor.constraint(equalToConstant: 120)
        heighCons2.isActive = true
        middleView.addSubview(campDetailDescLabel)
        
        viewMoreButton.frame = CGRect(x: view.frame.width-100, y: 100, width: 80, height: 20)
        
        middleView.addSubview(viewMoreButton)
        viewMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollViewContainer.addArrangedSubview(middleView)
        
        NSLayoutConstraint.activate([
            campDetailDescLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            campDetailDescLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            campDetailDescLabel.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: 50),
            
        ])
        
        NSLayoutConstraint.activate([
            
            viewMoreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            viewMoreButton.topAnchor.constraint(equalTo: campDetailDescLabel.bottomAnchor, constant: -5),
            viewMoreButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        
    }
    
    
    @objc func viewMoreClicked(){
    
        heighCons2.isActive = false
        isViewMore = !isViewMore
        
        if isViewMore == false {
            viewMoreButton.setTitle("...view more", for: .normal)
            campDetailDescLabel.numberOfLines = 2
            heighCons2 = middleView.heightAnchor.constraint(equalToConstant: 120)
            heighCons2.isActive = true
            
        }
        else{
            viewMoreButton.setTitle("...view less", for: .normal)
            campDetailDescLabel.numberOfLines = 0
            heighCons2 = middleView.heightAnchor.constraint(equalToConstant: campDetailDescLabel.retrieveTextHeight()+80)
            heighCons2.isActive = true
        }
        
    }
    
    func setBottomView(){
        //80+80+80+80=320
        //categories
        configureCategoriesCollectionView()
        categoriesLabel.frame = CGRect(x: 10, y: 0, width: view.frame.width, height: 25)
        categoriesLabel.font = AppFont.font(type: .Bold, size: 16)
        categoriesLabel.text = "Categories"
        bottomView.addSubview(categoriesLabel)
        
        //gender
        let genderLabel = UILabel(frame: CGRect(x: 10, y: 80, width: view.frame.width, height: 20))
        genderLabel.font = AppFont.font(type: .Bold, size: 16)
        genderLabel.text = "Gender"
        bottomView.addSubview(genderLabel)
        
        genderTypeLabel.frame = CGRect(x: 10, y: 100, width: view.frame.width-20, height: 30)
        genderTypeLabel.text = sponsorship.gender
        genderTypeLabel.font = AppFont.font(type: .Medium, size: 12)
        bottomView.addSubview(genderTypeLabel)
        
        //minimumFollower
        
        let minimumFollowerLabel = UILabel(frame: CGRect(x: 10, y: 140, width: view.frame.width, height: 20))
        minimumFollowerLabel.font = AppFont.font(type: .Bold, size: 16)
        minimumFollowerLabel.text = "Minimum follower"
        bottomView.addSubview(minimumFollowerLabel)
        
        minFollowerLabel.frame = CGRect(x: 10, y: 160, width: view.frame.width-20, height: 30)
        minFollowerLabel.text = formatPoints(from: sponsorship.minFollowers)
        minFollowerLabel.font = AppFont.font(type: .Medium, size: 12)
        bottomView.addSubview(minFollowerLabel)
        
        
        //platform
        
        let platformLabel = UILabel(frame: CGRect(x: 10, y: 200, width: view.frame.width, height: 20))
        platformLabel.font = AppFont.font(type: .Bold, size: 16)
        platformLabel.text = "Platform"
        bottomView.addSubview(platformLabel)
        scrollViewContainer.addArrangedSubview(bottomView)
        socialPlatform(sponsorship.platforms)
        
    }
    
    func socialPlatform(_ platform : [String]){
        
        let width : CGFloat = 48.0
        
        
        SocialStackView.frame = CGRect(x: 10, y: 230, width: CGFloat(width*CGFloat(platform.count)), height: 50)
        bottomView.addSubview(SocialStackView)
        
        let youtubeLabel = UILabel()
        youtubeLabel.text = "Youtube"
        youtubeLabel.subHeaderLabel()
        let youtubeImage = UIImageView()
        youtubeImage.contentMode = .scaleAspectFit
        youtubeImage.tintColor = .label
        youtubeImage.image = UIImage(named: "youtube")
        
        youtubeStackView.addArrangedSubview(youtubeImage)
        youtubeStackView.addArrangedSubview(youtubeLabel)
        
        let facebookLabel = UILabel()
        facebookLabel.text = "Facebook"
        facebookLabel.subHeaderLabel()
        let facebookImage = UIImageView()
        facebookImage.tintColor = .label
        facebookImage.contentMode = .scaleAspectFit
        facebookImage.image = #imageLiteral(resourceName: "facebook")
        
        facebookStackView.addArrangedSubview(facebookImage)
        facebookStackView.addArrangedSubview(facebookLabel)
        
        let instaLabel = UILabel()
        instaLabel.text = "Instagram"
        instaLabel.subHeaderLabel()
        let instaImage = UIImageView()
        instaImage.tintColor = .label
        instaImage.contentMode = .scaleAspectFit
        instaImage.image = UIImage(named: "insta")
        
        instaStackView.addArrangedSubview(instaImage)
        instaStackView.addArrangedSubview(instaLabel)
        
        let twitterLabel = UILabel()
        twitterLabel.text = "Twitter"
        twitterLabel.subHeaderLabel()
        let twitterImage = UIImageView()
        twitterImage.tintColor = .label
        twitterImage.contentMode = .scaleAspectFit
        twitterImage.image = #imageLiteral(resourceName: "twitter")
        
        twitterStackView.addArrangedSubview(twitterImage)
        twitterStackView.addArrangedSubview(twitterLabel)
        
        let linkedinLabel = UILabel()
        linkedinLabel.text = "Linkedin"
        linkedinLabel.subHeaderLabel()
        let linkedinImage = UIImageView()
        linkedinImage.tintColor = .label
        linkedinImage.contentMode = .scaleAspectFit
        
        linkedinImage.image = #imageLiteral(resourceName: "linkedin")
        
        linkedinStackView.addArrangedSubview(linkedinImage)
        linkedinStackView.addArrangedSubview(linkedinLabel)
        
        if sponsorship.platforms.contains("Youtube") {
            SocialStackView.addArrangedSubview(youtubeStackView)
        }
        if sponsorship.platforms.contains("Facebook") {
            SocialStackView.addArrangedSubview(facebookStackView)
        }
        if sponsorship.platforms.contains("Instagram") {
            SocialStackView.addArrangedSubview(instaStackView)
        }
        
        if sponsorship.platforms.contains("Twitter") {
            SocialStackView.addArrangedSubview(twitterStackView)
        }
        if sponsorship.platforms.contains("Linkedin") {
            SocialStackView.addArrangedSubview(linkedinStackView)
        }
        
    }
    
    //    MARK: - Handlers
    
    @objc private func didTap(){
        imageSlideShow.presentFullScreenController(from: self)
    }
    
    @objc  func openAppliedInfluencerVC(){
        
        let detailsVC  = AppliedInfluencerViewController()
        detailsVC.modalPresentationStyle = .fullScreen
        detailsVC.appliedInfluencerId = sponsorship.influencers
        detailsVC.campaignId = sponsorship.campaignId
        present(detailsVC, animated: false)
        
    }
    
    //    MARK: - CollectionView Dlelegate and Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView{
            return sponsorship.categories.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoreiesReuseIdentifier", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryButton.setTitle(sponsorship.categories[indexPath.row], for: .normal)
        return cell
        
    }
}

extension CampaignDetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = sponsorship.categories[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width+22, height: 35)
    }
    
}
