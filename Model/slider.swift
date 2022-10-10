//
//  slider.swift
//  Flytant

//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import Foundation
struct Slider: Codable {
    let imageURL: String
    let sponsorship: Int
    let below: String
    let clickAction: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case sponsorship, below, clickAction, title
    }
}
