//
//  SponsorshipVC.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import DropDown

private let reuseIdentifier = "sponsorshipColelctionViewReuseIdentifier"
private let reuseIdentifierForApplied = "AppliedsponsorshipColelctionViewReuseIdentifier"

class SponsorshipVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK: - Properties
    
    var sponsorships = [Sponsorships]()
    var isApplied : Bool = false
    var filterData = ["Price", "Gender"]
    var sortData = ["Newest", "Oldest", "Most Applied","Least Applied","Highest Payment", "Lowest Payment"]
    
//    MARK: - Views
    let filterDropDown = DropDown()
    let sortDropDown = DropDown()
    let navigationTitleView = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 24)!, textAlignment: .left, textColor: UIColor.label)
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()

    let filterImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "filterIcon")!)
    let filterButton = FButton(backgroundColor: UIColor.clear, title: "Filter", cornerRadius: 0, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 16)!)
    
    let sortImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "sortIcon")!)
    let sortButton = FButton(backgroundColor: UIColor.clear, title: "Sort", cornerRadius: 0, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 16)!)
    
    let campaignImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "myCampaignIcon")!)
    let campaignButton = FButton(backgroundColor: UIColor.clear, title: "My Campaign", cornerRadius: 0, titleColor: UIColor.label, font: UIFont(name: "RoundedMplus1c-Medium", size: 16)!)
    
    let infoLabel = FLabel(backgroundColor: UIColor.clear, text: "New Sponsorships", font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!, textAlignment: .left, textColor: UIColor.label)
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label
        return view
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label
        return view
    }()
    
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    var sponsorshipCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // configureViews()
        configureDropDowns()
        configureCollectionView()
      //fetchSponsorshipData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    // configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  navigationTitleView.removeFromSuperview()
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "postCampaignIcon"), style: .done, target: self, action: #selector(handleCreateCampaign))
        navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    private func configureViews(){
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 40)
        
        topView.addSubview(filterImageView)
        topView.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterImageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16),
            filterImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            filterImageView.widthAnchor.constraint(equalToConstant: 20),
            filterImageView.heightAnchor.constraint(equalToConstant: 20),
            filterButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8),
            filterButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8),
            filterButton.rightAnchor.constraint(equalTo: filterImageView.leftAnchor, constant: 0),
            filterButton.widthAnchor.constraint(equalToConstant: 64),
            
        ])
        
        filterImageView.isUserInteractionEnabled = true
        let filterTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFilter))
        filterTapGesture.numberOfTapsRequired = 1
        filterImageView.addGestureRecognizer(filterTapGesture)
        filterButton.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        
        
        topView.addSubview(separatorView)
        separatorView.anchor(top: topView.topAnchor, left: nil, bottom: topView.bottomAnchor, right: filterButton.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 1, height: 0)
        
        topView.addSubview(sortImageView)
        sortImageView.anchor(top: nil, left: nil, bottom: nil, right: separatorView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 24, height: 24)
        NSLayoutConstraint.activate([
            sortImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        
        topView.addSubview(sortButton)
        sortButton.anchor(top: topView.topAnchor, left: nil, bottom: topView.bottomAnchor, right: sortImageView.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 48, height: 0)
        sortImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSort))
        tapGesture.numberOfTapsRequired = 1
        sortImageView.addGestureRecognizer(tapGesture)
        sortButton.addTarget(self, action: #selector(handleSort), for: .touchUpInside)
        
        topView.addSubview(separatorView2)
        separatorView2.anchor(top: topView.topAnchor, left: nil, bottom: topView.bottomAnchor, right: sortButton.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 1, height: 0)
        
        topView.addSubview(campaignImageView)
        topView.addSubview(campaignButton)
        NSLayoutConstraint.activate([
            campaignImageView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 16),
            campaignImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            campaignImageView.widthAnchor.constraint(equalToConstant: 24),
            campaignImageView.heightAnchor.constraint(equalToConstant: 24),
            campaignButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8),
            campaignButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8),
            campaignButton.leftAnchor.constraint(equalTo: campaignImageView.rightAnchor, constant: 0),
            campaignButton.rightAnchor.constraint(equalTo: separatorView2.leftAnchor, constant: -8),
            
        ])
        
        campaignImageView.isUserInteractionEnabled = true
        let createCampaignTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCreateCampaign))
        createCampaignTapGesture.numberOfTapsRequired = 1
        campaignImageView.addGestureRecognizer(createCampaignTapGesture)
        campaignButton.addTarget(self, action: #selector(handleMyCampaigns), for: .touchUpInside)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        sponsorshipCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        sponsorshipCollectionView.delegate = self
        sponsorshipCollectionView.dataSource = self
        sponsorshipCollectionView.backgroundColor = .clear
        sponsorshipCollectionView.translatesAutoresizingMaskIntoConstraints = false
        sponsorshipCollectionView.showsVerticalScrollIndicator = false
        sponsorshipCollectionView.register(SponsorshipCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        sponsorshipCollectionView.register(AppliedCampCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierForApplied)
        view.addSubview(sponsorshipCollectionView)
        sponsorshipCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sponsorshipCollectionView.backgroundColor = UIColor.systemBackground
    }

    private func configureDropDowns(){
        sortDropDown.anchorView = sortButton
        sortDropDown.dataSource = sortData
        
        sortDropDown.cellConfiguration = { (index, item) in
            print(item)
            return "\(item)" }
        sortDropDown.width = 144
        sortDropDown.direction = .bottom
        sortDropDown.bottomOffset = CGPoint(x: 0, y:(sortDropDown.anchorView?.plainView.bounds.height)! - 10)
        sortDropDown.dismissMode = .automatic
        sortDropDown.backgroundColor = UIColor.systemBackground
        sortDropDown.textColor = UIColor.label
        sortDropDown.textFont = UIFont.systemFont(ofSize: 14)
        sortDropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
        sortDropDown.selectedTextColor = UIColor.label
        sortDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fetchSortedData(index: index)
            
        }
        
        
        filterDropDown.anchorView = filterButton
        filterDropDown.dataSource = filterData
       
        filterDropDown.cellConfiguration = { (index, item) in
            print(item)
            return "\(item)" }
        filterDropDown.width = 120
        filterDropDown.direction = .bottom
        filterDropDown.bottomOffset = CGPoint(x: 0, y:(filterDropDown.anchorView?.plainView.bounds.height)! - 10)
        filterDropDown.dismissMode = .automatic
        filterDropDown.backgroundColor = UIColor.systemBackground
        filterDropDown.textColor = UIColor.label
        filterDropDown.textFont = UIFont.systemFont(ofSize: 14)
        filterDropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
        filterDropDown.selectedTextColor = UIColor.label
        filterDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if index == 0{
                self.showPriceFilterAlert()
            }
            if index == 1{
                self.showGenderFilterAlert()
            }
           
       }
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
    
