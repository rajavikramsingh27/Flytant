//
//  selectedTableViewCell.swift
//  Flytant
//

//  Copyright © 2022 Vivek Rai. All rights reserved.
//


import UIKit
import MapKit

class selectedTableViewCell: UITableViewCell {
    
    var isAppliedSelected: Bool = false
    
    var user: Users? {
        didSet{
            guard let profileImageUrl = user?.profileImageURL else {return}
            AppliedInfluencerImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: #imageLiteral(resourceName: "profile_bottom"))
            guard let username = user?.username else {return}
            AppliedInfluencerName.text = username
            guard let location = user?.geoPoint else {return}
           // let userGender = user?.gender.prefix(1).uppercased()
            
            let UserLocation = CLLocation(latitude: location.latitude , longitude: location.longitude)
            
            UserLocation.fetchCityAndCountry { (city, country, error) in
                guard let city = city, let country = country, error == nil else { return }
           
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .medium
                if let date = dateformatter.date(from: self.user?.dateOfBirth ?? ""){
                    let calendar = NSCalendar.current
                    let components = calendar.dateComponents([.year], from: date, to: Date())
                    self.AppliedInfluencerAgeGender.text = country + ", \(components.year ?? 22)"
                }
            }
         
            AppliedInfluencerPlatformCollection.reloadData()
        }
    }
    
    
    
    let AppliedInfluencerImageView = UIImageView()
    let AppliedInfluencerName = UILabel()
    let AppliedInfluencerAgeGender = UILabel()
    let AppliedInfluencerPlatformCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.clear
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(SocialPlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        return collection
    }()
    let AppliedInfluencerChatButton = UIButton()
    let AppliedInfluencerSelectBox = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    func commonInit(){
        //contentView.addSubview(bannerImageView)
      
        updateConstraints()
    }


    override func updateConstraints() {
        // Initialization code
        addSubview(AppliedInfluencerImageView)
        
        AppliedInfluencerImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 70, height: 70)
        AppliedInfluencerImageView.ImageViewRounded(cornerRadius:35)
        
        addSubview(AppliedInfluencerName)
        AppliedInfluencerName.font = AppFont.font(type: .Bold, size: 14)
        AppliedInfluencerName.anchor(top: topAnchor, left: AppliedInfluencerImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 15)
        
        addSubview(AppliedInfluencerAgeGender)
        AppliedInfluencerAgeGender.font = AppFont.font(type: .Bold, size: 12)
        AppliedInfluencerAgeGender.anchor(top: AppliedInfluencerName.bottomAnchor, left: AppliedInfluencerImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.width/2-50, height: 15)
        
        addSubview(AppliedInfluencerPlatformCollection)
        AppliedInfluencerPlatformCollection.anchor(top: AppliedInfluencerAgeGender.bottomAnchor, left: AppliedInfluencerImageView.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: frame.width/2-50, height: 30)

        addSubview(AppliedInfluencerChatButton)
        AppliedInfluencerChatButton.setImage(UIImage(named: "chat"), for: .normal)
        AppliedInfluencerChatButton.tintColor = .label
        AppliedInfluencerChatButton.anchor(top: AppliedInfluencerName.bottomAnchor, left: AppliedInfluencerName.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 20, height: 20)
        
//        addSubview(AppliedInfluencerSelectBox)
//        AppliedInfluencerSelectBox.tintColor = .label
//       AppliedInfluencerSelectBox.anchor(top: AppliedInfluencerName.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 20, height: 20)
//
//
        
        AppliedInfluencerPlatformCollection.dataSource = self
        AppliedInfluencerPlatformCollection.delegate = self
        
        super.updateConstraints()
    }
    
  

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//    MARK: - CollectionView Delegate and DataSource
    
extension selectedTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let platformCount = user?.linkedAccounts.count else {return 0}
        return platformCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! SocialPlatformsCollectionViewCell
        
       
        if ((user?.linkedAccounts["Youtube"]) != nil){
            cell.iconIV.image = UIImage(named: "youtubeicon")
        }else if ((user?.linkedAccounts["Instagram"]) != nil){
            cell.iconIV.image = UIImage(named: "instagramicon")
        }else if ((user?.linkedAccounts["Facebook"]) != nil) {
            cell.iconIV.image = UIImage(named: "facebookicon")
        }
        else if ((user?.linkedAccounts["Linkedin"]) != nil){
            cell.iconIV.image = UIImage(named: "linkedin")
        }
        else{
            cell.iconIV.image = UIImage(named: "twittericon")
        }
        return cell
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
