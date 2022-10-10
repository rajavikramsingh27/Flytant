//
//  ChatBackgroundVC.swift
//  Flytant
//
//  Created by Vivek Rai on 22/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ProgressHUD

private let reuseIdentifier = "chatBackgroundCollectionViewCell"

class ChatBackgroundVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties

    var backgroundImages = ["bg0", "bg1", "bg2", "bg3", "bg4", "bg5", "bg6", "bg7", "bg8", "bg9", "bg10", "bg11"]

//    MARK: - Views
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    

        
//    MARK: - Configure Views
    private func configureNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.label
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Chat Backgrounds"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(handleReset))

    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(ChatBackgroundCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
      
//    MARK: - CollectionView Dlelegate and Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width = (view.frame.width - 2) / 3
       return CGSize(width: width-8, height: width+60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatBackgroundCollectionViewCell
        cell.chatBackgroundImageView.image = UIImage(named: backgroundImages[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(backgroundImages[indexPath.row], forKey: CHAT_BACKGROUND)
        UserDefaults.standard.synchronize()
        ProgressHUD.showSuccess("Chat background changed successfully!")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    

//    MARK: - Handlers
    
    @objc private func handleReset(){
        ProgressHUD.showSuccess("Chat background has been reset!")
        UserDefaults.standard.removeObject(forKey: CHAT_BACKGROUND)
        UserDefaults.standard.synchronize()
    }
}
