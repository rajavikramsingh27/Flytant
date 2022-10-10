//
//  VideosCollectionViewCell.swift
//  Flytant-1
//
//  Created by GranzaX on 28/02/22.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {
    let btnPlay = UIButton()
    var lblTitle = UILabel()
    var imgThumbnail = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let viewContainer: UIView = {
            let viewContainer = UIView()
            viewContainer.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.backgroundColor = .systemBackground
//            viewContainer.backgroundColor = .red
                        
            lblTitle.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(lblTitle)
            lblTitle.numberOfLines = 2
            lblTitle.text = "What is NFT ? Understand NFTs Completly"
            lblTitle.textColor = .label
            lblTitle.font = UIFont (name: "RoundedMplus1c-Bold", size: 13)
            

            NSLayoutConstraint.activate([
                lblTitle.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
                lblTitle.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                lblTitle.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
                lblTitle.heightAnchor.constraint(equalToConstant: 40),
            ])
            
            imgThumbnail.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(imgThumbnail)
            imgThumbnail.image = UIImage (named: "logoDefault")
            imgThumbnail.layer.cornerRadius = 16
            imgThumbnail.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                imgThumbnail.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
                imgThumbnail.bottomAnchor.constraint(equalTo: lblTitle.topAnchor, constant: -6),
                imgThumbnail.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                imgThumbnail.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            ])
            
            btnPlay.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(btnPlay)
//            btnPlay.backgroundColor = .red
            
            NSLayoutConstraint.activate([
                btnPlay.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
                btnPlay.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
                btnPlay.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
                btnPlay.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            ])
            
            let imgPlay = UIImageView()
            imgPlay.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(imgPlay)
            imgPlay.image = UIImage (named: "playicon")
            
            NSLayoutConstraint.activate([
                imgPlay.centerXAnchor.constraint(equalTo: imgThumbnail.centerXAnchor, constant: 0),
                imgPlay.centerYAnchor.constraint(equalTo: imgThumbnail.centerYAnchor, constant: 0),
                imgPlay.heightAnchor.constraint(equalToConstant: 40),
                imgPlay.widthAnchor.constraint(equalToConstant: 40),
            ])
            
            return viewContainer
        }()
        
        self.contentView.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
    }
    
    func setData(_ dictDetails: [String: Any]) {
        if let dictSnippet = dictDetails["snippet"] as? [String: Any] {
            lblTitle.text = "\(dictSnippet["title"]!)"
                        
            if let dictThumbnails = dictSnippet["thumbnails"] as? [String: Any] {
                if let dictMedium = dictThumbnails["medium"] as? [String: Any] {
                    if let url = dictMedium["url"] as? String {
                        imgThumbnail.sd_setImage(
                            with: URL(string: url),
                            placeholderImage: UIImage(named: "logoDefault")
                        )
                    } else {
                        imgThumbnail.image = UIImage (named: "logoDefault")
                    }
                } else {
                    imgThumbnail.image = UIImage (named: "logoDefault")
                }
            } else {
                imgThumbnail.image = UIImage (named: "logoDefault")
            }

        } else {
            lblTitle.text = ""
        }
    }
    
}
