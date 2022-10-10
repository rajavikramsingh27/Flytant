//
//  CategoriesFlowLayout.swift
//  Flytant
//
//  Created by Flytant on 11/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class CategoriesFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
    }
    
    init(size : CGSize, direction : UICollectionView.ScrollDirection){
        super.init()
        
        itemSize = size
        scrollDirection = direction
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
      var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
      
      var leftMargin: CGFloat = self.sectionInset.left
      
      for attributes in attributesForElementsInRect! {
        if (attributes.frame.origin.x == self.sectionInset.left) {
          leftMargin = self.sectionInset.left
        } else {
          var newLeftAlignedFrame = attributes.frame
          
          if leftMargin + attributes.frame.width < self.collectionViewContentSize.width {
            newLeftAlignedFrame.origin.x = leftMargin
          } else {
            newLeftAlignedFrame.origin.x = self.sectionInset.left
          }
          
          attributes.frame = newLeftAlignedFrame
        }
        leftMargin += attributes.frame.size.width + 8
        newAttributesForElementsInRect.append(attributes)
      }
      
      return newAttributesForElementsInRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
