//
//  CreateCompainViewC_1.swift
//  Flytant-1
//
//  Created by GranzaX on 02/03/22.
//

import UIKit
import OpalImagePicker
import Photos
import PhotosUI



var arrImagesCampaign = [UIImage]()
var categorySelected: String = ""

class CreateCompainViewC_1: UIViewController {
    var navBar: UIView!
    var scrollView: UIScrollView!
    var viewContainer: UIView!
    let btnNext = UIButton()
    let btnPrevious = UIButton()
    
    let viewCompain_1 = UIView()
    let viewCompain_2 = UIView()
    let viewCompain_3 = UIView()
    var viewCompain_4 = UIView()
    let viewCompain_5 = UIView()
    let viewCompain_6 = UIView()
    let viewCompain_7 = UIView()
    let viewCompain_8 = UIView()
    var viewCompain_9 = UIView()
    
    let tblPlateform = UITableView()
    var pickerGender: UIPickerView!
    var viewPickerContainer = UIView()
    var lblGenterType = UILabel()
    var lblCategory = UILabel()
    
    let txtCampaignName = UITextField()
    let txtCampaignDesc = UITextView()
    var collImages: UICollectionView!
    let txtCampaignMinFollowers = UITextField()
    let txtPrice = UITextField()
    
    let txtGiveAwayProductDesc = UITextView()
    
    var btnCampaignName = UIButton()
    var btnCampaignDescribe = UIButton()
    var btnCampaignImages = UIButton()
    var btnCampaignProductPay = UIButton()
    var btnCampaignPlateform = UIButton()
    var btnCampaignFollowers = UIButton()
    var btnCampaignAudience = UIButton()
    var btnCampaignCategory = UIButton()
    
    var comapaignViewNumber = 1
    
    var arrPlateformSelect = [Bool]()
    let arrGenders = ["Select Gender", "Male", "Female", "Any"]
    
    let arrPlateformTitles = ["Instagram", "Youtube", "Facebook", "Twitter", "Linkedin", ]
    let arrPlateformChars = ["A", "B", "C", "D", "E", ]
    
    var indexProductPay = 0
    
    var btnProduct: UIButton!
    var lblA = UILabel()
    var lblProduct = UILabel()
    
    var btnPayInfluencers: UIButton!
    var lblB = UILabel()
    var lblInfluencers = UILabel()
    
    var viewPricing: UIView!
    var heightPricing: NSLayoutConstraint!
    
    var viewProductPay: UIView!
    var heightGiveAwayProduct: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        makeUI()
        pickerUI()
        viewPickerContainer.isHidden = true
        
