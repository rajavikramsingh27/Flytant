//
//  UIHelper.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit


struct UIHelper{
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
       let width = view.bounds.width
       let padding: CGFloat = 12
       let minimumInterItemSpacing: CGFloat = 10
       let availableWidth = width - (padding*2) - (minimumInterItemSpacing*2)
       let itemWidth = availableWidth/3
       
       let flowLayout = UICollectionViewFlowLayout()
       flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
       flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
       return flowLayout
    }
    
    static func createTwoRowFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        let height: CGFloat = 40
       let padding: CGFloat = 10
       let minimumInterItemSpacing: CGFloat = 10
       let availableHeight = height - (padding) - (minimumInterItemSpacing)
       let itemHeight = availableHeight/2
       
       let flowLayout = UICollectionViewFlowLayout()
       flowLayout.sectionInset = UIEdgeInsets(top: padding, left: 4, bottom: padding, right: padding)
       flowLayout.itemSize = CGSize(width: 150, height: itemHeight)
       flowLayout.scrollDirection = .horizontal
       return flowLayout
    }
    
    static func createSingleRowFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        let height: CGFloat = 40
       let padding: CGFloat = 10
       let minimumInterItemSpacing: CGFloat = 10
       let availableHeight = height - (padding) - (minimumInterItemSpacing)
       let itemHeight = availableHeight
       
       let flowLayout = UICollectionViewFlowLayout()
       flowLayout.sectionInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: padding)
       flowLayout.itemSize = CGSize(width: 40, height: itemHeight)
       flowLayout.scrollDirection = .horizontal
       return flowLayout
    }
    
    static func createSingleVerticalFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        let height: CGFloat = 40
       let padding: CGFloat = 10
       let minimumInterItemSpacing: CGFloat = 10
       let availableHeight = height - (padding) - (minimumInterItemSpacing)
       let itemHeight = availableHeight
       
       let flowLayout = UICollectionViewFlowLayout()
       flowLayout.sectionInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: padding)
       flowLayout.itemSize = CGSize(width: 40, height: itemHeight)
       flowLayout.scrollDirection = .vertical
       return flowLayout
    }
    
    static func addGradient(view: UIView, color1: UIColor, color2: UIColor, color3: UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.locations = [0.0 , 0.7]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        view.layer.insertSublayer(gradient, at: 0)
    }
 
}

class DarkMode : UIColor {
    
    static var isDarkMode : Bool = {
        return UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black : .white
        } == .black ? true : false
    }()
    
}

