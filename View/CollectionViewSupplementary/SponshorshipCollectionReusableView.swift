//
//  SponshorshipCollectionReusableView.swift
//  DynamicTableView
//

//

import UIKit

class SponshorshipCollectionReusableView: UICollectionReusableView {
    
    var ViewMoreButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .systemBackground
        button.backgroundColor = .label
        button.setImage(#imageLiteral(resourceName: "viewMoreButton"), for: .normal)
//        button.setTitle("View more", for: .normal)
//        button.setImage(UIImage.init(systemName: "arrow.right.circle"), for: .normal)
      button.layer.cornerRadius = 28
//        button.semanticContentAttribute = .forceRightToLeft
//        button.centerTextAndImage(spacing: -5)
        
       // button.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }

    func commonInit() {
        addSubview(ViewMoreButton)
 
        updateConstraints()
        
        
    }
    
    
    override func updateConstraints() {
        
        ViewMoreButton.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: ViewMoreButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5)
        let centerYConstraint = NSLayoutConstraint(item: ViewMoreButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: ViewMoreButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 140)
        let heightConstraint = NSLayoutConstraint(item: ViewMoreButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)

        self.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
        
     
        super.updateConstraints()
        
        
    }

        
}
