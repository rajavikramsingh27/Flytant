//
//  Support.swift
//  Flytant
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import Foundation
import UIKit


func formatPoints(from: Int) -> String {

    let number = Double(from)
    let thousand = number / 1000
    let million = number / 1000000
    let billion = number / 1000000000
    
    if billion >= 1.0 {
        return "\(round(billion*10)/10) B"
    } else if million >= 1.0 {
        return "\(round(million*10)/10) M"
    } else if thousand >= 1.0 {
        return ("\(round(thousand*10/10)) k")
    } else {
        return "\(Int(number))"
    }
}

//MARK: uilabel

extension UILabel{
    
    func HeaderLabel(){
        self.textColor = UIColor.ProjectColor.headerColor
        self.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
    }
    
    func subHeaderLabel(){
        self.textAlignment = .center
        self.font = AppFont.font(type: .Bold, size: 8)
        
    }
}


//MARK: color

extension UIColor{
    
    struct ProjectColor {
        
      static var navBackgroundColor = UIColor(named: "NavBackground") //background: #2C2C2C;
        
        static var viewBackground =  UIColor.systemBackground  //UIColor(named: "viewBackground")

        static var sponCardHeadLabel = UIColor.label
        // UIColor(named: "cardHeadLabel") //day #282626 night #FFFFFF 303030
        static var sponCardsubHeadLabel = UIColor.label
         //   #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)  //#959595
        static var sponCardborderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        static var headerColor = UIColor.label
            //UIColor(named: "sectionHeadlabel") //day #565656 night #FFFFFF
        
        static var cardBackgroundColor = UIColor.systemBackground
        // UIColor(named: "cardBackground")//day #FFFFFF night #424242
        
      static var ButtonColor = #colorLiteral(red: 0.4274509804, green: 0.1294117647, blue: 0.9882352941, alpha: 1)
        
    }
    
    
  
}

struct AppFont {
enum FontType: String {
    case Medium = "RoundedMplus1c-Medium"
    case Bold = "RoundedMplus1c-Bold"
    case ExtraBold = "RoundedMplusBold"
    case Black = "RoundedMplus1c-Black"
    case Regular = "RoundedMplus1c-Regular"
    case Light = "RoundedMplus1c-Light"
    
 
}
static func font(type: FontType, size: CGFloat) -> UIFont{
  
    return UIFont(name: type.rawValue, size: size)!
}
}