//    MARK: - Handlers
    
    @objc private func handleCreateCampaign(){
//        let createCampaignVC = CreateCampaignsVC()
//        let createCampaignVC = CreateCampaignsController()
        
        let createCampaignVC = CreateCompainViewC_1()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(createCampaignVC, animated: true)
    }
    
    @objc private func handleSort(){
        sortDropDown.show()
    }
    
    @objc private func handleFilter(){
        filterDropDown.show()
    }
    
    @objc private func handleOptionsMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "My Campaigns", style: .default, handler: { (action) in
            let myCampaignVC = MyCampaignVC(collectionViewLayout: UICollectionViewFlowLayout())
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(myCampaignVC, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true)
    }
    
    @objc private func handleMyCampaigns(){
        let myCampaignVC = MyCampaignVC(collectionViewLayout: UICollectionViewFlowLayout())
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(myCampaignVC, animated: true)
    }
    
    private func showPriceFilterAlert(){
        let alertVC = UIAlertController(title: "Filter By Price", message: nil, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "$0-50", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 0, final: 50)
        }))
        alertVC.addAction(UIAlertAction(title: "$50-100", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 50, final: 100)
        }))
        alertVC.addAction(UIAlertAction(title: "$100-500", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 100, final: 500)
        }))
        alertVC.addAction(UIAlertAction(title: "$500-1000", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 500, final: 1000)
        }))
        alertVC.addAction(UIAlertAction(title: "$1000-5000", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 1000, final: 5000)
        }))
        alertVC.addAction(UIAlertAction(title: "$5000-10000", style: .default, handler: { (action) in
            self.fetchFilteredPriceData(initial: 5000, final: 10000)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
        }))
        self.present(alertVC, animated: true)
    }
    
    private func showGenderFilterAlert(){
        let alertVC = UIAlertController(title: "Filter By Gender", message: nil, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Male", style: .default, handler: { (action) in
            self.fetchFilteredGenderData(gender: "Male")
        }))
        alertVC.addAction(UIAlertAction(title: "Female", style: .default, handler: { (action) in
            self.fetchFilteredGenderData(gender: "Female")
        }))
        alertVC.addAction(UIAlertAction(title: "Any", style: .default, handler: { (action) in
            self.fetchFilteredGenderData(gender: "Any")
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
        }))
        self.present(alertVC, animated: true)
    }
    
