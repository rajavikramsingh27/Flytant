//
//  CampaignImagesViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 03/03/22.
//

import UIKit

class CampaignImagesViewController: UIViewController {
    var navBar: UIView!
    var lblBottom = UILabel()
    var collImages: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        makeUI()
    }
    
    func makeUI() {
        setNavigationBar()
        bottomUI()
        collectionViewUI()
    }

    func setNavigationBar() {
        let screenSize = UIScreen.main.bounds
        
        let viewUpperNav: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(viewUpperNav)
        
        NSLayoutConstraint.activate([
            viewUpperNav.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            viewUpperNav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            viewUpperNav.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            viewUpperNav.heightAnchor.constraint(equalToConstant: CGFloat(sageAreaHeight()))
        ])
        
        
        navBar = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let btnBack: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .systemBackground
                button.setTitle("Cancel", for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.addTarget(self, action: #selector(btnCancel(_:)), for: .touchUpInside)
                button.titleLabel?.font = UIFont (name: kFontMedium, size: 18)

                return button
            }()
            
            view.addSubview(btnBack)
            
            NSLayoutConstraint.activate([
                btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
//                btnBack.widthAnchor.constraint(equalToConstant: 44),
                btnBack.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            let btnNext: UIButton = {
                let button = UIButton()
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .systemBackground
                button.setTitle("Next", for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.addTarget(self, action: #selector(btnNext(_:)), for: .touchUpInside)
                button.titleLabel?.font = UIFont (name: kFontMedium, size: 18)

                return button
            }()
                        
            NSLayoutConstraint.activate([
                btnNext.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                btnNext.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor, constant: 0),
                btnNext.heightAnchor.constraint(equalTo: btnBack.heightAnchor, constant: 0),
//                btnBack.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            return view
        }()
        
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: viewUpperNav.leftAnchor, constant: 0),
            navBar.topAnchor.constraint(equalTo: viewUpperNav.bottomAnchor, constant: 0),
            navBar.widthAnchor.constraint(equalToConstant: screenSize.width),
            navBar.heightAnchor.constraint(equalToConstant: CGFloat(44)),
        ])
                
    }
    
    func bottomUI() {
        lblBottom = {
            let label = UILabel()
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Click on image to apply filter"
            label.textColor = .gray
            label.font = UIFont (name: kFontMedium, size: 16)
            
            return label
        }()
        
        NSLayoutConstraint.activate([
            lblBottom.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            lblBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
    }
    
    func collectionViewUI() {
        
        collImages = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.itemSize = CGSize(width: 200, height: 200)
            layout.scrollDirection = .horizontal
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.collectionViewLayout = layout
            collectionView.register(CampaignImagesSelectedCollectionCell.self, forCellWithReuseIdentifier: "CampaignImage")
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .systemBackground
            collectionView.showsHorizontalScrollIndicator = false
            
            return collectionView
        }()
        
        view.addSubview(collImages)
        
        NSLayoutConstraint.activate([
            collImages.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            collImages.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            collImages.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            collImages.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}



extension CampaignImagesViewController {
    @IBAction func btnCancel(_ sender: UIButton) {
        arrImagesCampaign.removeAll()
        arrSelectedCategoryStore.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension CampaignImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImagesCampaign.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignImage", for: indexPath) as! CampaignImagesSelectedCollectionCell
        
        cell.imgUser.image = arrImagesCampaign[indexPath.row]
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(btnCancelImage(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func btnCancelImage(_ sender: UIButton) {
        arrImagesCampaign.remove(at: sender.tag)
        collImages.reloadData()
    }
    
}
