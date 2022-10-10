//
//  TableCollectionViewCell.swift
//  DynamicTableView
//

//

import UIKit

class TableCollectionViewCell: UICollectionViewCell{
    let padding: CGFloat = 5
    var widthCons = NSLayoutConstraint()
    
    public let label: UILabel = {
        let v = UILabel()
        v.textColor = .darkText
        v.minimumScaleFactor = 0.5
        v.numberOfLines = 1
        return v
    }()
    
    let bannerImage = UIImageView()
    
    public let bannerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ProjectColor.sponCardHeadLabel
        label.font = AppFont.font(type: .Bold, size: 14)
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()
    
    
   let platformImage =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    
    var platformImageView: UIStackView = {
        let stackView = UIStackView()
      
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1.5
        return stackView
    }()
    var totalPlatformImage : Int = 0
    let platformImageView1  =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let platformImageView2  =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let platformImageView3 =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let platformImageView4  =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    let platformImageView5  =  FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage())
    
    
    
    
    public let TimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ProjectColor.sponCardsubHeadLabel
        // label.backgroundColor = .red
        label.font = AppFont.font(type: .Medium, size: 10)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()
    
    
    
    public let bannerBottomView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.backgroundColor = .red
        
        return view
        
    }()
    
    public let dividerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        return view
        
    }()
    
    var imageLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .brown
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5.0
        return stackView
    }()
    
    
    public let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()
    
    public let minFollowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .natural
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        
        DispatchQueue.main.async {
                   self.bannerImage.roundCorners([.topRight,.topLeft], radius: 8)
                   self.bannerImage.layer.masksToBounds = true
               }
        
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
  
