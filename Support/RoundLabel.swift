//
//  RoundLabel.swift
//  flytantapp
//
//  Created by Vivek Singh Mehta on 22/09/21.
//

import UIKit

class RoundLabel: UILabel {
    
   override func layoutSubviews() {
       super.layoutSubviews()
       layer.masksToBounds = true
       layer.cornerRadius = self.bounds.height / 2
   }
   
}
