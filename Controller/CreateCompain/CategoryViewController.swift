//
//  CategoryViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 03/03/22.
//

import UIKit
import SwiftToast


//var arrSelectCategory:[Bool] = [Bool]()
var arrSelectedCategoryStore:[String] = [String]()

class CategoryViewController_1: UIViewController {
    var navBar: UIView!
    var tblCategory = UITableView()
    var viewSearch: UIView!
    var btnDone = UIButton()
    
    var arrCategory:[String] = [String]()
    var arrSearchedData:[String] = [String]()
    var arrAllData:[String] = [String]()
    
    var selectedCategory = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        if arrCategory.count == 0 {
            fetchCloudValues()
        }
        
        setNavigationBar()
        searchView()
        setDone()
        setTableUI()
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
            labelTitle.text = "Select Categories"
            labelTitle.textColor =  .label
            labelTitle.font = UIFont (name: kFontBold, size: 20)
            
            view.addSubview(labelTitle)
            
            NSLayoutConstraint.activate([
                labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                labelTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
            
//            let btnBack: UIButton = {
//                let button = UIButton()
//                button.translatesAutoresizingMaskIntoConstraints = false
//                button.backgroundColor = .systemBackground
//                button.setImage(UIImage (named: "back_subscription"), for: .normal)
//                button.addTarget(self, action: #selector(btnBack(_:)), for: .touchUpInside)
//
//                return button
//            }()
//
//            view.addSubview(btnBack)

//            NSLayoutConstraint.activate([
//                btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
//                btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
//                btnBack.widthAnchor.constraint(equalToConstant: 44),
//                btnBack.heightAnchor.constraint(equalToConstant: 44),
//            ])
            
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
    
    func searchView() {
        viewSearch = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemBackground
            
            view.layer.borderColor = UIColor.darkGray.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 22
            view.clipsToBounds = true
            
            let imgSearch = UIImageView()
            imgSearch.translatesAutoresizingMaskIntoConstraints = false
            imgSearch.image = UIImage (named: "searchIconInfluencers")
            view.addSubview(imgSearch)
            
            NSLayoutConstraint.activate([
                imgSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                imgSearch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                imgSearch.heightAnchor.constraint(equalToConstant: 24),
                imgSearch.widthAnchor.constraint(equalToConstant: 24)
            ])
            
            let txtSearch = UITextField()
            txtSearch.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(txtSearch)
            
            txtSearch.font = UIFont (name: "Rounded Mplus 1c", size: 16)
            txtSearch.placeholder = "Search Categories...."
            txtSearch.addTarget(self, action: #selector(txtSearch(_ :)), for: .editingChanged)
            
            NSLayoutConstraint.activate([
                txtSearch.leftAnchor.constraint(equalTo: imgSearch.rightAnchor, constant: 10),
                txtSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                txtSearch.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1, constant: 0),
                txtSearch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            ])
            
            return view
        }()
        
        self.view.addSubview(viewSearch)
        
        NSLayoutConstraint.activate([
            viewSearch.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0),
            viewSearch.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            viewSearch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            viewSearch.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    func setDone() {
        
        btnDone = {
            let button = UIButton()
            self.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .label
            button.setTitle("Done", for: .normal)
            button.titleLabel?.font = UIFont (name: kFontMedium, size: 18)
            button.addTarget(self, action: #selector(btnDone(_:)), for: .touchUpInside)
            
            
            
            return button
        }()
        
        NSLayoutConstraint.activate([
            btnDone.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            btnDone.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            btnDone.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            btnDone.heightAnchor.constraint(equalToConstant: 54)
        ])
        
    }
    
    func setTableUI() {
        tblCategory = {
            let tableView = UITableView()
            self.view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(CategoryTableViewCell_1.self, forCellReuseIdentifier: "category")
//            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .systemBackground
            
            return tableView
        }()
        
        NSLayoutConstraint.activate([
            tblCategory.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tblCategory.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            tblCategory.topAnchor.constraint(equalTo: viewSearch.bottomAnchor, constant: 0),
            tblCategory.bottomAnchor.constraint(equalTo: btnDone.topAnchor, constant: 0),
        ])
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        categorySelected.removeAll()
        
        for i in 0..<arrSelectedCategoryStore.count {
            if categorySelected.isEmpty {
                categorySelected = arrSelectedCategoryStore[i]
            } else {
                categorySelected = categorySelected+","+arrSelectedCategoryStore[i]
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name ("setSelectedCategory"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}


extension CategoryViewController_1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryTableViewCell_1
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        if arrSelectedCategoryStore.contains(arrCategory[indexPath.row]) {
            cell.imgTick.isHidden = false
        } else {
            cell.imgTick.isHidden = true
        }
        cell.lblCategoryName.text = arrCategory[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        for i in 0..<arrCategory.count {
            if i == indexPath.row {
                if arrSelectedCategoryStore.contains(arrCategory[i]) {
                    let indexStored =  arrSelectedCategoryStore.firstIndex(of: arrCategory[i])
                    arrSelectedCategoryStore.remove(at: indexStored!)
                    
                    if selectedCategory != 0 {
                        selectedCategory = selectedCategory-1
                    }
                } else {
                     if selectedCategory < 5 {
                        selectedCategory = selectedCategory+1
                        arrSelectedCategoryStore.append(arrCategory[i])
                    } else {
                        showToast("You can select only 5 categories.")
                        return
                    }
                }
            }
        }
        
        tblCategory.reloadData()
    }
    
}



import Firebase

extension CategoryViewController_1 {
    @objc func txtSearch(_ textfield:UITextField) {
        arrSearchedData.removeAll()
        
        if textfield.text?.count != 0 {
            for category in arrAllData {
                let isMachingWorker : NSString = (category) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    arrSearchedData.append(category)
                }
            }
            
            arrCategory = arrSearchedData
        } else {
            arrCategory = arrAllData
        }
        
        tblCategory.reloadData()
    }
    
    func fetchCloudValues() {
        let appPrimaryColorString = RemoteConfig.remoteConfig()
          .configValue(forKey: "explore_category")
          .stringValue ?? "undefined"
        
        let data = appPrimaryColorString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                print(jsonArray)
                
                for (key, _) in jsonArray {
                    arrAllData.append("\(key)")
                }
                
                arrAllData = arrAllData.sorted(by: <)
                arrCategory = arrAllData
                
                tblCategory.reloadData()
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}


