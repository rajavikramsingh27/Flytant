//
//  TopStoriesTableViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 28/02/22.
//

import UIKit

class TopStoriesTableViewCell: UITableViewCell {
    var viewContainer = UIView()
    
    var imgBlog = UIImageView()
    var lblTitle = UILabel()
    var lblTime = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "topStories")
        
        contentView.addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        setUI()
        
    }
    
    func setUI() {
        imgBlog.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(imgBlog)
        imgBlog.image = UIImage (named: "logoDefault")
        imgBlog.layer.cornerRadius = 4
        imgBlog.clipsToBounds = true
        
        
        NSLayoutConstraint.activate([
            imgBlog.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            imgBlog.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            imgBlog.heightAnchor.constraint(equalTo: viewContainer.heightAnchor, constant: 0),
            imgBlog.widthAnchor.constraint(equalTo: viewContainer.heightAnchor, constant: 0),
        ])
        
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(lblTitle)
        lblTitle.text = "How Big is the influencer marketing industry ?"
        lblTitle.textColor = .label
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont (name: "RoundedMplus1c-Medium", size: 15)
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
            lblTitle.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            lblTitle.rightAnchor.constraint(equalTo: imgBlog.leftAnchor, constant: -16),
        ])
        
        let imgTime = UIImageView()
        imgTime.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(imgTime)
        imgTime.image = UIImage (named: "history_subscription")
        imgTime.layer.cornerRadius = 4
        imgTime.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imgTime.leftAnchor.constraint(equalTo: lblTitle.leftAnchor, constant: 0),
            imgTime.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            imgTime.heightAnchor.constraint(equalToConstant: 20),
            imgTime.widthAnchor.constraint(equalToConstant: 20),
        ])
        
        
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(lblTime)
        lblTime.text = "1 Months ago"
        lblTime.textColor = .gray
        lblTime.font = UIFont (name: "RoundedMplus1c-Medium", size: 14)
        
        NSLayoutConstraint.activate([
            lblTime.centerYAnchor.constraint(equalTo: imgTime.centerYAnchor, constant: 0),
            lblTime.leftAnchor.constraint(equalTo: imgTime.rightAnchor, constant: 6),
        ])
        
    }
    
    func setData(_ dictDetails: [String: Any]) {
        imgBlog.sd_setImage(with: URL(string: "\(dictDetails["imageUrl"]!)"), placeholderImage: UIImage(named: "logoDefault"))
        lblTitle.text = "\(dictDetails["title"]!)"
        lblTime.text = "\(dictDetails["creationDate"]!)".dateTimeIntervalSince1970().dateDifference()+" ago"
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