        for _ in 0..<arrPlateformTitles.count {
            arrPlateformSelect.append(false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategory), name: NSNotification.Name(rawValue: "setSelectedCategory"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collImages.reloadData()
        if arrImagesCampaign.isEmpty {
            btnCampaignImages.backgroundColor = .gray
        } else {
            btnCampaignImages.backgroundColor = .label
        }
        
    }
    
    func makeUI() {
        setNavigationBar()
        bottomArrows()
        scrollUI()
        setCompainUI_1()
        setCompainUI_2()
        setCompainUI_3()
        setCompainUI_4()
        setCompainUI_5()
        setCompainUI_6()
        setCompainUI_7()
        setCompainUI_8()
        setCompainUI_9()
        showHiddenView()
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
            
            let labelTitle = UILabel()
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelTitle.text = "Create Campaign"
            labelTitle.textColor =  .label
            labelTitle.font = UIFont (name: kFontBold, size: 20)

            view.addSubview(labelTitle)
            
            NSLayoutConstraint.activate([
                labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                labelTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
            
            let btnBack: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .systemBackground
                button.setImage(UIImage (named: "back_subscription"), for: .normal)
                button.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)

                return button
            }()

            view.addSubview(btnBack)

            NSLayoutConstraint.activate([
                btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                btnBack.widthAnchor.constraint(equalToConstant: 44),
                btnBack.heightAnchor.constraint(equalToConstant: 44),
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
    
    func bottomArrows() {
        
        self.view.addSubview(btnNext)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        btnNext.backgroundColor = .label
        btnNext.setImage(UIImage (named: "arrowDown"), for: .normal)
        btnNext.layer.cornerRadius = 4
        btnNext.clipsToBounds = true
        btnNext.tag = 1
        btnNext.addTarget(self, action: #selector(btnNext(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            btnNext.heightAnchor.constraint(equalToConstant: 44),
            btnNext.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        
        self.view.addSubview(btnPrevious)
        btnPrevious.translatesAutoresizingMaskIntoConstraints = false
        btnPrevious.backgroundColor = .label
        btnPrevious.setImage(UIImage (named: "arrowUp"), for: .normal)
        btnPrevious.layer.cornerRadius = 4
        btnPrevious.clipsToBounds = true
        btnPrevious.addTarget(self, action: #selector(btnPrevious(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            btnPrevious.rightAnchor.constraint(equalTo: btnNext.leftAnchor, constant: -10),
            btnPrevious.bottomAnchor.constraint(equalTo: btnNext.bottomAnchor, constant: 0),
            btnPrevious.heightAnchor.constraint(equalToConstant: 44),
            btnPrevious.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func scrollUI() {
        scrollView = {
            let scroll = UIScrollView()
            scroll.translatesAutoresizingMaskIntoConstraints = false
            return scroll
        }()

        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: btnNext.topAnchor, constant: 0),
        ])
        
        viewContainer = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        scrollView.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            viewContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
            viewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            viewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            viewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            viewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0),
//            viewContainer.heightAnchor.constraint(equalToConstant: 1000),
        ])
        
    }
    
    func setCompainUI_1() {
        viewContainer.addSubview(viewCompain_1)
        viewCompain_1.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What's your campaign name?"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)
        
        viewCompain_1.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_1.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_1.topAnchor, constant: 0),
        ])
        
        viewCompain_1.addSubview(txtCampaignName)
        txtCampaignName.translatesAutoresizingMaskIntoConstraints = false
        txtCampaignName.tag = 1
        txtCampaignName.addTarget(self, action: #selector(textFieldChanging(_:)), for: .editingChanged)
        
        txtCampaignName.layer.borderWidth = 1
        txtCampaignName.layer.borderColor = UIColor.label.cgColor
        txtCampaignName.layer.cornerRadius = 6
        txtCampaignName.clipsToBounds = true
        
        txtCampaignName.placeholder = "Campaign name"
        txtCampaignName.font = UIFont (name: kFontMedium, size: 18)
        txtCampaignName.textColor = .label
        txtCampaignName.leftPadding(16)
        txtCampaignName.rightPadding(16)
        
        NSLayoutConstraint.activate([
            txtCampaignName.leftAnchor.constraint(equalTo: viewCompain_1.leftAnchor, constant: 0),
            txtCampaignName.rightAnchor.constraint(equalTo: viewCompain_1.rightAnchor, constant: 0),
            txtCampaignName.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            txtCampaignName.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let imageTick = UIImageView()
        
        btnCampaignName = {
            let button = UIButton()
            viewCompain_1.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 1
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_1.addSubview(btnCampaignName)
        
        NSLayoutConstraint.activate([
            btnCampaignName.leftAnchor.constraint(equalTo: viewCompain_1.leftAnchor, constant: 0),
            btnCampaignName.topAnchor.constraint(equalTo: txtCampaignName.bottomAnchor, constant: 16),
            btnCampaignName.heightAnchor.constraint(equalToConstant: 50),
//            btnCampaignName.widthAnchor.constraint(equalToConstant: 120)
            imageTick.rightAnchor.constraint(equalTo: btnCampaignName.rightAnchor, constant: -10),
        ])
                
        NSLayoutConstraint.activate([
            viewCompain_1.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_1.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_1.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_1.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_1.bottomAnchor.constraint(equalTo: btnCampaignName.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_2() {
        viewContainer.addSubview(viewCompain_2)
        viewCompain_2.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Describe your campaign"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)

        viewCompain_2.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_2.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_2.topAnchor, constant: 0),
        ])
        
        viewCompain_2.addSubview(txtCampaignDesc)
        txtCampaignDesc.translatesAutoresizingMaskIntoConstraints = false
        txtCampaignDesc.text = "Describe here"
        txtCampaignDesc.textColor = .gray
        txtCampaignDesc.layer.borderWidth = 1
        txtCampaignDesc.layer.borderColor = UIColor.label.cgColor
        txtCampaignDesc.layer.cornerRadius = 6
        txtCampaignDesc.clipsToBounds = true
        txtCampaignDesc.font = UIFont (name: kFontMedium, size: 18)
        txtCampaignDesc.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        txtCampaignDesc.delegate = self
        
        NSLayoutConstraint.activate([
            txtCampaignDesc.leftAnchor.constraint(equalTo: viewCompain_2.leftAnchor, constant: 0),
            txtCampaignDesc.rightAnchor.constraint(equalTo: viewCompain_2.rightAnchor, constant: 0),
            txtCampaignDesc.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            txtCampaignDesc.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let imageTick = UIImageView()
        
        btnCampaignDescribe = {
            let button = UIButton()
            viewCompain_2.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 2
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_2.addSubview(btnCampaignDescribe)
        
        NSLayoutConstraint.activate([
            btnCampaignDescribe.leftAnchor.constraint(equalTo: viewCompain_2.leftAnchor, constant: 0),
            btnCampaignDescribe.topAnchor.constraint(equalTo: txtCampaignDesc.bottomAnchor, constant: 16),
            btnCampaignDescribe.heightAnchor.constraint(equalToConstant: 50),
            imageTick.rightAnchor.constraint(equalTo: btnCampaignDescribe.rightAnchor, constant: -10),
        ])
                        
        NSLayoutConstraint.activate([
            viewCompain_2.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_2.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_2.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_2.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_2.bottomAnchor.constraint(equalTo: btnCampaignDescribe.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_3() {
        viewContainer.addSubview(viewCompain_3)
        viewCompain_3.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        viewCompain_3.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please select images"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)

        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_3.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_3.topAnchor, constant: 0),
        ])
        
        var viewCollection = UIView()
        
        viewCollection = {
            let view = UIView()
            viewCompain_3.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            
            let btnAdd = UIButton()
            view.addSubview(btnAdd)
            btnAdd.translatesAutoresizingMaskIntoConstraints = false
            btnAdd.backgroundColor = .lightGray
            btnAdd.setBackgroundImage(UIImage (named: "addIcons"), for: .normal)
            btnAdd.addTarget(self, action: #selector(btnAddIcon(_:)), for: .touchUpInside)
//            btnAdd.image = UIImage (named: "addIcons")
            btnAdd.layer.cornerRadius = 4
            btnAdd.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                btnAdd.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnAdd.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
                btnAdd.widthAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
                btnAdd.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            ])
            
            collImages = {
                let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.scrollDirection = .horizontal
                
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                collectionView.collectionViewLayout = layout
                collectionView.register(CampaignImageCollectionCell.self, forCellWithReuseIdentifier: "CampaignImage")
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.backgroundColor = .systemBackground
                collectionView.showsHorizontalScrollIndicator = false
                
                return collectionView
            }()
            
            view.addSubview(collImages)
            
            NSLayoutConstraint.activate([
                collImages.leftAnchor.constraint(equalTo: btnAdd.rightAnchor, constant: 6),
                collImages.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                collImages.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
                collImages.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            ])
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewCollection.leftAnchor.constraint(equalTo: viewCompain_3.leftAnchor, constant: 0),
            viewCollection.rightAnchor.constraint(equalTo: viewCompain_3.rightAnchor, constant: 0),
            viewCollection.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            viewCollection.heightAnchor.constraint(equalToConstant: 100)
        ])
        

        let imageTick = UIImageView()
        btnCampaignImages = {
            let button = UIButton()
            viewCompain_3.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 3
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_3.addSubview(btnCampaignImages)
        
        NSLayoutConstraint.activate([
            btnCampaignImages.leftAnchor.constraint(equalTo: viewCompain_3.leftAnchor, constant: 0),
            btnCampaignImages.topAnchor.constraint(equalTo: viewCollection.bottomAnchor, constant: 16),
            btnCampaignImages.heightAnchor.constraint(equalToConstant: 50),
            imageTick.rightAnchor.constraint(equalTo: btnCampaignImages.rightAnchor, constant: -10),
        ])
                        
        NSLayoutConstraint.activate([
            viewCompain_3.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_3.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            viewCompain_3.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_3.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_3.bottomAnchor.constraint(equalTo: btnCampaignImages.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_4() {
//        viewCompain_4.backgroundColor = .red
        let imageTick = UIImageView()
        var viewTextField: UIView!
        
        
        viewCompain_4 = {
            let view = UIView()
            viewContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Do you want to: "
            label.textColor =  .gray
            label.font = UIFont (name: kFontMedium, size: 18)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            ])
            
            btnProduct = {
                let buttonP = UIButton()
                view.addSubview(buttonP)
                buttonP.translatesAutoresizingMaskIntoConstraints = false
                buttonP.backgroundColor = .systemBackground
                buttonP.addTarget(self, action: #selector(btnGiveAwayProduct(_:)), for: .touchUpInside)
                buttonP.layer.borderWidth = 1
                buttonP.layer.cornerRadius = 4
                buttonP.clipsToBounds = true
                
                buttonP.addSubview(lblA)
                lblA.translatesAutoresizingMaskIntoConstraints = false
                lblA.textAlignment = .center
                lblA.font = UIFont (name: kFontMedium, size: 18)
                lblA.layer.borderWidth = 1
                lblA.layer.cornerRadius = 4
                lblA.clipsToBounds = true
                lblA.text = "A"
                
                NSLayoutConstraint.activate([
                    lblA.topAnchor.constraint(equalTo: buttonP.topAnchor, constant: 10),
                    lblA.bottomAnchor.constraint(equalTo: buttonP.bottomAnchor, constant: -10),
                    lblA.leftAnchor.constraint(equalTo: buttonP.leftAnchor, constant: 10),
                    lblA.widthAnchor.constraint(equalTo: lblA.heightAnchor, constant: 0),
                ])
                
                buttonP.addSubview(lblProduct)
                lblProduct.translatesAutoresizingMaskIntoConstraints = false
                lblProduct.textAlignment = .left
                lblProduct.font = UIFont (name: kFontMedium, size: 18)
                lblProduct.text = "Giveaway Product"
                lblProduct.textColor = (indexProductPay == 1) ? .systemBackground : .label
                
                NSLayoutConstraint.activate([
                    lblProduct.leftAnchor.constraint(equalTo: lblA.rightAnchor, constant: 10),
                    lblProduct.rightAnchor.constraint(equalTo: buttonP.rightAnchor, constant: 10),
                    lblProduct.centerYAnchor.constraint(equalTo: lblA.centerYAnchor, constant: 0),
                ])
                
                return buttonP
            }()
            
            NSLayoutConstraint.activate([
                btnProduct.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnProduct.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                btnProduct.widthAnchor.constraint(equalToConstant: 220),
                btnProduct.heightAnchor.constraint(equalToConstant: 54),
            ])
            
            
//            TODO: GiveAway Product
            
            viewProductPay = {
                let viewPriceDetails = UIView()
                view.addSubview(viewPriceDetails)
                viewPriceDetails.translatesAutoresizingMaskIntoConstraints = false
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Describe your give away:"
                label.textColor =  .gray
                label.font = UIFont (name: kFontMedium, size: 18)
                
                viewPriceDetails.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.leftAnchor.constraint(equalTo: viewPriceDetails.leftAnchor, constant: 0),
                    label.topAnchor.constraint(equalTo: viewPriceDetails.topAnchor, constant: 16),
                ])
                
                viewPriceDetails.addSubview(txtGiveAwayProductDesc)
                txtGiveAwayProductDesc.translatesAutoresizingMaskIntoConstraints = false
                txtGiveAwayProductDesc.text = "Describe here"
                txtGiveAwayProductDesc.textColor = .gray
                txtGiveAwayProductDesc.layer.borderWidth = 1
                txtGiveAwayProductDesc.layer.borderColor = UIColor.label.cgColor
                txtGiveAwayProductDesc.layer.cornerRadius = 6
                txtGiveAwayProductDesc.clipsToBounds = true
                txtGiveAwayProductDesc.font = UIFont (name: kFontMedium, size: 18)
                txtGiveAwayProductDesc.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                txtGiveAwayProductDesc.delegate = self
                
                NSLayoutConstraint.activate([
                    txtGiveAwayProductDesc.leftAnchor.constraint(equalTo: viewPriceDetails.leftAnchor, constant: 0),
                    txtGiveAwayProductDesc.rightAnchor.constraint(equalTo: viewPriceDetails.rightAnchor, constant: 0),
                    txtGiveAwayProductDesc.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                    txtGiveAwayProductDesc.bottomAnchor.constraint(equalTo: viewPriceDetails.bottomAnchor, constant: 0),

//                    txtGiveAwayProductDesc.heightAnchor.constraint(equalToConstant: 200),
//                    txtGiveAwayProductDesc.heightAnchor.constraint(equalTo: viewGiveAwayProduct.heightAnchor, constant: 16),
                ])
                
                return viewPriceDetails
            }()
            
            NSLayoutConstraint.activate([
                viewProductPay.topAnchor.constraint(equalTo: btnProduct.bottomAnchor, constant: 0),
                viewProductPay.leftAnchor.constraint(equalTo: btnProduct.leftAnchor, constant: 0),
                viewProductPay.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            ])
            
            heightGiveAwayProduct = viewProductPay.heightAnchor.constraint(equalToConstant: 0)
            heightGiveAwayProduct.isActive = true
            viewProductPay.isHidden = true
            
            btnPayInfluencers = {
                let buttonPay = UIButton()
                view.addSubview(buttonPay)
                buttonPay.translatesAutoresizingMaskIntoConstraints = false
                buttonPay.backgroundColor = .systemBackground
                buttonPay.addTarget(self, action: #selector(btnPayInfluencers(_:)), for: .touchUpInside)
                buttonPay.layer.borderWidth = 1
                buttonPay.layer.borderColor = UIColor.label.cgColor
                buttonPay.layer.cornerRadius = 4
                buttonPay.clipsToBounds = true
                
                buttonPay.addSubview(lblB)
                lblB.translatesAutoresizingMaskIntoConstraints = false
                lblB.textAlignment = .center
                lblB.font = UIFont (name: kFontMedium, size: 18)
                lblB.layer.borderWidth = 1
                lblB.layer.cornerRadius = 4
                lblB.clipsToBounds = true
                lblB.text = "B"
                
                lblB.textColor = .label

                NSLayoutConstraint.activate([
                    lblB.topAnchor.constraint(equalTo: buttonPay.topAnchor, constant: 10),
                    lblB.bottomAnchor.constraint(equalTo: buttonPay.bottomAnchor, constant: -10),
                    lblB.leftAnchor.constraint(equalTo: buttonPay.leftAnchor, constant: 10),
                    lblB.widthAnchor.constraint(equalTo: lblB.heightAnchor, constant: 0),
                ])
                
                buttonPay.addSubview(lblInfluencers)
                lblInfluencers.translatesAutoresizingMaskIntoConstraints = false
                lblInfluencers.textAlignment = .left
                lblInfluencers.font = UIFont (name: kFontMedium, size: 18)
                lblInfluencers.text = "Pay Influencers"
                lblInfluencers.textColor = .label
                
                NSLayoutConstraint.activate([
                    lblInfluencers.leftAnchor.constraint(equalTo: lblB.rightAnchor, constant: 10),
                    lblInfluencers.rightAnchor.constraint(equalTo: buttonPay.rightAnchor, constant: 10),
                    lblInfluencers.centerYAnchor.constraint(equalTo: lblB.centerYAnchor, constant: 0),
                ])
                
                return buttonPay
            }()
            
            NSLayoutConstraint.activate([
                            btnPayInfluencers.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                            btnPayInfluencers.topAnchor.constraint(equalTo: viewProductPay.bottomAnchor, constant: 10),
                            btnPayInfluencers.widthAnchor.constraint(equalToConstant: 200),
                            btnPayInfluencers.heightAnchor.constraint(equalToConstant: 54),
            ])
            
            viewPricing = {
                let viewPriceDetails = UIView()
                view.addSubview(viewPriceDetails)
                viewPriceDetails.translatesAutoresizingMaskIntoConstraints = false
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Enter the pricing."
                label.textColor =  .gray
                label.font = UIFont (name: kFontMedium, size: 18)
                
                viewPriceDetails.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.leftAnchor.constraint(equalTo: viewPriceDetails.leftAnchor, constant: 0),
                    label.topAnchor.constraint(equalTo: viewPriceDetails.topAnchor, constant: 16),
                ])
                
                viewTextField = {
                    let viewTF = UIView()
                    viewPriceDetails.addSubview(viewTF)
                    viewTF.translatesAutoresizingMaskIntoConstraints = false
                    
                    viewTF.layer.borderWidth = 1
                    viewTF.layer.borderColor = UIColor.label.cgColor
                    viewTF.layer.cornerRadius = 6
                    viewTF.clipsToBounds = true
                    
                    let lbl_$ = UILabel()
                    viewTF.addSubview(lbl_$)
                    lbl_$.translatesAutoresizingMaskIntoConstraints = false
                    lbl_$.text = "$"
                    lbl_$.textColor =  .gray
                    lbl_$.font = UIFont (name: kFontMedium, size: 18)
                        
                    NSLayoutConstraint.activate([
                        lbl_$.leftAnchor.constraint(equalTo: viewTF.leftAnchor, constant: 16),
                        lbl_$.centerYAnchor.constraint(equalTo: viewTF.centerYAnchor, constant: 0),
                        lbl_$.heightAnchor.constraint(equalTo: viewTF.heightAnchor, constant: 0),
                        lbl_$.widthAnchor.constraint(equalToConstant: 16),
                    ])
                    
                    txtPrice.translatesAutoresizingMaskIntoConstraints = false
                    txtPrice.tag = 2
                    txtPrice.addTarget(self, action: #selector(textFieldChanging(_:)), for: .editingChanged)

                    viewTF.addSubview(txtPrice)
                    txtPrice.clipsToBounds = true
                    txtPrice.keyboardType = .numberPad
                    
                    txtPrice.placeholder = "Enter Price"
                    txtPrice.font = UIFont (name: kFontMedium, size: 18)
                    txtPrice.textColor = .label
//                    txtPrice.leftPadding(16)
                    txtPrice.rightPadding(16)
                    
                    NSLayoutConstraint.activate([
                        txtPrice.leftAnchor.constraint(equalTo: lbl_$.rightAnchor, constant: 0),
                        txtPrice.rightAnchor.constraint(equalTo: viewTF.rightAnchor, constant: 0),
                        txtPrice.heightAnchor.constraint(equalTo: viewTF.heightAnchor, constant: 0),
                        txtPrice.centerYAnchor.constraint(equalTo: lbl_$.centerYAnchor, constant: 0),
//                        txtPrice.bottomAnchor.constraint(equalTo: viewTF.bottomAnchor, constant: 0),
//                        txtPrice.topAnchor.constraint(equalTo: viewTF.topAnchor, constant: 0),
                    ])
                    
                    
                    return viewTF
                }()
//                viewTextField
                NSLayoutConstraint.activate([
                    viewTextField.leftAnchor.constraint(equalTo: viewPriceDetails.leftAnchor, constant: 0),
                    viewTextField.rightAnchor.constraint(equalTo: viewPriceDetails.rightAnchor, constant: 0),
                    viewTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                    viewTextField.heightAnchor.constraint(equalToConstant: 50)
                ])
                
                return viewPriceDetails
            }()
            
            NSLayoutConstraint.activate([
                viewPricing.topAnchor.constraint(equalTo:             btnPayInfluencers.bottomAnchor, constant: 0),
//                viewPricing.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                viewPricing.leftAnchor.constraint(equalTo:             btnPayInfluencers.leftAnchor, constant: 0),
                viewPricing.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
//                viewPricing.heightAnchor.constraint(equalToConstant: 110),
                
            ])
                        
            heightPricing = viewPricing.heightAnchor.constraint(equalToConstant: 0)
            heightPricing.isActive = true
            viewPricing.isHidden = true
            
            
            btnCampaignProductPay = {
                let button = UIButton()
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tag = 4
                button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
                button.backgroundColor = .gray

                button.layer.cornerRadius = 6
                button.clipsToBounds = true

                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Done"
                label.textColor =  .systemBackground
                label.font = UIFont (name: kFontBold, size: 18)

                button.addSubview(label)

                NSLayoutConstraint.activate([
                    label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                    label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                ])

                imageTick.translatesAutoresizingMaskIntoConstraints = false
                imageTick.image = UIImage (named: "tick")

                button.addSubview(imageTick)

                NSLayoutConstraint.activate([
                    imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                    imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                    imageTick.widthAnchor.constraint(equalToConstant: 26),
                ])

                return button
            }()
            
            NSLayoutConstraint.activate([
                btnCampaignProductPay.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                btnCampaignProductPay.topAnchor.constraint(equalTo: viewPricing.bottomAnchor, constant: 20),
                btnCampaignProductPay.heightAnchor.constraint(equalToConstant: 50),
                imageTick.rightAnchor.constraint(equalTo: btnCampaignProductPay.rightAnchor, constant: -10),
            ])
            
            return view
        }()
        
        
        
        NSLayoutConstraint.activate([
            viewCompain_4.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_4.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_4.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_4.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_4.bottomAnchor.constraint(equalTo: btnCampaignProductPay.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_5() {
//        viewCompain_5.backgroundColor = .red
        viewContainer.addSubview(viewCompain_5)
        viewCompain_5.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        viewCompain_5.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select the Platform"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_5.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_5.topAnchor, constant: 0),
        ])
        
        var tblTopStories: UITableView!
        tblTopStories = {
            viewCompain_5.addSubview(tblPlateform)
            tblPlateform.translatesAutoresizingMaskIntoConstraints = false
            tblPlateform.register(PlateformTableViewCell.self, forCellReuseIdentifier: "plateform")
//            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
            tblPlateform.delegate = self
            tblPlateform.dataSource = self
            tblPlateform.separatorStyle = .none
            tblPlateform.backgroundColor = .systemBackground
            
            return tblPlateform
        }()
        
        NSLayoutConstraint.activate([
            tblTopStories.leftAnchor.constraint(equalTo: viewCompain_5.leftAnchor, constant: 0),
            tblTopStories.rightAnchor.constraint(equalTo: viewCompain_5.rightAnchor, constant: 0),
            tblTopStories.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            tblTopStories.heightAnchor.constraint(equalToConstant: 360)
        ])
        

        let imageTick = UIImageView()
        
        btnCampaignPlateform = {
            let button = UIButton()
            viewCompain_5.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 5
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_5.addSubview(btnCampaignPlateform)
        
        NSLayoutConstraint.activate([
            btnCampaignPlateform.leftAnchor.constraint(equalTo: viewCompain_5.leftAnchor, constant: 0),
            btnCampaignPlateform.topAnchor.constraint(equalTo: tblTopStories.bottomAnchor, constant: 16),
            btnCampaignPlateform.heightAnchor.constraint(equalToConstant: 50),
            imageTick.rightAnchor.constraint(equalTo: btnCampaignPlateform.rightAnchor, constant: -10),
        ])
        
        
        NSLayoutConstraint.activate([
            viewCompain_5.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_5.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_5.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_5.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_5.bottomAnchor.constraint(equalTo: btnCampaignPlateform.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_6() {
//        viewCompain_6.backgroundColor = .red
        viewContainer.addSubview(viewCompain_6)
        viewCompain_6.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Minimum followers"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)
        
        viewCompain_6.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_6.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_6.topAnchor, constant: 0),
        ])
        
        viewCompain_6.addSubview(txtCampaignMinFollowers)
        txtCampaignMinFollowers.translatesAutoresizingMaskIntoConstraints = false
        
        txtCampaignMinFollowers.tag = 3
        txtCampaignMinFollowers.addTarget(self, action: #selector(textFieldChanging(_:)), for: .editingChanged)
        txtCampaignMinFollowers.layer.borderWidth = 1
        txtCampaignMinFollowers.layer.borderColor = UIColor.label.cgColor
        txtCampaignMinFollowers.layer.cornerRadius = 6
        txtCampaignMinFollowers.clipsToBounds = true
        txtCampaignMinFollowers.keyboardType = .numberPad
        txtCampaignMinFollowers.placeholder = "Enter here"
        txtCampaignMinFollowers.font = UIFont (name: kFontMedium, size: 18)
        txtCampaignMinFollowers.textColor = .label
        txtCampaignMinFollowers.leftPadding(16)
        txtCampaignMinFollowers.rightPadding(16)
        
        NSLayoutConstraint.activate([
            txtCampaignMinFollowers.leftAnchor.constraint(equalTo: viewCompain_6.leftAnchor, constant: 0),
            txtCampaignMinFollowers.rightAnchor.constraint(equalTo: viewCompain_6.rightAnchor, constant: 0),
            txtCampaignMinFollowers.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            txtCampaignMinFollowers.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let imageTick = UIImageView()
        
        btnCampaignFollowers = {
            let button = UIButton()
            viewCompain_6.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 6
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_6.addSubview(btnCampaignFollowers)
        
        NSLayoutConstraint.activate([
            btnCampaignFollowers.leftAnchor.constraint(equalTo: viewCompain_6.leftAnchor, constant: 0),
            btnCampaignFollowers.topAnchor.constraint(equalTo: txtCampaignMinFollowers.bottomAnchor, constant: 16),
            btnCampaignFollowers.heightAnchor.constraint(equalToConstant: 50),
//            btnCampaignName.widthAnchor.constraint(equalToConstant: 120)
            imageTick.rightAnchor.constraint(equalTo: btnCampaignFollowers.rightAnchor, constant: -10),
        ])
                
        NSLayoutConstraint.activate([
            viewCompain_6.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_6.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_6.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_6.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_6.bottomAnchor.constraint(equalTo: btnCampaignFollowers.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_7() {
//        viewCompain_7.backgroundColor = .red
        viewContainer.addSubview(viewCompain_7)
        viewCompain_7.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gender for your target audience"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)
        
        viewCompain_7.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_7.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_7.topAnchor, constant: 0),
        ])
        
        var btnSelectGender = UIButton()
        btnSelectGender = {
            let button = UIButton()
            viewCompain_7.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(btnSelectGender(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.label.cgColor
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            button.backgroundColor = .systemBackground
            
            button.addSubview(lblGenterType)
            lblGenterType.translatesAutoresizingMaskIntoConstraints = false
            lblGenterType.text = "Select Gender"
            lblGenterType.textColor =  .label
            lblGenterType.font = UIFont (name: kFontMedium, size: 18)
            
            NSLayoutConstraint.activate([
                lblGenterType.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                lblGenterType.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0)
            ])
            
            let imgDownArrow = UIImageView()
            button.addSubview(imgDownArrow)
            imgDownArrow.translatesAutoresizingMaskIntoConstraints = false
            imgDownArrow.image = UIImage (named: "dropDown")
            
            NSLayoutConstraint.activate([
                imgDownArrow.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10),
                imgDownArrow.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imgDownArrow.heightAnchor.constraint(equalToConstant: 24),
                imgDownArrow.widthAnchor.constraint(equalToConstant: 24),
            ])
            
            return button
        }()
        
        NSLayoutConstraint.activate([
            btnSelectGender.leftAnchor.constraint(equalTo: viewCompain_7.leftAnchor, constant: 0),
            btnSelectGender.rightAnchor.constraint(equalTo: viewCompain_7.rightAnchor, constant: 0),
            btnSelectGender.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            btnSelectGender.heightAnchor.constraint(equalToConstant: 50)
        ])
        

        let imageTick = UIImageView()
        
        btnCampaignAudience = {
            let button = UIButton()
            viewCompain_7.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 7
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_7.addSubview(btnCampaignAudience)
        
        NSLayoutConstraint.activate([
            btnCampaignAudience.leftAnchor.constraint(equalTo: viewCompain_7.leftAnchor, constant: 0),
            btnCampaignAudience.topAnchor.constraint(equalTo: btnSelectGender.bottomAnchor, constant: 16),
            btnCampaignAudience.heightAnchor.constraint(equalToConstant: 50),
            imageTick.rightAnchor.constraint(equalTo: btnCampaignAudience.rightAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            viewCompain_7.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_7.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_7.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_7.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_7.bottomAnchor.constraint(equalTo: btnCampaignAudience.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_8() {
//        viewCompain_8.backgroundColor = .red
        viewContainer.addSubview(viewCompain_8)
        viewCompain_8.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose categories for your product"
        label.textColor =  .gray
        label.font = UIFont (name: kFontMedium, size: 18)
        
        viewCompain_8.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: viewCompain_8.leftAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: viewCompain_8.topAnchor, constant: 0),
        ])
        
        var btnSelectGender = UIButton()
        btnSelectGender = {
            let button = UIButton()
            viewCompain_8.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(btnSelectCategory(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.label.cgColor
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            button.backgroundColor = .systemBackground
            
            button.addSubview(lblCategory)
            lblCategory.translatesAutoresizingMaskIntoConstraints = false
            lblCategory.text = "Select Categories"
            lblCategory.textColor =  .label
            lblCategory.font = UIFont (name: kFontMedium, size: 18)
            
            NSLayoutConstraint.activate([
                lblCategory.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                lblCategory.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0)
            ])
            
            let imgDownArrow = UIImageView()
            button.addSubview(imgDownArrow)
            imgDownArrow.translatesAutoresizingMaskIntoConstraints = false
            imgDownArrow.image = UIImage (named: "dropDown")
            
            NSLayoutConstraint.activate([
                imgDownArrow.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10),
                imgDownArrow.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imgDownArrow.heightAnchor.constraint(equalToConstant: 24),
                imgDownArrow.widthAnchor.constraint(equalToConstant: 24),
            ])
            
            return button
        }()
        
        NSLayoutConstraint.activate([
            btnSelectGender.leftAnchor.constraint(equalTo: viewCompain_8.leftAnchor, constant: 0),
            btnSelectGender.rightAnchor.constraint(equalTo: viewCompain_8.rightAnchor, constant: 0),
            btnSelectGender.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            btnSelectGender.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let imageTick = UIImageView()
        
        btnCampaignCategory = {
            let button = UIButton()
            viewCompain_8.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 8
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            button.backgroundColor = .gray
            
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Done"
            label.textColor =  .systemBackground
            label.font = UIFont (name: kFontBold, size: 18)
            
            button.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
            ])
            
            imageTick.translatesAutoresizingMaskIntoConstraints = false
            imageTick.image = UIImage (named: "tick")
            
            button.addSubview(imageTick)
            
            NSLayoutConstraint.activate([
                imageTick.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
                imageTick.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0),
                imageTick.widthAnchor.constraint(equalToConstant: 26),
            ])
            
            return button
        }()
        
        viewCompain_8.addSubview(btnCampaignCategory)
        
        NSLayoutConstraint.activate([
            btnCampaignCategory.leftAnchor.constraint(equalTo: viewCompain_8.leftAnchor, constant: 0),
            btnCampaignCategory.topAnchor.constraint(equalTo: btnSelectGender.bottomAnchor, constant: 16),
            btnCampaignCategory.heightAnchor.constraint(equalToConstant: 50),
            imageTick.rightAnchor.constraint(equalTo: btnCampaignCategory.rightAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            viewCompain_8.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_8.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_8.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_8.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_8.bottomAnchor.constraint(equalTo: btnCampaignCategory.bottomAnchor, constant: 0),
        ])
        
    }
    
    func setCompainUI_9() {
        var btnPreview = UIButton()
        var btnSubmit = UIButton()
        
        viewCompain_9 = {
            let view = UIView()
            viewContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            btnPreview = {
                let button = UIButton()
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(btnPreview(_:)), for: .touchUpInside)
                button.setTitle("Preview", for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.backgroundColor = .systemBackground
                button.titleLabel?.font = UIFont (name: kFontMedium, size: 18)
                button.layer.borderColor = UIColor.label.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 6
                button.clipsToBounds = true
                
                
                NSLayoutConstraint.activate([
                    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                    button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                    button.heightAnchor.constraint(equalToConstant: 50),
                    button.widthAnchor.constraint(equalToConstant: 100),
                ])
                                
                return button
            }()
            
            btnSubmit = {
                let button = UIButton()
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(btnSubmit(_:)), for: .touchUpInside)
                button.setTitle("Submit", for: .normal)
                button.setTitleColor(.systemBackground, for: .normal)
                button.backgroundColor = .label
                button.titleLabel?.font = UIFont (name: kFontMedium, size: 18)
                button.layer.cornerRadius = 6
                button.clipsToBounds = true
                
                NSLayoutConstraint.activate([
                    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                    button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                    button.heightAnchor.constraint(equalTo: btnPreview.heightAnchor, constant: 0),
                    button.widthAnchor.constraint(equalTo: btnPreview.widthAnchor, constant: 0)
//                    button.heightAnchor.constraint(equalToConstant: 54),
//                    button.widthAnchor.constraint(equalToConstant: 120),
                ])
                                
                return button
            }()
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewCompain_9.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16),
            viewCompain_9.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -16),
            viewCompain_9.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: 0),
            viewCompain_9.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0),
            viewCompain_9.bottomAnchor.constraint(equalTo: btnPreview.bottomAnchor, constant: 0),
        ])
        
    }
}

extension CreateCompainViewC_1 {
    
    @IBAction func btnGiveAwayProduct(_ sender: UIButton) {
        txtPrice.text = ""
        txtGiveAwayProductDesc.text = "Describe here"
        
        indexProductPay = 1
        
        productPay()
        
        heightPricing.constant = 0
        viewPricing.isHidden = true
        viewProductPay.isHidden = false
        heightGiveAwayProduct.constant = 200
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnPayInfluencers(_ sender: UIButton) {
        txtPrice.text = ""
        txtGiveAwayProductDesc.text = "Describe here"
        
        indexProductPay = 2
        
        productPay()
        
        heightPricing.constant = 110
        viewPricing.isHidden = false
        viewProductPay.isHidden = true
        heightGiveAwayProduct.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Discard", message: "Do you want to discard this campaign ?", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            
        }))
        
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            arrImagesCampaign.removeAll()
            arrSelectedCategoryStore.removeAll()
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        nextOnDone(btnNext.tag)
    }
    
    
    @IBAction func btnPrevious(_ sender: UIButton) {
        if comapaignViewNumber != 1 {
            comapaignViewNumber -= 1
            btnNext.tag -= 1
        }
        
        showHiddenView()
    }
    
    func comapaignViewNumberIncrease() {
        if comapaignViewNumber != 9 {
            comapaignViewNumber += 1
        }
    }
    
    func showHiddenView() {
        viewCompain_1.isHidden = (comapaignViewNumber == 1) ? false : true
        viewCompain_2.isHidden = (comapaignViewNumber == 2) ? false : true
        viewCompain_3.isHidden = (comapaignViewNumber == 3) ? false : true
        viewCompain_4.isHidden = (comapaignViewNumber == 4) ? false : true
        viewCompain_5.isHidden = (comapaignViewNumber == 5) ? false : true
        viewCompain_6.isHidden = (comapaignViewNumber == 6) ? false : true
        viewCompain_7.isHidden = (comapaignViewNumber == 7) ? false : true
        viewCompain_8.isHidden = (comapaignViewNumber == 8) ? false : true
        viewCompain_9.isHidden = (comapaignViewNumber == 9) ? false : true
    }
    
    @IBAction func buttonDonePicker(_ sender: UIButton) {
        viewPickerContainer.isHidden = true
    }
    
    @IBAction func btnSelectGender(_ sender: UIButton) {
        viewPickerContainer.isHidden = false
    }
    
    @IBAction func btnSelectCategory(_ sender: UIButton) {
        let vc = CategoryViewController_1()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        strCampaignPlateform = ""
        strCampaignGiveAwayPay = ""
        
        strCampaignName = txtCampaignName.text!
        strCampaignDescription = txtCampaignDesc.text
        
        strCampaignName = txtCampaignName.text!
        strCampaignDescription = txtCampaignDesc.text
        
        if !txtPrice.text!.isEmpty {
            strCampaignGiveAwayPay = "$"+txtPrice.text!
        } else {
            if !(txtGiveAwayProductDesc.text!.isEmpty && txtGiveAwayProductDesc.text! == "Describe here") {
                strCampaignGiveAwayPay = txtGiveAwayProductDesc.text!
            }
        }
        
        for i in 0..<arrPlateformSelect.count {
            if arrPlateformSelect[i] {
                if strCampaignPlateform.isEmpty {
                    strCampaignPlateform = arrPlateformTitles[i]
                } else {
                    strCampaignPlateform = arrPlateformTitles[i]+","+strCampaignPlateform
                }
            }
        }
        
        strCampaignMinFollowers = txtCampaignMinFollowers.text!
        strCampaignGender = lblGenterType.text!
        strCampaignCategory = lblCategory.text!
        
        let loader = showLoader()
        PresenterCreateCampaign.arrImages = arrImagesCampaign
        PresenterCreateCampaign.createCampaign { (error) in
            DispatchQueue.main.async {
                loader.removeFromSuperview()
                if error == nil {
                    self.showAlert(msg: error.localizedDescription)
                } else {
                    self.showToast("Your campaign is in review.")
                    arrImagesCampaign.removeAll()

                    let viewController = self.navigationController?.viewControllers.first { $0 is MainTabVC }
                    guard let destinationVC = viewController else { return }
                    self.navigationController?.popToViewController(destinationVC, animated: true)
                }
            }
        }

        
    }
    
    @IBAction func btnPreview(_ sender: UIButton) {
        strCampaignPlateform = ""
        strCampaignGiveAwayPay = ""
        
        strCampaignName = txtCampaignName.text!
        strCampaignDescription = txtCampaignDesc.text
        
        let detailsVC = DetailsVC()
        detailsVC.isPreview = true
        detailsVC.selectedImages = arrImagesCampaign
        
        strCampaignName = txtCampaignName.text!
        strCampaignDescription = txtCampaignDesc.text
        
        if !txtPrice.text!.isEmpty {
            strCampaignGiveAwayPay = "$"+txtPrice.text!
        } else {
            if !(txtGiveAwayProductDesc.text!.isEmpty && txtGiveAwayProductDesc.text! == "Describe here") {
                strCampaignGiveAwayPay = txtGiveAwayProductDesc.text!
            }
        }
        
        
        for i in 0..<arrPlateformSelect.count {
            if arrPlateformSelect[i] {
                if strCampaignPlateform.isEmpty {
                    strCampaignPlateform = arrPlateformTitles[i]
                } else {
                    strCampaignPlateform = arrPlateformTitles[i]+","+strCampaignPlateform
                }
            }
        }
        
        strCampaignMinFollowers = txtCampaignMinFollowers.text!
        strCampaignGender = lblGenterType.text!
        strCampaignCategory = lblCategory.text!
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func nextOnDone(_ tag: Int) {
        buttonDonePicker(UIButton())
        view.endEditing(true)
        print(tag)
        
        if tag == 1 {
            if txtCampaignName.text!.isEmpty {
                showToast("Please enter campaign name.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 2 {
            if txtCampaignDesc.text!.isEmpty || txtCampaignDesc.text! == "Describe here" {
               showToast("Please describe your campaign.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 3 {
            if arrImagesCampaign.isEmpty {
                showToast("Please select atleast 1 image.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 4 {
            if (txtGiveAwayProductDesc.text!.isEmpty || txtGiveAwayProductDesc.text! == "Describe here") && txtPrice.text!.isEmpty {
                showToast("Please select anyone of above.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 5 {
            if !(arrPlateformSelect.contains(true)) {
               showToast("Please select plateform.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 6 {
            if txtCampaignMinFollowers.text!.isEmpty {
                showToast("Please enter minimum followers.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 7 {
            if lblGenterType.text == "Select Gender" {
                showToast("Please select gender.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else if tag == 8 {
            if arrSelectedCategoryStore.isEmpty {
//            if arrSelectCategory.isEmpty {
                showToast("Please select category.")
            } else {
                comapaignViewNumberIncrease()
                showHiddenView()
                btnNext.tag = btnNext.tag+1
            }
        } else {
            
        }
        
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        nextOnDone(sender.tag)
    }
    
    func productPay() {
        btnProduct.backgroundColor = (indexProductPay == 1) ? .label : .systemBackground
        btnProduct.layer.borderColor = (indexProductPay == 1) ?  UIColor.systemBackground.cgColor : UIColor.label.cgColor
        lblA.layer.borderColor = (indexProductPay == 1) ?  UIColor.systemBackground.cgColor : UIColor.label.cgColor
        lblA.textColor = (indexProductPay == 1) ? .systemBackground : .label
        lblProduct.textColor = (indexProductPay == 1) ? .systemBackground : .label
        
                    btnPayInfluencers.backgroundColor = (indexProductPay == 2) ? .label : .systemBackground
                    btnPayInfluencers.layer.borderColor = (indexProductPay == 2) ?  UIColor.systemBackground.cgColor : UIColor.label.cgColor
        lblB.layer.borderColor = (indexProductPay == 2) ?  UIColor.systemBackground.cgColor : UIColor.label.cgColor
        lblB.textColor = (indexProductPay == 2) ? .systemBackground : .label
        lblInfluencers.textColor = (indexProductPay == 2) ? .systemBackground : .label
    }
    
    func pickerUI() {
        viewPickerContainer = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.backgroundColor = .systemBackground
            
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 4
            view.layer.shadowOffset = CGSize (width: 0, height: 0)
            
            let buttonDonePicker = UIButton()
            view.addSubview(buttonDonePicker)
            buttonDonePicker.translatesAutoresizingMaskIntoConstraints = false
            buttonDonePicker.addTarget(self, action: #selector(buttonDonePicker(_:)), for: .touchUpInside)
            buttonDonePicker.setTitle("Done", for: .normal)
            buttonDonePicker.setTitleColor(.label, for: .normal)
            buttonDonePicker.layer.borderWidth = 1
            buttonDonePicker.layer.borderColor = UIColor.label.cgColor
            buttonDonePicker.layer.cornerRadius = 6
            buttonDonePicker.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                buttonDonePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                buttonDonePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                buttonDonePicker.widthAnchor.constraint(equalToConstant: 100),
                buttonDonePicker.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            pickerGender = UIPickerView()
            pickerGender = {
                let picker = UIPickerView()
                view.addSubview(picker)
                picker.translatesAutoresizingMaskIntoConstraints = false
                
                picker.dataSource = self
                picker.delegate = self
                return picker
            }()

            NSLayoutConstraint.activate([
                pickerGender.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                pickerGender.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                pickerGender.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                pickerGender.topAnchor.constraint(equalTo: buttonDonePicker.bottomAnchor, constant: 0),
            ])
            
            
            return view
        }()
        
        NSLayoutConstraint.activate([
            viewPickerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            viewPickerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            viewPickerContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            viewPickerContainer.heightAnchor.constraint(equalToConstant: 200),
        ])
        
    }
    
    @objc func setSelectedCategory() {
        if categorySelected.isEmpty {
            lblCategory.text = "Select Categories"
            btnCampaignCategory.backgroundColor = .gray
        } else {
            lblCategory.text = categorySelected
            btnCampaignCategory.backgroundColor = .label
        }
    }
    
}



extension CreateCompainViewC_1 : UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtCampaignDesc {
            txtCampaignDesc.textColor = .label
            
            if txtCampaignDesc.text.isEmpty || txtCampaignDesc.text == "Describe here" {
                txtCampaignDesc.text = ""
            }
        }
        
        if textView == txtGiveAwayProductDesc {
            txtGiveAwayProductDesc.textColor = .label
            
            if txtGiveAwayProductDesc.text.isEmpty || txtGiveAwayProductDesc.text == "Describe here" {
                txtGiveAwayProductDesc.text = ""
            }
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtCampaignDesc {
            if txtCampaignDesc.text.isEmpty || txtCampaignDesc.text == "Describe here" {
                txtCampaignDesc.textColor = .gray
            } else {
                txtCampaignDesc.textColor = .label
            }
        }
        
        if textView == txtGiveAwayProductDesc {
            if txtGiveAwayProductDesc.text.isEmpty || txtGiveAwayProductDesc.text == "Describe here" {
                txtGiveAwayProductDesc.textColor = .gray
            } else {
                txtGiveAwayProductDesc.textColor = .label
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtCampaignDesc {
            if txtCampaignDesc.text!.isEmpty {
                btnCampaignDescribe.backgroundColor = .gray
            } else {
                btnCampaignDescribe.backgroundColor = .label
            }
        }
        
        if textView == txtGiveAwayProductDesc {
            if txtGiveAwayProductDesc.text!.isEmpty {
                btnCampaignProductPay.backgroundColor = .gray
            } else {
                btnCampaignProductPay.backgroundColor = .label
            }
        }
    }
    
    @objc func textFieldChanging(_ textField: UITextField) {
        if textField.tag == 1 {
            if txtCampaignName.text!.isEmpty {
                btnCampaignName.backgroundColor = .gray
            } else {
                btnCampaignName.backgroundColor = .label
            }
        }
        
        if textField.tag == 2 {
            if txtPrice.text!.isEmpty {
                btnCampaignProductPay.backgroundColor = .gray
            } else {
                btnCampaignProductPay.backgroundColor = .label
            }
        }
        
        if textField.tag == 3 {
            if txtCampaignMinFollowers.text!.isEmpty {
                btnCampaignFollowers.backgroundColor = .gray
            } else {
                btnCampaignFollowers.backgroundColor = .label
            }
        }
        
    }
    
    
}



extension CreateCompainViewC_1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImagesCampaign.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignImage", for: indexPath) as! CampaignImageCollectionCell
        
        cell.imgUser.image = arrImagesCampaign[indexPath.row]
        
        return cell
    }
    
}

extension CreateCompainViewC_1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlateformTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plateform", for: indexPath) as! PlateformTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        cell.viewContainer.backgroundColor = arrPlateformSelect[indexPath.row] ? .label : .systemBackground
        cell.viewContainer.layer.borderColor = arrPlateformSelect[indexPath.row] ? UIColor.systemBackground.cgColor : UIColor.label.cgColor
        
        cell.lblACount.backgroundColor = arrPlateformSelect[indexPath.row] ? .label : .systemBackground
        cell.lblACount.layer.borderColor = arrPlateformSelect[indexPath.row] ? UIColor.systemBackground.cgColor : UIColor.label.cgColor
        cell.lblACount.textColor = arrPlateformSelect[indexPath.row] ? .systemBackground : .label
        
        cell.lblPlateform.textColor = arrPlateformSelect[indexPath.row] ? .systemBackground : .label
        
        cell.lblPlateform.text = arrPlateformTitles[indexPath.row]
        cell.lblACount.text = arrPlateformChars[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for i in 0..<arrPlateformSelect.count {
            if i==indexPath.row {
                arrPlateformSelect[i] = !arrPlateformSelect[i]
            }
        }
        
        if !arrPlateformSelect.contains(true) {
            btnCampaignPlateform.backgroundColor = .gray
        } else {
            btnCampaignPlateform.backgroundColor = .label
        }
        
        tblPlateform.reloadData()
    }
        
}

extension CreateCompainViewC_1: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrGenders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrGenders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblGenterType.text = arrGenders[row]
        
        if lblGenterType.text == "Select Gender" {
            btnCampaignAudience.backgroundColor = .gray
        } else {
            btnCampaignAudience.backgroundColor = .label
        }
    }
    
}

extension CreateCompainViewC_1: OpalImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    private func checkPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    let imagePicker = OpalImagePickerController()
                    imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                    imagePicker.imagePickerDelegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    
                case .limited:
                    print("limited")
                    self.openSettings()
                    
                case .restricted:
                    print("restricted")
                    self.openSettings()
                    
                case .denied:
                    print("denied")
                    self.openSettings()
                    
                case .notDetermined:
                    print("notDetermined")
                    self.openSettings()
                    
                default:
                    break
                }
                
            }
        }
        
    }
    
    func openSettings() {
        let alert = UIAlertController(title: "Alert!",
                                      message: "Allow access to your photos.",
                                      preferredStyle: .alert)
        
        let notNowAction = UIAlertAction(title: "Not Now",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(notNowAction)
        
        let openSettingsAction = UIAlertAction(title: "Open Settings",
                                               style: .default) { [unowned self] (_) in
            gotoAppPrivacySettings()
        }
        alert.addAction(openSettingsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnAddIcon(_ sender: UIButton)  {
        checkPhotosPermission()
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        for asset in assets {
            arrImagesCampaign.append(getAssetThumbnail(asset))
        }
        
        let campaignImagesVC = CampaignImagesViewController()
        self.navigationController?.pushViewController(campaignImagesVC, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        
    }
    
}



func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
    let manager = PHImageManager.default
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.isSynchronous = true
    manager().requestImage(for: asset, targetSize: CGSize(width: 1024.0, height: 1024.0),
                           contentMode: .aspectFit,
                           options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
    })
    return thumbnail
}


