//
//  InfluencersHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 27/02/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit
import Firebase

private let reuseIdentifier = "influencersHeader"

class InfluencersHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
//    MARK: - Properties
    
    var trendingInfluecners = [Users]()
    
//    MARK: - Views
    
    let searchTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "")
    let searchIconView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "searchIconInfluencers")!)
    let searchLabel = FLabel(backgroundColor: UIColor.clear, text: "Search Influencers....", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, textColor: UIColor.systemGray)
    let micIconView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "micIcon")!)
    
    let trendingLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!, textAlignment: .left, textColor: .label)
    var trendingCollectionView: UICollectionView!
    let topInlfuencersLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont(name: "RoundedMplus1c-Bold", size: 18)!, textAlignment: .left, textColor: .label)
    let searchButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10))
    var delegate: InfluencersHeaderDelegate?
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSearchTF()
        configureTrendingLabel()
        configureTrendingCollectionView()
        configureTopInfluencersLabel()
        configureSearchButton()
        
        fetchTrendingInfluencers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSearchTF(){
        addSubview(searchTF)
        searchTF.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        searchTF.layer.cornerRadius = 20
        searchTF.layer.borderWidth = 1
        searchTF.inputView = UIView()
        searchTF.layer.borderColor = UIColor.label.cgColor
        searchTF.addSubview(searchIconView)
        searchTF.addSubview(searchLabel)
        searchTF.addSubview(micIconView)
        NSLayoutConstraint.activate([
            searchIconView.leftAnchor.constraint(equalTo: searchTF.leftAnchor, constant: 8),
            searchIconView.centerYAnchor.constraint(equalTo: searchTF.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 24),
            searchIconView.heightAnchor.constraint(equalToConstant: 24),
            searchLabel.leftAnchor.constraint(equalTo: searchIconView.rightAnchor, constant: 16),
            searchLabel.centerYAnchor.constraint(equalTo: searchTF.centerYAnchor),
            searchLabel.topAnchor.constraint(equalTo: searchTF.topAnchor),
            searchLabel.bottomAnchor.constraint(equalTo: searchTF.bottomAnchor),
            searchTF.widthAnchor.constraint(equalToConstant: 200),
            micIconView.centerYAnchor.constraint(equalTo: searchTF.centerYAnchor),
            micIconView.rightAnchor.constraint(equalTo: searchTF.rightAnchor, constant: -8),
            micIconView.widthAnchor.constraint(equalToConstant: 24),
            micIconView.heightAnchor.constraint(equalToConstant: 24),
        ])
        searchTF.addTarget(self, action: #selector(handleSearch), for: .touchDown)
    }
    
    private func configureTrendingLabel(){
        addSubview(trendingLabel)
        trendingLabel.anchor(top: searchTF.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 200, height: 24)
    }
    
    private func configureTrendingCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 300)
        trendingCollectionView = UICollectionView(frame: frame, collectionViewLayout: UIHelper.createSingleRowFlowLayout(in: self))
        trendingCollectionView.delegate = self
        trendingCollectionView.dataSource = self
        trendingCollectionView.backgroundColor = .clear
        trendingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trendingCollectionView.showsHorizontalScrollIndicator = false
        trendingCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "influencersHeader")
        addSubview(trendingCollectionView)
        trendingCollectionView.anchor(top: trendingLabel.bottomAnchor, left: trendingLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: frame.width - 32, height: 240)
        trendingCollectionView.backgroundColor = UIColor.systemBackground
    }
    
    private func showIndicatorView() {
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
    }
    
    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
    
    private func configureTopInfluencersLabel(){
        addSubview(topInlfuencersLabel)
        topInlfuencersLabel.anchor(top: trendingCollectionView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 200, height: 24)
    }
    
    private func configureSearchButton(){
        addSubview(searchButton)
        searchButton.anchor(top: searchTF.topAnchor, left: searchTF.leftAnchor, bottom: searchTF.bottomAnchor, right: searchTF.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingInfluecners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "influencersHeader", for: indexPath) as! TrendingCollectionViewCell

        if !trendingInfluecners.isEmpty{
            cell.influencerIV.loadImage(with: trendingInfluecners[indexPath.row].profileImageURL)
            cell.usernameLabel.text = "@"+trendingInfluecners[indexPath.row].username
            
            let userGender = self.trendingInfluecners[indexPath.row].gender.prefix(1).uppercased()
            let location = CLLocation(latitude: trendingInfluecners[indexPath.row].geoPoint.latitude, longitude: trendingInfluecners[indexPath.row].geoPoint.longitude)
            location.fetchCityAndCountry { (city, country, error) in
                guard let city = city, let country = country, error == nil else { return }
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .medium
                if let date = dateformatter.date(from: self.trendingInfluecners[indexPath.row].dateOfBirth ?? ""){
                    let calendar = NSCalendar.current
                    let components = calendar.dateComponents([.year], from: date, to: Date())
                    cell.additionalInfoLabel.text = country + ", \(components.year ?? 22) \(userGender)"
                }
            }
            cell.socialScoreLabel.text = "\(trendingInfluecners[indexPath.row].socialScore ?? 58)"
            cell.imageCollectionView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "exploreHeader", for: indexPath) as! ExploreHeaderCollectionViewCell
//        delegate?.handleSelectedCategoryTapped(for: cell, indexPath: indexPath)
       
        delegate?.handleInlfluencers(for: self, user: trendingInfluecners[indexPath.row])
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 208)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc private func handleSearch(){
        delegate?.handleSearch(for: self)
    }
   
//    MARK: - API
    
    private func fetchTrendingInfluencers(){
        self.trendingInfluecners.removeAll()
//        self.showIndicatorView()
        USER_REF.whereField("shouldShowTrending", isEqualTo: true).order(by: "socialScore", descending: true).getDocuments { (snapshot, error) in
            if let _ = error{
                print("Error encountered")
//                self.dismissIndicatorView()
                return
            }
            
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents{
                let data = document.data()
                let bio = data["bio"] as? String ?? ""
                let dateofBirth = data["dateOfBirth"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let socialScore = data["socialScore"] as? Int ?? 0
                let shouldShowInfluencer = data["shouldShowInfluencer"] as? Bool ?? false
                let shouldShowTrending = data["shouldShowTrending"] as? Bool ?? false
                let profileImageURL = data["profileImageUrl"] as? String ?? ""
                let userID = data["userId"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let blockedUsers = data["blockedUsers"] as? [String] ?? [String]()
                let websiteUrl = data["websiteUrl"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [String]()
                let geoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let linkedAccounts = data["linkedAccounts"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                
                let user = Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
                self.trendingInfluecners.append(user)
            }
            self.trendingCollectionView.reloadData()
//            self.dismissIndicatorView()
            self.trendingLabel.text = "Trending"
            self.topInlfuencersLabel.text = "Top Inlfuencers"
        }
    }
}
