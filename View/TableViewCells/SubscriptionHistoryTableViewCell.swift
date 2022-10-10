//
//  SubscriptionHistoryTableViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 21/02/22.
//

import UIKit

class SubscriptionHistoryTableViewCell: UITableViewCell {
    var viewBG:UIView!
    
    let viewBGWidth = Int(UIScreen.main.bounds.width)-32
        
    var lblPlanType:UILabel!
    var lblPlanTime:UILabel!
    var lblPlanPrice:UILabel!
    var lblPlanFrom:UILabel!
    var lblPlanTo:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "SubscriptionDetails")
        
        print(viewBGWidth)
        
        self.contentView.backgroundColor = .clear
        
        viewBG = UIView(frame: CGRect (x: 16, y: 5, width: viewBGWidth, height: cellHistoryHeight))
        
        viewBG.defaultShadow()
        
        self.contentView.addSubview(viewBG)
        
        lblPlanType = UILabel(frame: CGRect (x: 16, y: 30, width: viewBG.frame.size.width, height: 20))
        lblPlanType.font = UIFont (name: kFontBold, size: 16)
        lblPlanType.textColor = .label
        viewBG.addSubview(lblPlanType)
        
        let lblPlanTimeOriginY = lblPlanType.frame.origin.y+lblPlanType.frame.size.height+16
        lblPlanTime = UILabel(frame: CGRect (
                                    x: 16,
                                    y: Int(lblPlanTimeOriginY),
                                    width: viewBGWidth/2,
                                    height: 20))
        lblPlanTime.font = UIFont (name: kFontBold, size: 16)
        
        lblPlanTime.textColor = .label
        viewBG.addSubview(lblPlanTime)
        
        lblPlanPrice = UILabel(frame: CGRect (
                                    x: viewBGWidth/2,
                                    y: Int(lblPlanTimeOriginY),
                                    width: viewBGWidth/2-16,
                                    height: 20))
        lblPlanPrice.font = UIFont (name: kFontBold, size: 16)
        lblPlanPrice.textAlignment = .right
        lblPlanPrice.textColor = .label
        viewBG.addSubview(lblPlanPrice)
        
        let lblPlanTimeFromTo = lblPlanPrice.frame.origin.y+lblPlanPrice.frame.size.height+16
        lblPlanFrom = UILabel(frame: CGRect (
                                    x: 16,
                                    y: Int(lblPlanTimeFromTo),
                                    width: viewBGWidth/2,
                                    height: 20))
        lblPlanFrom.font = UIFont (name: kFontBold, size: 16)
        lblPlanFrom.textColor = .label
        viewBG.addSubview(lblPlanFrom)
        
        lblPlanTo = UILabel(frame: CGRect (
                                    x: viewBGWidth/2,
                                    y: Int(lblPlanTimeFromTo),
                                    width: viewBGWidth/2-16,
                                    height: 20))
        lblPlanTo.font = UIFont (name: kFontBold, size: 16)
        lblPlanTo.textAlignment = .right
        lblPlanTo.textColor = .label
        viewBG.addSubview(lblPlanTo)
    }
    
    func setUI(_ dictDetails:[String: Any]) {
        lblPlanType.text = "\(dictDetails["plan"] ?? "")"
        lblPlanPrice.text = "Price: \(dictDetails["price"] ?? "")"
        
        let strOrderDate = "\(dictDetails["orderDate"] ?? "")"
        let timeInterval = TimeInterval(strOrderDate)!
        let orderDate = Date(timeIntervalSince1970: timeInterval)
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        
        lblPlanFrom.text = "From: "+dateformat.string(from: orderDate)
        
        let strSubscriptionDays = "\(dictDetails["subscriptionDays"] ?? "")"
        let finalOrderDate = Calendar.current.date(byAdding: .day, value: Int(strSubscriptionDays)!, to: orderDate)
        lblPlanTo.text = "To: "+dateformat.string(from: finalOrderDate!)
        
        let dateComponentsFormatter = DateComponentsFormatter()
        let differenceDate = dateComponentsFormatter.difference(from: orderDate, to: finalOrderDate!)
        
        lblPlanTime.text = differenceDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}
