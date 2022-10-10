//
//  ExploreHeader.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "exploreHeader"

class ExploreHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var delegate: ExploreHeaderDelegate?
    var headerCollectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHeaderCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderCollectionView(){
        headerCollectionView = UICollectionView(frame: frame, collectionViewLayout: UIHelper.createTwoRowFlowLayout(in: self))
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.backgroundColor = .clear
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        headerCollectionView.showsHorizontalScrollIndicator = false
        headerCollectionView.register(ExploreHeaderCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier ?? "exploreHeader")
        addSubview(headerCollectionView)
        headerCollectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RemoteConfigManager.getExploreCategoryData(for: "explore_category")[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "exploreHeader", for: indexPath) as! ExploreHeaderCollectionViewCell
        delegate?.handleSelectedCategory(for: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "exploreHeader", for: indexPath) as! ExploreHeaderCollectionViewCell
        delegate?.handleSelectedCategoryTapped(for: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
