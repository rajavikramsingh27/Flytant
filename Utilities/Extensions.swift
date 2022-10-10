//
//  Extensions.swift
//  Flytant
//
//  Created by Vivek Rai on 29/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SDWebImage

fileprivate var containerView: UIView!

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
    
    func addBorder(color: UIColor, thickness: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
}

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
    
}

extension UIImageView {
    
    func setImage(image url: String?) {
        if let imageString = url, let URL = URL(string: imageString) {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: URL, completed: nil)
        }
    }
    
    func set_sdWebImage(With URLstring : String?, placeHolderImage: String)  {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let url = URLstring {
            let remove = url.removingPercentEncoding
            let strUrl = remove?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            self.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: placeHolderImage), options: [SDWebImageOptions.refreshCached, .retryFailed]) { (image, errorr, type, url) in
                if(errorr == nil) {
                    if type == SDImageCacheType.none || type == SDImageCacheType.disk {
                        UIView.transition(with: self, duration: 1.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                            self.image = nil
                            self.image = image
                            
                        }, completion: nil)
                    } else {
                        self.backgroundColor = UIColor.clear
                    }
                } else {
                    print(errorr ?? "")
                }
            }
        }
    }
    
}

extension UIApplication {
    public class func topViewController(_ base: UIViewController?) -> UIViewController? {
        
        var ba_se = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        
        if base != nil {
            ba_se = base
        }
        
        if let nav = ba_se as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = ba_se as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = ba_se?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
}

extension UIViewController {
    
    func showAlert(msg : String) {
        
        let alertVC = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
        }))
        
        present(alertVC, animated: true, completion: nil)
        
    }
    
    func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension UILabel {
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
  
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
   
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint(x: 0, y: 0)
        layer.cornerRadius = CGFloat(frame.width / 20)

        let color0 = UIColor(red:250/255, green:0/255, blue:102/255, alpha:1).cgColor
        let color1 = UIColor(red:212/255, green:24/255, blue: 114/255, alpha:0.1).cgColor
        let color2 = UIColor(red:164/255, green:69/255, blue: 178/255, alpha:0.1).cgColor
    

        layer.colors = [color0,color1,color2]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func setGradientBackground(color1: UIColor, color2: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 0.1]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackground(color1: UIColor, color2: UIColor, startPoint : CGPoint, endPoint : CGPoint){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 0.1]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    

    func pin(to view: UIView, insets: UIEdgeInsets = .init()) {
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
        ])
    }
    
    func pin(to layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .init()) {
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
        bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: insets.bottom),
        leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left),
        trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: insets.right),
        ])
    }
    
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        
       
        
    }
    
    ///calculate the height of the string
    func height(withConstraintWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    ///calculate the width of the string
    func width(withConstraintHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}

extension Date {
    
    func timeAgoToDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
    
}

extension UINavigationBar {
    
    func removeGradientBackground() {
        
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        if let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView {
            gradientView.removeFromSuperview()
        }
        
    }
    
    func setGradientBackground(colors: [UIColor],
                               startPoint: UINavigationBarGradientView.Point = .topLeft,
                               endPoint: UINavigationBarGradientView.Point = .bottomLeft,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, startPoint: startPoint,
                                                           endPoint: endPoint, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
}

class UINavigationBarGradientView: UIView {

    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custom(point: CGPoint)

        var point: CGPoint {
            switch self {
                case .topRight: return CGPoint(x: 1, y: 0)
                case .topLeft: return CGPoint(x: 0, y: 0)
                case .bottomRight: return CGPoint(x: 1, y: 1)
                case .bottomLeft: return CGPoint(x: 0, y: 1)
                case .custom(let point): return point
            }
        }
    }

    private weak var gradientLayer: CAGradientLayer!

    convenience init(colors: [UIColor], startPoint: Point = .topLeft,
                     endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        self.init(frame: .zero)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
        backgroundColor = .clear
    }

    func set(colors: [UIColor], startPoint: Point = .topLeft,
             endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.locations = locations
    }

    func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = frame
        superview?.addSubview(self)
    }
}

extension UILabel {

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}


extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
  

    func ImageViewRounded(cornerRadius:CGFloat) {

                  layer.borderWidth = 1
                  layer.masksToBounds = false
                  layer.borderColor = UIColor.clear.cgColor
                  layer.cornerRadius = cornerRadius
                  clipsToBounds = true
        }
   
}


extension UILabel {

    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:self.font])

        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

        return ceil(rect.size.height)
    }
    
  

}


extension UINavigationBar {

    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }

}


extension UIViewController {
    
    
    func createNavBar(navTitle : String ,isBack: Bool) -> UINavigationBar {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: getStatusBarHeight(), width: view.frame.size.width, height: 44))
        navBar.transparentNavigationBar()
        
        let navItem = UINavigationItem(title: navTitle)
        
        let titleAttributes = [
            NSAttributedString.Key.font: AppFont.font(type: .Bold, size: 22),NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        navBar.titleTextAttributes = titleAttributes
        
        if isBack == true{
            let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backImg"), style: .plain, target: self, action:#selector(dismissw))
            backButtonItem.tintColor = UIColor.label
            navItem.leftBarButtonItem = backButtonItem
        }
        
     
        navBar.setItems([navItem], animated: false)
        
        
        return navBar
        
    }
    
    
    @objc func dismissw(){
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       
        
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 35
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}


func getsafeBottomHeight() -> CGFloat{
    var safeBottomHeight: CGFloat = 0
  
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       
        
        safeBottomHeight = window?.safeAreaInsets.bottom ?? 0
    } else {
        safeBottomHeight = UIApplication.shared.keyWindow?.window?.safeAreaInsets.bottom ?? 0
    }
    
    return safeBottomHeight
}



extension UILabel {
    //x was -2
    func add(image: UIImage, text: String, isLeading: Bool = true, imageBounds: CGRect = CGRect(x: 0, y: -1.5, width: 10, height: 10)) {
        let imageAttachment = NSTextAttachment()
     
        imageAttachment.bounds = imageBounds
       
        imageAttachment.image = image
      
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let string = NSMutableAttributedString(string: text)
        
        let mutableAttributedString = NSMutableAttributedString()
 
        if isLeading {
            mutableAttributedString.append(attachmentString)
            mutableAttributedString.append(string)
            attributedText = mutableAttributedString
        } else {
            string.append(attachmentString)
            attributedText = string
        }
    }
    }
extension UITableView {

    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


