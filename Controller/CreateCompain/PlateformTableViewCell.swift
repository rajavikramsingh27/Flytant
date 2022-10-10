//
//  PlateformTableViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 02/03/22.
//

import UIKit

class PlateformTableViewCell: UITableViewCell {
    var viewContainer = UIView()
    var lblACount = UILabel()
    var lblPlateform = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "topStories")
        
        viewContainer = {
            let view = UIView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 4
            view.clipsToBounds = true
            
            view.addSubview(lblACount)
            lblACount.translatesAutoresizingMaskIntoConstraints = false
            lblACount.textAlignment = .center
            lblACount.font = UIFont (name: kFontMedium, size: 20)
            lblACount.layer.borderWidth = 1
            lblACount.layer.cornerRadius = 4
            lblACount.clipsToBounds = true
            lblACount.text = "A"
            
            lblACount.textColor = .label
            lblACount.backgroundColor = .red
            
            NSLayoutConstraint.activate([
                lblACount.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                lblACount.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                lblACount.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                lblACount.widthAnchor.constraint(equalTo: lblACount.heightAnchor, constant: 0),
            ])
            
            view.addSubview(lblPlateform)
            lblPlateform.translatesAutoresizingMaskIntoConstraints = false
            lblPlateform.textAlignment = .left
            lblPlateform.font = UIFont (name: kFontMedium, size: 16)
            lblPlateform.text = "Instagram"
            lblPlateform.textColor = .label
            
            NSLayoutConstraint.activate([
                lblPlateform.leftAnchor.constraint(equalTo: lblACount.rightAnchor, constant: 10),
                lblPlateform.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10),
                lblPlateform.centerYAnchor.constraint(equalTo: lblACount.centerYAnchor, constant: 0),
            ])
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            viewContainer.widthAnchor.constraint(equalToConstant: 200),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
        
        setUI()
        
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
    
    func setUI() {
        
    }

    
}
