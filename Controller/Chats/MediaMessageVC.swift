//
//  MessageMediaVC.swift
//  Flytant
//
//  Created by Vivek Rai on 15/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import SKPhotoBrowser

private let reuseIdentifier = "messageMediaCollectionViewCell"

class MediaMessageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    MARK: - Properties
    var allImageLinks = [String]()
    var images = [SKPhoto]()
    
//    MARK: - Views
    private let activityIndicatorView = FActivityIndicatorView(frame: CGRect())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        configureCollectionView()
        
        setPictureMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    private func configureNavigationBar(){
         navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Media"
    }
    
    private func configureCollectionView(){
        self.collectionView.register(MediaMessageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
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
    
    

//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: CGFloat(exactly: width)!)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaMessageCollectionViewCell
        cell.postImageView.loadImage(with: allImageLinks[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    private func setPictureMessages(){
        for imageLink in allImageLinks{
            let photo = SKPhoto.photoWithImageURL(imageLink)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
        }
    }
}
