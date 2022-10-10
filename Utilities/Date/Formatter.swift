//
//  Formatter.swift
//  Flytant
//
//  Created by Flytant on 09/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

struct Formatter {
    
    static var dateFormatter = DateFormatter()
    
    static func getStringDate(format : String, interval : TimeInterval) -> String? {
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: interval)
        return dateFormatter.string(from: date)
    }
    
}
