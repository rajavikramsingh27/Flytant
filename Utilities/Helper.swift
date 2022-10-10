//
//  Helper.swift
//  Flytant
//
//  Created by Flytant on 26/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import Foundation

class Helper {
    
    class func stringValue(_ value: String?) -> String {
        if let value = value {
            return value
        } else {
            return ""
        }
    }
    
    class func stringToIntValue(_ value: String?) -> Int {
        let stringValue = self.stringValue(value)
        if let intValue = Int(stringValue) {
            return intValue
        } else {
            return 0
        }
    }
    
    class func IntToStringValue(_ value: Int?) -> String {
        return intValue(value).description
    }
    
    class func intValue(_ value: Int?) -> Int {
        if let value = value {
            return value
        } else {
            return 0
        }
    }
    
    class func intToDoubleValue(value: Int?) -> Double {
        let value = intValue(value)
        return Double(value) 
    }
    
    class func timeStampToString(timeStamp: Int?) -> String {
        let time = Double(intValue(timeStamp))
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    class func formatNumber(_ n: Int) -> String {
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"
        case 0...:
            return "\(n)"
        default:
            return "\(sign)\(n)"
        }
    }
    
}
