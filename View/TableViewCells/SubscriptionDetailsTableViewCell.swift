

//  SubscriptionDetailsTableViewCell.swift
//  Flytant-1
//  Created by GranzaX on 21/02/22.


import UIKit


var cellWidth = 0;



class SubscriptionDetailsTableViewCell: UITableViewCell {
    var viewBG:UIView!
    var lblPlan:UILabel!
    var lblRSDisable:UILabel!
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "SubscriptionDetails")
        
        self.contentView.backgroundColor = .clear
                
        viewBG = UIView(frame: CGRect (x: 0, y: 0, width: cellWidth, height: 70))
        viewBG.layer.cornerRadius = 4
        viewBG.layer.borderWidth = 1
        viewBG.clipsToBounds = true
        
        self.contentView.addSubview(viewBG)
        
        lblPlan = UILabel(frame: CGRect (x: 17, y: 10, width: viewBG.frame.size.width, height: 24))
        lblPlan.font = UIFont (name: kFontBold, size: 14)
        
        viewBG.addSubview(lblPlan)
        
        lblRSDisable = UILabel (frame: CGRect (
                                    x: 17,
                                    y: lblPlan.frame.origin.y+lblPlan.frame.size.height,
                                    width: viewBG.frame.size.width,
                                    height: 30))
        lblRSDisable.textColor = UIColor.init("979797")
        lblRSDisable.font = UIFont (name: kFontMedium, size: 14)
        
        viewBG.addSubview(lblRSDisable)
        
        lblPlan.text = "Price INR 49 / Monthly"
        lblRSDisable.text = "INR 149 / Monthly"
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
