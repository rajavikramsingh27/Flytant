//
//  MyCampaignVC.swift
//  Flytant
//
//  Created by Vivek Rai on 22/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "myCampaignCollectionViewCell"

class MyCampaignVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    
    var sponsorships = [Sponsorships]()
    
//    MARK: - Views
    
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
        fetchSponsorshipData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "My Campaigns"

    }
    
    private func configureCollectionView(){
        self.collectionView.register(MyCampaignCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
    
    
        
//    MARK: - CollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

//    MARK: - CollectionView Delegates and DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorships.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCampaignCollectionViewCell
        if !sponsorships.isEmpty{
            cell.sponsorships = self.sponsorships[indexPath.row]
        }
        return cell
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appliedVC = AppliedVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        appliedVC.influencers = sponsorships[indexPath.row].influencers
        navigationController?.pushViewController(appliedVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 280)
    }

//    MARK: - API
    
    private func fetchSponsorshipData(){
        sponsorships.removeAll()
        showIndicatorView()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        SPONSORSHIP_REF.whereField("userId", isEqualTo: currentUserId).order(by: "creationDate", descending: true).getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            for document in snapshot.documents{
                let data = document.data()
                let userId = data["userId"] as? String ?? ""
                let price = data["price"] as? Int ?? 0
                let platforms = data["platforms"] as? [String] ?? [String]()
                let name = data["name"] as? String ?? ""
                let minFollowers = data["minFollowers"] as? Int ?? 0
                let gender = data["gender"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let currency = data["currency"] as? String ?? ""
                let creationDate = data["creationDate"] as? Double ?? 0
                let influencers = data["influencers"] as? [String] ?? [String]()
                let categories = data["categories"] as? [String] ?? [String]()
                let campaignId = data["campaignId"] as? String ?? ""
                let isApproved = data["isApproved"] as? Bool ?? false
                let selectedUser = data["selectedUsers"] as? [String] ?? [String]()
                let blob = data["blob"] as? [Dictionary<String, String>] ?? [Dictionary<String, String>]()
                let sponsorship = Sponsorships(userId: userId, price: price, platforms: platforms, name: name, gender: gender, minFollowers: minFollowers, description: description, currency: currency, creationDate: creationDate, influencers: influencers, categories: categories, campaignId: campaignId, isApproved: isApproved, selectedUsers: selectedUser, blob: blob)
                self.sponsorships.append(sponsorship)
            }
            
            self.collectionView.reloadData()
            self.dismissIndicatorView()
        }
    }

}