//        self.layer.cornerRadius = 8
//       // self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 0.25
//        self.layer.backgroundColor = UIColor.white.cgColor
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
//
//        self.layer.shadowOpacity = 0.3
//        self.layer.masksToBounds = false
        
        contentView.backgroundColor = UIColor.ProjectColor.cardBackgroundColor
   
        
        contentView.addSubview(bannerImage)
        contentView.addSubview(bannerLabel)
        contentView.addSubview(platformImageView)
        contentView.addSubview(TimeLabel)
        contentView.addSubview(bannerBottomView)
        
        bannerBottomView.addSubview(dividerView)
        bannerBottomView.addSubview(priceLabel)
        bannerBottomView.addSubview(minFollowerLabel)
            //   bannerBottomView.isHidden = true
        
        updateConstraints()
    }
    
    
    //MARK:- For changing collection view cell border color after mode change
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
             
           // layer.borderColor = UIColor.lightGray.cgColor
           }
       }
    }
    
    
    override func updateConstraints() {
        
        
        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        bannerImage.contentMode = .scaleAspectFill
        bannerImage.image = #imageLiteral(resourceName: "dummmy")
        
        NSLayoutConstraint.activate([
            bannerImage.topAnchor.constraint(equalTo: topAnchor),
            bannerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImage.bottomAnchor.constraint(equalTo:  bannerLabel.topAnchor, constant: -padding),
            
            bannerImage.heightAnchor.constraint(equalToConstant: 115)
        ])

        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bannerLabel.text = "Orica sponsorships"
        
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: padding),
            bannerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bannerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            bannerLabel.bottomAnchor.constraint(equalTo: TimeLabel.topAnchor, constant: -padding),
            
            bannerLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        platformImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            platformImageView.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: padding),
            platformImageView.bottomAnchor.constraint(equalTo: bannerBottomView.topAnchor, constant: -padding),
            platformImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        
            platformImageView.heightAnchor.constraint(equalToConstant: 15),
            platformImageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5)
        ])
        
        
        platformImageView1.contentMode = .scaleAspectFit
        platformImageView2.contentMode = .scaleAspectFit
        platformImageView3.contentMode = .scaleAspectFit
        platformImageView4.contentMode = .scaleAspectFit
        platformImageView5.contentMode = .scaleAspectFit
        
        
        platformImageView1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
        
            platformImageView1.heightAnchor.constraint(equalToConstant: 15),
            platformImageView1.widthAnchor.constraint(equalToConstant: 15),
        ])
        
        platformImageView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
        
            platformImageView2.heightAnchor.constraint(equalToConstant: 15),
            platformImageView2.widthAnchor.constraint(equalToConstant: 15),
        ])
        platformImageView3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
        
            platformImageView3.heightAnchor.constraint(equalToConstant: 15),
            platformImageView3.widthAnchor.constraint(equalToConstant: 15),
        ])
        platformImageView4.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
        
            platformImageView4.heightAnchor.constraint(equalToConstant: 15),
            platformImageView4.widthAnchor.constraint(equalToConstant: 15),
        ])
        platformImageView5.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
        
            platformImageView5.heightAnchor.constraint(equalToConstant: 15),
            platformImageView5.widthAnchor.constraint(equalToConstant: 15),
        ])
        

        TimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        TimeLabel.text = "12 min ago"
        
        NSLayoutConstraint.activate([
            TimeLabel.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: padding),
            TimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentView.frame.width/2),
            TimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            TimeLabel.bottomAnchor.constraint(equalTo: bannerBottomView.topAnchor, constant: -padding),
            
            TimeLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        
        NSLayoutConstraint.activate([
            bannerBottomView.topAnchor.constraint(equalTo: TimeLabel.bottomAnchor, constant: padding),
            bannerBottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            bannerBottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerBottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
           // bannerBottomView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: bannerBottomView.topAnchor, constant: padding),
            dividerView.bottomAnchor.constraint(equalTo: minFollowerLabel.topAnchor, constant: -padding),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: padding),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding+2),
            //            priceLabel.trailingAnchor.constraint(equalTo:   minFollowerLabel.leadingAnchor, constant: -2),
            priceLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            minFollowerLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: padding),
            //            minFollowerLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 2),
            minFollowerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            minFollowerLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        
        priceLabel.textColor = UIColor.ProjectColor.sponCardsubHeadLabel
      
        minFollowerLabel.textColor = UIColor.ProjectColor.sponCardsubHeadLabel
       
        
        
        super.updateConstraints()
    }
    
    func setUpSponsorCell(model: Sponsorships){
        
        bannerImage.sd_setImage(with: URL(string: model.blob[0]["path"] ?? ""), placeholderImage: UIImage(named: ""))
        
        bannerLabel.text = model.name
        
        
      //  platform( model.platforms )
        
       
        
        
        
        if let timeDate = model.creationDate{
            TimeLabel.text = "\(timeDate.timeAgoToDisplay())"
        }
    
        
        if model.price == 0{
            
            priceLabel.add(image: UIImage(named: "barterIcon") ?? #imageLiteral(resourceName: "barterIcon"), text: " "+" Barter")
        }else{
            
        
            guard  let price =  model.price else {return}
            
  
            
            priceLabel.add(image: UIImage(named: "dollar") ?? #imageLiteral(resourceName: "dollar"), text: " "+formatPoints(from: price))
        }
        
        
        guard  let minFollower =  model.minFollowers else {return}
        
        minFollowerLabel.add(image: UIImage(named: "persons") ?? #imageLiteral(resourceName: "persons"), text: "  "+"Min " + formatPoints(from: minFollower))
  
        
    }
    
    
    func platform(_ platform : [String] ) {
        

        if platform.contains("Instagram") {
            platformImageView1.isHidden = false
            platformImageView.addArrangedSubview(platformImageView1)
            platformImageView1.tintColor = .label
            platformImageView1.image = UIImage(named: "insta")
      
  
        }
        if platform.contains("Facebook"){
            platformImageView2.isHidden = false
            platformImageView.addArrangedSubview(platformImageView2)
            platformImageView2.tintColor = .label
            platformImageView2.image = UIImage(named: "facebook")
      
          
        }
        if platform.contains("Youtube") {
            platformImageView3.isHidden = false
            platformImageView.addArrangedSubview(platformImageView3)
            platformImageView3.tintColor = .label
            platformImageView3.image = #imageLiteral(resourceName: "youtube")
   
         
        }
        if platform.contains("Twitter"){
            platformImageView4.isHidden = false
            platformImageView.addArrangedSubview(platformImageView4)
            platformImageView4.tintColor = .label
            platformImageView4.image = #imageLiteral(resourceName: "twitter")

         
        }
        if platform.contains("Linkedin"){
            platformImageView5.isHidden = false
            platformImageView.addArrangedSubview(platformImageView5)
            platformImageView5.tintColor = .label
            platformImageView5.image = #imageLiteral(resourceName: "linkedin")
        
         
        }
        
      
        
        
    }
    
    
    
    
    
}
