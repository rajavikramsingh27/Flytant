

//  Global.swift
//  Flytant-1
//  Created by GranzaX on 20/02/22.


import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase
import SwiftToast


var kCurrencySymbol: String = ""
var kCurrencyCode: String = ""
var kCurrencyName: String = ""
var kLanguageCode: String = ""
var usdToLocalPrice: Double = 0.0
var kUsersDocumentID: String = ""

let kUserIDFireBase: String = ""

extension UIView {
    func defaultShadow() {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        shadowLayer.fillColor = UIColor.systemBackground.cgColor
        
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 2
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize (width: 0, height: 0)
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}

func sageAreaHeight() -> Int {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
//            print("iPhone 5 or 5S or 5C")
            
            return 20
        case 1334:
//            print("iPhone 6/6S/7/8")
            
            return 20
        case 1920, 2208:
//            print("iPhone 6+/6S+/7+/8+")
            
            return 20
        case 2436:
//            print("iPhone X/XS/11 Pro")
            
            return 44
        case 2688:
//            print("iPhone XS Max/11 Pro Max")
            
            return 44
        case 1792:
//            print("iPhone XR/ 11 ")
            
            return 44
        default:
//            print("Unknown")
            
            return 44
        }
    } else {
        return 0
    }
}

func iPhoneType() -> String {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C or SE")
            
            return "5 SE"
        case 1334:
            print("iPhone 6/7/8")
            
            return "6 7 8"
        case 1920, 2208:
            print("iPhone 6+/6S+/7+/8+")
            
            return "6 7 8 +"
        case 2436:
            print("iPhone X/XS/11 Pro/mini")
            
            return "X & mini Series"
        case 2688:
            print("iPhone XS Max/11 Pro Max")
            
            return "X Series"
        case 1792:
            print("iPhone XR/ 11 ")
            
            return "X Series"
        default:
            print("Unknown")
            
            return "X Series"
        }
    } else {
        return "0"
    }
}

extension UIColor {
    
    convenience init?(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

extension String {
    func textSize(_ font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: CGFloat(200), height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.size
    }
    
    func dateDifference() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd, yyyy"
        let oldDate = dateFormatter.date(from: self)!
        let newDate = Date()
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.year, .month, .day, .hour, .minute]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .short
        return dateComponentsFormatter.string(from: oldDate, to: newDate)!
    }
    
    func dateTimeIntervalSince1970() -> Date {
        let timeInterval = TimeInterval(self)!
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func urlLaunch() {
        guard let url = URL(string: self) else {
          return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension Date {
    func dateDifference() -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: self, to: Date())
        
        let seconds = difference.second ?? 0
        let minutes = difference.minute ?? 0
        let hours = difference.hour ?? 0
        let days = difference.day ?? 0
        let months = difference.month ?? 0
        let years = difference.year ?? 0
        
        if years > 0 {
            return "\(years) years"
        } else if months > 0 {
            return "\(months) months"
        } else if days > 0 {
            return "\(days) days"
        } else if hours > 0 {
            return "\(hours) hours"
        } else if minutes > 0 {
            return "\(minutes) minutes"
        } else if seconds > 0 {
            return "\(seconds) seconds"
        } else {
            return ""
        }
        
    }
    
}

extension Locale {
    static let currency: [String: (code: String?, symbol: String?, name: String?)] = isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol, locale.localizedString(forCurrencyCode: locale.currencyCode ?? ""))
    }
}

extension UIViewController {
    func showLoader() -> FActivityIndicatorView {
        let activityIndicatorView = FActivityIndicatorView(frame: CGRect ())
        self.view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])
        
        return activityIndicatorView
    }

    func hideLoader(_ activityIndicatorView: FActivityIndicatorView) {
        activityIndicatorView.removeFromSuperview()
    }

}

func getLocation(_ geoPoint: GeoPoint, completionHander: @escaping(Error, [CLPlacemark])->()) {
    let address = CLGeocoder.init()
    address.reverseGeocodeLocation(CLLocation.init(latitude: geoPoint.latitude, longitude: geoPoint.longitude)) { (places, error) in
        var errorGeo = NSError()
        var placesMark = [CLPlacemark]()
        
        if let error = error{
            errorGeo = error as NSError
        } else {
            if let place = places {
                placesMark = place
            }
        }
        
        completionHander(errorGeo, placesMark)
    }
}



extension UITextField {
    func leftPadding(_ padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func rightPadding(_ padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView {
    func leftPadding(_ padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
//        self.leftView = paddingView
//        self.leftViewMode = .always
    }
    
    func rightPadding(_ padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
//        self.rightView = paddingView
//        self.rightViewMode = .always
    }
}

extension UIViewController {
    func showToast(_ message: String) {
        let toast = SwiftToast(
            text: message,
            backgroundColor: UIColor.label,
            textColor: .systemBackground,
            font: UIFont (name: kFontMedium, size: 16)
        )
        self.present(toast, animated: true)
    }
}