//    MARK: - API
    
     func fetchSponsorshipData(query : Query){
        
        sponsorships.removeAll()
        showIndicatorView()
        query.getDocuments { (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            
      
            
            for document in snapshot.documents{
                let data = document.data()
                print(data)
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
            
            self.sponsorshipCollectionView.reloadData()
            self.dismissIndicatorView()
        }
    }
    
    
    private func fetchSortedData(index: Int){
        sponsorships.removeAll()
        showIndicatorView()
        var query: Query!
        if index == 0{
            query = SPONSORSHIP_REF.order(by: "creationDate", descending: true)
            infoLabel.text = "Newest Sponsorships"
        }else if index == 1{
            query = SPONSORSHIP_REF.order(by: "creationDate", descending: false)
            infoLabel.text = "Oldest Sponsorships"
        }else if index == 2{
            query = SPONSORSHIP_REF.order(by: "applied", descending: true)
            infoLabel.text = "Most Applied Sponsorships"
        }else if index == 3{
            query = SPONSORSHIP_REF.order(by: "applied", descending: false)
            infoLabel.text = "Least Applied Sponsorships"
        }else if index == 4{
            query = SPONSORSHIP_REF.order(by: "price", descending: true)
            infoLabel.text = "Highest Paying Sponsorships"
        }else if index == 5{
            query = SPONSORSHIP_REF.order(by: "price", descending: false)
            infoLabel.text = "Lowest Paying Sponsorships"
        }else{
            query = SPONSORSHIP_REF.order(by: "creationDate", descending: true)
        }
        
        query.whereField("isApproved", isEqualTo: true).getDocuments { (snapshot, error) in
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
            
            self.sponsorshipCollectionView.reloadData()
            self.dismissIndicatorView()
        }
    }
    
    private func fetchFilteredPriceData(initial: Int, final: Int){
        sponsorships.removeAll()
        showIndicatorView()
        SPONSORSHIP_REF.whereField("isApproved", isEqualTo: true).whereField("price", isGreaterThanOrEqualTo: initial).whereField("price", isLessThan: final).getDocuments { (snapshot, error) in
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
            
            self.sponsorshipCollectionView.reloadData()
            self.dismissIndicatorView()
        }
    }
    
    private func fetchFilteredGenderData(gender: String){
        sponsorships.removeAll()
        showIndicatorView()
        let query: Query = SPONSORSHIP_REF.order(by: "creationDate", descending: true)
        query.whereField("isApproved", isEqualTo: true).whereField("gender", isEqualTo: gender).getDocuments { (snapshot, error) in
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
            
            self.sponsorshipCollectionView.reloadData()
            self.dismissIndicatorView()
        }
    }
    
    
    
              
//    MARK: - CollectionView Dlelegate and Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-10, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        if isApplied{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierForApplied, for: indexPath) as! AppliedCampCollectionViewCell
            
            if !sponsorships.isEmpty{
                
                cell.sponsorships = self.sponsorships[indexPath.row]
            }
            return cell
        }
        else{
          let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SponsorshipCollectionViewCell
            
            if !sponsorships.isEmpty{
                cell.sponsorships = self.sponsorships[indexPath.row]
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = CampaignDetailViewController()
        detailsVC.modalPresentationStyle = .fullScreen
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationItem.backBarButtonItem = backButton
        detailsVC.sponsorship = Sponsorships(userId: sponsorships[indexPath.row].userId, price: sponsorships[indexPath.row].price, platforms: sponsorships[indexPath.row].platforms, name: sponsorships[indexPath.row].name, gender: sponsorships[indexPath.row].gender, minFollowers: sponsorships[indexPath.row].minFollowers, description: sponsorships[indexPath.row].description, currency: sponsorships[indexPath.row].currency, creationDate: Double(sponsorships[indexPath.row].creationDate.timeIntervalSince1970), influencers: sponsorships[indexPath.row].influencers, categories: sponsorships[indexPath.row].categories, campaignId: sponsorships[indexPath.row].campaignId, isApproved: sponsorships[indexPath.row].isApproved, selectedUsers: sponsorships[indexPath.row].selectedUsers, blob: sponsorships[indexPath.row].blob)
        present(detailsVC, animated: true)
    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
        
    
}
