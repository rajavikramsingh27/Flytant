//
//  GrowthVC.swift
//  Flytant
//
//  Created by Vivek Rai on 07/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "growCollectionViewCell"

class GrowthVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK: - Properties
    
    var imageArray = ["grow1", "grow2", "grow3", "grow4", "grow5", "grow6"]
    
//    MARK: - Views
    private var growCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        configurerGrowCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
        
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.title = "Grow"
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red:250/255, green:0/255, blue:102/255, alpha:1), UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1), UIColor(red:148/255, green:0/255, blue: 211/255, alpha:0.1)], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func configurerGrowCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        growCollectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        growCollectionView.delegate = self
        growCollectionView.dataSource = self
        growCollectionView.backgroundColor = .clear
        growCollectionView.translatesAutoresizingMaskIntoConstraints = false
        growCollectionView.showsVerticalScrollIndicator = false
        growCollectionView.register(GrowthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(growCollectionView)
        growCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        growCollectionView.backgroundColor = UIColor.systemBackground
    }
    
//    MARK: - CollectionView Delegate and DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 10) / 2
        let height = ((width/2) + 30)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GrowthCollectionViewCell
        cell.backgroundImageView.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webViewVC = WebViewVC()
        if indexPath.row == 0{
            webViewVC.urlString = "https://flytant.com/getting-started/"
        }else if indexPath.row == 1{
            webViewVC.urlString = "https://flytant.com/content-strategy/"
        }else if indexPath.row == 2{
            webViewVC.urlString = "https://flytant.com/account-optimization/"
        }else if indexPath.row == 3{
            webViewVC.urlString = "https://flytant.com/money-and-business/"
        }else if indexPath.row == 4{
            webViewVC.urlString = "https://flytant.com/shop-and-more/"
        }else if indexPath.row == 5{
            webViewVC.urlString = "https://flytant.com/policies-and-guidelines/"
        }
        navigationController?.pushViewController(webViewVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
