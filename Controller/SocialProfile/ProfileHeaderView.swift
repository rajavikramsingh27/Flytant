////
////  ProfileHeaderView.swift
////  Flytant
////
////  Created by Flytant on 23/09/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//enum SocialAccount {
//    case instagram
//    case youtube
//    case twitter
//}
//
//
//protocol ProfileHeaderViewDelegate: AnyObject {
//    func socialAccountSelected(account: SocialAccount)
//    func editProfile()
//}
//
//class ProfileHeaderView: UIView {
//
//    @IBOutlet var contentView: UIView!
//
//    /// The default height of profile view is 369 with collection view height 40
//    /// and label with number of lines 1. 21.5
//    @IBOutlet weak var profileView: UIView!
//    @IBOutlet weak var profileImageView: RoundImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var locationAndAgeLabel: UILabel!
//    @IBOutlet weak var categoryCollectionView: UICollectionView!
//    @IBOutlet weak var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bioLabel: UILabel!
//    @IBOutlet weak var editProfileButton: UIButton!
//    @IBOutlet weak var socialScoreLabel: RoundLabel!
//    @IBOutlet weak var socialScoreHeading: UILabel!
//    @IBOutlet weak var locationImageView: UIImageView!
//    @IBOutlet weak var locationLine: UILabel!
//
//    /// The default height of social account view is 45
//    @IBOutlet weak var socialAccountView: UIView!
//    @IBOutlet weak var instagramView: UIView!
//    @IBOutlet weak var youtubeView: UIView!
//    @IBOutlet weak var twitterView: UIView!
//    @IBOutlet weak var instagramLabel: UILabel!
//    @IBOutlet weak var youtubeLabel: UILabel!
//    @IBOutlet weak var twitterLabel: UILabel!
//    @IBOutlet weak var instagramButton: UIButton!
//    @IBOutlet weak var youtubeButton: UIButton!
//    @IBOutlet weak var twitterButton: UIButton!
//    @IBOutlet weak var accountsLine: UIView!
//    @IBOutlet weak var selectedAccountView: UIView!
//
//    /// The default height of engagement view is 130
//    @IBOutlet weak var engagementView: UIView!
//    @IBOutlet weak var followersLabel: RoundLabel!
//    @IBOutlet weak var followersHeading: UILabel!
//    @IBOutlet weak var followingLabel: RoundLabel!
//    @IBOutlet weak var followingHeading: UILabel!
//    @IBOutlet weak var likePostLabel: RoundLabel!
//    @IBOutlet weak var likePostHeading: UILabel!
//    @IBOutlet weak var engagementLabel: RoundLabel!
//    @IBOutlet weak var engagementHeading: UILabel!
//
//    var selectedSocialAccount: SocialAccount = .instagram
//    private let identifier: String = "categoryCell"
//    weak var delegate: ProfileHeaderViewDelegate?
//    var categories: [String] = [] {
//        didSet { reloadCollectionView() }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//
//        profileView.layer.cornerRadius = 10
//        profileView.layer.borderWidth = 1
//        profileView.layer.borderColor = UIColor.black.cgColor
//        profileView.layer.masksToBounds = true
//
//        editProfileButton.layer.cornerRadius = 20
//        editProfileButton.layer.borderWidth = 1
//        editProfileButton.layer.borderColor = UIColor.black.cgColor
//        editProfileButton.layer.masksToBounds = true
//
//        socialScoreLabel.layer.borderWidth = 1
//        socialScoreLabel.layer.borderColor = UIColor.black.cgColor
//
//        followersLabel.layer.borderWidth = 1
//        followersLabel.layer.borderColor = UIColor.black.cgColor
//
//        followingLabel.layer.borderWidth = 1
//        followingLabel.layer.borderColor = UIColor.black.cgColor
//
//        likePostLabel.layer.borderWidth = 1
//        likePostLabel.layer.borderColor = UIColor.black.cgColor
//
//        engagementLabel.layer.borderWidth = 1
//        engagementLabel.layer.borderColor = UIColor.black.cgColor
//    }
//
//    private func reloadCollectionView() {
//        if categories.isEmpty {
//            categoryCollectionViewHeightConstraint.constant = 0
//        } else {
//            categoryCollectionViewHeightConstraint.constant = 40
//            categoryCollectionView.register(UINib(nibName: "ProfileCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: identifier)
//            categoryCollectionView.delegate = self
//            categoryCollectionView.dataSource = self
//            categoryCollectionView.reloadData()
//        }
//    }
//
//    func changeEditProfileTitle(for profile: Profile) {
//        if profile == .user {
//            editProfileButton.setTitle("Edit profile", for: .normal)
//        } else {
//            editProfileButton.setTitle("Message", for: .normal)
//        }
//    }
//
//    func changeEngagement(for account: SocialAccount) {
//        switch account {
//        case .instagram:
//            followersHeading.text = "Followers"
//            followingHeading.text = "Following"
//            likePostHeading.text = "Likes/Posts"
//            engagementHeading.text = "Engagement"
//        case .youtube:
//            followersHeading.text = "Subscribers"
//            followingHeading.text = "Views/Video"
//            likePostHeading.text = "Views"
//            engagementHeading.text = "Engagement"
//        case .twitter:
//            followersHeading.text = "Followers"
//            followingHeading.text = "Following"
//            likePostHeading.text = "Likes/Tweet"
//            engagementHeading.text = "Avg RT"
//        }
//
//    }
//
//    @IBAction func editProfileAction(_ sender: UIButton) {
//        delegate?.editProfile()
//    }
//
//
//
//    @IBAction func instagramSelected(_ sender: UIButton) {
//        selectedSocialAccount = .instagram
//        UIView.animate(withDuration: 0.3) {
//            self.selectedAccountView.frame = CGRect(x: self.instagramView.frame.origin.x, y: self.selectedAccountView.frame.minY, width: self.selectedAccountView.bounds.size.width, height: self.selectedAccountView.bounds.size.height)
//        }
//        changeEngagement(for: .instagram)
//        delegate?.socialAccountSelected(account: .instagram)
//    }
//
//    @IBAction func youtubeSelected(_ sender: UIButton) {
//        selectedSocialAccount = .youtube
//        UIView.animate(withDuration: 0.3) {
//            self.selectedAccountView.frame = CGRect(x: self.youtubeView.frame.origin.x, y: self.selectedAccountView.frame.minY, width: self.selectedAccountView.bounds.size.width, height: self.selectedAccountView.bounds.size.height)
//        }
//        changeEngagement(for: .youtube)
//        delegate?.socialAccountSelected(account: .youtube)
//    }
//
//    @IBAction func twitterSelected(_ sender: UIButton) {
//        selectedSocialAccount = .twitter
//        UIView.animate(withDuration: 0.3) {
//            self.selectedAccountView.frame = CGRect(x: self.twitterView.frame.origin.x, y: self.selectedAccountView.frame.minY, width: self.selectedAccountView.bounds.size.width, height: self.selectedAccountView.bounds.size.height)
//        }
//        changeEngagement(for: .twitter)
//        delegate?.socialAccountSelected(account: .twitter)
//    }
//
//}
//
//extension ProfileHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProfileCategoryCVCell else { return UICollectionViewCell() }
//        cell.categoryLabel.text = categories[indexPath.row]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: categories[indexPath.row].width(withConstraintHeight: 40, font: .systemFont(ofSize: 17, weight: .medium)) + 30, height: 40)
//    }
//
//}
