//
//  BannerTableViewCell.swift
//  DynamicTableView
//

//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    let bannerImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    func commonInit(){
        contentView.addSubview(bannerImageView)
 
        updateConstraints()
    }


    override func updateConstraints() {

        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            ])
        
        bannerImageView.image = #imageLiteral(resourceName: "SubsBanner")
        bannerImageView.contentMode = .scaleAspectFit
        super.updateConstraints()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
