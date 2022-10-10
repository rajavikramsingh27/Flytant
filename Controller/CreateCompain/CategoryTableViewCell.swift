


//  CategoryTableViewCell.swift
//  Flytant-1
//  Created by GranzaX on 03/03/22.


import UIKit


class CategoryTableViewCell_1: UITableViewCell {
    var viewContainer = UIView()
    var lblCategoryName = UILabel()
    var imgTick = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "category")
        
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
        viewContainer = {
            let view = UIView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let viewBottomLine = UIView()
            viewBottomLine.translatesAutoresizingMaskIntoConstraints = false
            viewBottomLine.backgroundColor = .gray
            view.addSubview(viewBottomLine)
            
            NSLayoutConstraint.activate([
                viewBottomLine.heightAnchor.constraint(equalToConstant: 1),
                viewBottomLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                viewBottomLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                viewBottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ])
            
            

            lblCategoryName = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
                
                label.text = "Category"
                label.textColor =  .label
                label.font = UIFont (name: kFontMedium, size: 16)
                
                NSLayoutConstraint.activate([
                    label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                    label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
                ])
                
                return label
            }()
            
            imgTick = {
                let image = UIImageView()
                image.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(image)
                image.image = UIImage (named: "check")
                
                NSLayoutConstraint.activate([
                    image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                    image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                    image.heightAnchor.constraint(equalToConstant: 20),
                    image.widthAnchor.constraint(equalToConstant: 20),
                ])
                
                return image
            }()
            
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }

    
}
