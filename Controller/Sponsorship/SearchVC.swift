//
//  SearchVC.swift
//  Flytant
//
//  Created by Vivek Rai on 16/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
//    MARK: - Properties
    
//    MARK: - Views
    
//    let bgImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "flytant_bg")!)
//    let iconIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "flytantIcon")!)
//    let searchTF = FTextField(backgroundColor: UIColor.clear, borderStyle: .none, contentType: .name, keyboardType: .default, textAlignment: .left, placeholder: "")
//    let searchEmptyIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "searchEmptyView")!)
//    let searchTextLabel = FLabel(backgroundColor: UIColor.clear, text: "Search Influencers", font: UIFont.systemFont(ofSize: 18), textAlignment: .left, textColor: UIColor.white)
//    let searchIV = FImageView(backgroundColor: UIColor.clear, cornerRadius: 0, image: UIImage(named: "searchHub")!)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureView()
//        configureNavigationBar()
//    }
//
////    MARK: - Configure Views
//
//
//    private func configureView(){
//        view.backgroundColor = UIColor.systemBackground
//        view.addSubview(bgImageView)
//        bgImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        view.addSubview(iconIV)
//        iconIV.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 260, height: 80)
//        iconIV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.addSubview(searchTF)
//        searchTF.anchor(top: iconIV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
//        searchTF.layer.cornerRadius = 20
//        searchTF.layer.borderColor = UIColor.white.cgColor
//        searchTF.layer.borderWidth = 1
//        searchTF.addTarget(self, action: #selector(handleSearch), for: .touchDown)
//
//        view.addSubview(searchEmptyIV)
//        searchEmptyIV.anchor(top: searchTF.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 48, paddingBottom: 0, paddingRight: 48, width: 0, height: 264)
//
//        searchTF.addSubview(searchIV)
//        searchIV.anchor(top: searchTF.topAnchor, left: searchTF.leftAnchor, bottom: searchTF.bottomAnchor, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 28, height: 0)
//        searchTF.tintColor = UIColor.white
//
//        searchTF.addSubview(searchTextLabel)
//        searchTextLabel.anchor(top: searchTF.topAnchor, left: searchIV.rightAnchor, bottom: searchTF.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 0, width: 200, height: 0)
//
//    }
//
//    private func configureNavigationBar(){
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
////    MARK: -  Handlers
//
//    @objc private func handleSearch(){
////        let algoliaSearchVC = AlgoliaSearchVC()
////        let presentVC = UINavigationController(rootViewController: algoliaSearchVC)
////        navigationController?.present(presentVC, animated: true)
////        let searchVC = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
////        let presentVC = UINavigationController(rootViewController: searchVC)
////        navigationController?.pushViewController(presentVC, animated: true)
//
//
//        let searchVC = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
//        let transition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromTop
//        navigationController?.view.layer.add(transition, forKey: nil)
//        navigationController?.pushViewController(searchVC, animated: false)
//    }

}
