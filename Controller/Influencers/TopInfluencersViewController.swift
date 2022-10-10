

//  TopInfluencersViewController.swift
//  Flytant-1
//  Created by GranzaX on 28/02/22.


import UIKit
import Firebase


class TopInfluencersViewController: UIViewController {
    var navBar: UIView!
    var collTopInfluencers: UICollectionView!
    
    var arrTopInfluencer = [[String: Any]]()
    var arrUsersTopInfluencers = [Users]()
    
    var limit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        getTopInfluencer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func makeUI() {
        setNavigationBar()
        topInfluencersUI()
    }
    
    func setNavigationBar() {
        let screenSize = UIScreen.main.bounds
        
        let viewUpperNav: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(viewUpperNav)
        
        NSLayoutConstraint.activate([
            viewUpperNav.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            viewUpperNav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            viewUpperNav.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            viewUpperNav.heightAnchor.constraint(equalToConstant: CGFloat(sageAreaHeight()))
        ])
        
        
        navBar = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            
            
            let lblTitle:UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Top Influencers"
                label.textColor = .label
                label.font = UIFont (name: "RoundedMplus1c-Bold", size: 16)
                
                return label
            }()
            
            view.addSubview(lblTitle)
            
            NSLayoutConstraint.activate([
                lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                lblTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
            
            let btnBack: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .systemBackground
                button.setImage(UIImage (named: "back_subscription"), for: .normal)
                button.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
                
                return button
            }()
            
            view.addSubview(btnBack)
            
            NSLayoutConstraint.activate([
                btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                btnBack.widthAnchor.constraint(equalToConstant: 44),
                btnBack.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            return view
        }()
        
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: viewUpperNav.leftAnchor, constant: 0),
            navBar.topAnchor.constraint(equalTo: viewUpperNav.bottomAnchor, constant: 0),
            navBar.widthAnchor.constraint(equalToConstant: screenSize.width),
            navBar.heightAnchor.constraint(equalToConstant: CGFloat(44)),
        ])
            
        
    }
    
    
    func topInfluencersUI() {
        collTopInfluencers = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 30, right: 16)
            layout.itemSize = CGSize(width: ((self.view.frame.width-32)/2)-6, height: 210)
            layout.scrollDirection = .vertical
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.collectionViewLayout = layout
            collectionView.register(TopInfluencersCollectionViewCell.self, forCellWithReuseIdentifier: "topInfluencers")

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .systemBackground

            collectionView.showsHorizontalScrollIndicator = false

            return collectionView
        }()

        self.view.addSubview(collTopInfluencers)
        
        NSLayoutConstraint.activate([
            collTopInfluencers.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0),
            collTopInfluencers.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            collTopInfluencers.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            collTopInfluencers.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
        ])
    }

    func getTopInfluencer() {
        PresenterInfluencer.limitTopInfluencers = limit
        let loader = showLoader()
        PresenterInfluencer.topInfluencer { (arrTopInfluencer, error) in
            
            for dictTopInfluencer in arrTopInfluencer {
                self.arrUsersTopInfluencers.append(self.getUserArray(dictTopInfluencer))
            }
            
            DispatchQueue.main.async {
                loader.removeFromSuperview()                
                self.arrTopInfluencer = arrTopInfluencer
                self.collTopInfluencers.reloadData()
            }
        }
    }
    
}



extension TopInfluencersViewController {
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func getUserArray(_ data: [String: Any]) -> Users {
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
        
        return Users(bio: bio, dateOfBirth: dateofBirth, email: email, gender: gender, name: name, socialScore: socialScore, shouldShowInfluencer: shouldShowInfluencer, shouldShowTrending: shouldShowTrending, username: username, userID: userID, profileImageURL: profileImageURL, websiteUrl: websiteUrl, blockedUsers: blockedUsers, geoPoint: geoPoint, categories: categories, linkedAccounts: linkedAccounts)
    }

}



extension TopInfluencersViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout,
                                        UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTopInfluencer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topInfluencers", for: indexPath) as! TopInfluencersCollectionViewCell
        
        cell.setData(arrTopInfluencer[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.navigationBar.isHidden = false
        
        let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        socialProfileVC.user = arrUsersTopInfluencers[indexPath.row]
        socialProfileVC.changeHeader = true
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(socialProfileVC, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            limit = limit+20
            
            getTopInfluencer()
        }
    }
    

}


