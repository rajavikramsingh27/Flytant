//
//  CardViewModel.swift
//  Flytant
//
//  Created by Vivek Rai on 30/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class CardViewModel {
    
    let user: Users
    let userInfoText: NSAttributedString
    private var imageIndex = 0
    var imageUrl: String?
    
    init(user: Users) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        if let date = dateformatter.date(from: user.dateOfBirth ?? ""){
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.year], from: date, to: Date())
            attributedText.append(NSAttributedString(string: "  \(components.year ?? 22)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
            self.userInfoText = attributedText
        }else{
            self.userInfoText = attributedText
        }
        
        if !user.swipeImageUrls.isEmpty{
            self.imageUrl = user.swipeImageUrls[0]
        }else{
            self.imageUrl = DEFAULT_PROFILE_IMAGE_URL
        }
        
    }
    
//    func showNextPhoto(){
//        guard imageIndex < (user.images.count - 1) else {return}
//        imageIndex += 1
//        self.imageToShow = user.images[imageIndex]
//    }
//
//    func showPreviousPhoto(){
//        guard imageIndex > 0 else {return}
//        imageIndex -= 1
//        self.imageToShow = user.images[imageIndex]
//    }
    
    func calculateAge(dob: String) -> Int{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        if let date = dateformatter.date(from: dob ){
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.year], from: date, to: Date())
            return components.year ?? 22
        }else{
            return 22
        }
    }
}
