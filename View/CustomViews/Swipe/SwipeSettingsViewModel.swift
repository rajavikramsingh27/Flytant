//
//  SwipeSettingsViewModel.swift
//  Flytant
//
//  Created by Vivek Rai on 31/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

enum SwipeSettingsSection: Int, CaseIterable{
    case name
    case bio
    case gender
    case dob
    
    var description: String{
        switch self{
        case .name:
            return "Name"
        case .bio:
            return "Bio"
        case .gender:
            return "Gender"
        case .dob:
            return "Date of Birth"
        }
    }
    
}

struct SwipeSettingsViewModel{
    
    private let user: Users
    let section: SwipeSettingsSection
    let placeholderText: String
    var value: String?
    
    init(user: Users, section: SwipeSettingsSection) {
        self.user = user
        self.section = section
        placeholderText = "Enter \(section.description.lowercased())..."
        
        switch section {
        case .name:
            value = user.name
        case .bio:
            value = user.bio
        case .gender:
            value = user.gender
        case .dob:
            value = user.dateOfBirth
        default:
            break
        }
    }
    
    
}
