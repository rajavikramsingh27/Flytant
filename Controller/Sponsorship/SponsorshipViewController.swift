//
//  SponsorshipViewController.swift
//  Flytant
//
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import DropDown


protocol SponsorshipViewCellDelegate: class {
    func viewAllTap(query:Query,title:String)
}

class SponsorshipViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    
    //    MARK: - Properties
    
    var sponsorships = [Sponsorships]()
    var sponsorshipArray = [[Sponsorships]()]
    var xOffsets: [IndexPath: CGFloat] = [:]
    let sponsorshipviewModel = SponsorshipViewModel()
    var subsBannerIndex = 0
    
    lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.label
    return refreshControl
    }()
    
    //MARK:- View
    let navigationTitleView = FLabel(backgroundColor: UIColor.clear, text: "Sponsorships", font: UIFont(name: "RoundedMplus1c-Bold", size: 24)!, textAlignment: .left, textColor: UIColor.label)
    
    let sortDropDown = DropDown()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    loadTableView()
    refreshControl.endRefreshing()
    }
    
    private var sponsorshipTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ProjectColor.viewBackground
        //self.title = "Sponsorships"
        
        setTableView()
        configureDropDowns()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       navigationTitleView.removeFromSuperview()
    }

    private func configureNavigationBar(){
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        navigationController?.navigationBar.addSubview(navigationTitleView)
        navigationTitleView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 96, width: 0, height: 0)
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "three_v_dot"), style: .plain, target: self, action:  #selector(handleSort))
        navigationItem.rightBarButtonItem = rightBarButtonItem
      
        sortDropDown.anchorView = rightBarButtonItem

    }
    var sortData = ["My Campaigns", "Applied Campaigns"]
    
    
    private func configureDropDowns(){
     
        sortDropDown.dataSource = sortData
        
        sortDropDown.cellConfiguration = { (index, item) in
            print(item)
            return "\(item)" }
        sortDropDown.width = 144
        sortDropDown.direction = .bottom
        //sortDropDown.bottomOffset = CGPoint(x: 0, y:(sortDropDown.anchorView?.plainView.bounds.height)! - 10)
        sortDropDown.dismissMode = .automatic
        sortDropDown.backgroundColor = UIColor.secondarySystemBackground
        sortDropDown.textColor = UIColor.label
        sortDropDown.textFont = UIFont.systemFont(ofSize: 14)
        sortDropDown.selectionBackgroundColor = UIColor.secondarySystemBackground
        sortDropDown.selectedTextColor = UIColor.label
        sortDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownApi(index: index)
            
        }
        
    }
    
    @objc private func handleSort(){
        sortDropDown.show()
    }
    
    func dropDownApi(index: Int){
        
        let vc = SponsorshipVC()
        if index == 0{
            vc.fetchSponsorshipData(query: sponsorshipviewModel.isYour)
            vc.isApplied = false
           
        }
       else{
            vc.fetchSponsorshipData(query: sponsorshipviewModel.isYour)
            vc.isApplied = true
          //  vc.navigationItem.title = "My Campaigns"
        }
    
        vc.navigationItem.title = sortData[index]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func setTableView(){
        

        let tabbarheight = self.tabBarController?.tabBar.frame.size.height
        
        sponsorshipTableView = UITableView(frame: CGRect(x: 0, y: getStatusBarHeight(), width: view.frame.width, height: view.frame.height - getStatusBarHeight()-getsafeBottomHeight()-tabbarheight!),style: .grouped)
        
        sponsorshipTableView.register(mainTableViewCell.self, forCellReuseIdentifier: "mainTableViewCell")
        sponsorshipTableView.register(BannerTableViewCell.self, forCellReuseIdentifier: "BannerTableViewCell")
        
        sponsorshipTableView.dataSource = self
        sponsorshipTableView.delegate = self
        sponsorshipTableView.backgroundColor = .clear
        sponsorshipTableView.allowsSelection = false
        sponsorshipTableView.separatorStyle = .none
        sponsorshipTableView.rowHeight = UITableView.automaticDimension
        sponsorshipTableView.estimatedRowHeight = 44.0
        sponsorshipTableView.addSubview(refreshControl)
        
        loadTableView()

    }
    
    
    func loadTableView(){
        
        
        
        sponsorshipviewModel.sponsorshipArrayAppendTask(completion: { [self] in
            
            self.view.addSubview(sponsorshipTableView)
            let bannerIndex = sponsorshipviewModel.SponsorshipSectionHeaderArray.firstIndex(of: sponsorshipviewModel.slider[0].below) ?? 0
            subsBannerIndex = bannerIndex+1
            //fill sponsorshipviewModel array at banner index
            sponsorshipviewModel.sponsorshipArray.insert([],at:subsBannerIndex)
            sponsorshipviewModel.SponsorshipSectionHeaderArray.insert("",at:subsBannerIndex)
            sponsorshipviewModel.queryArray.insert(sponsorshipviewModel.isYour, at: subsBannerIndex)
            DispatchQueue.main.async { [weak self] in
                self?.sponsorshipTableView.reloadData()
                
            }
            
            
        })
    }
    
    //MARK:- Tableview datasource and delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sponsorshipviewModel.SponsorshipSectionHeaderArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if sponsorshipviewModel.SponsorshipSectionHeaderArray[section] != "" && sponsorshipviewModel.sponsorshipArray[section].count != 0  {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = sponsorshipviewModel.SponsorshipSectionHeaderArray[section]
            label.HeaderLabel()
            headerView.addSubview(label)
            return headerView
            
        }
        else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sponsorshipviewModel.sponsorshipArray.count != 0 && section <= sponsorshipviewModel.sponsorshipArray.count - 1 &&  sponsorshipviewModel.sponsorshipArray[section].count != 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sponsorshipviewModel.sponsorshipArray.count != 0 && section <= sponsorshipviewModel.sponsorshipArray.count - 1{
            
            return 1
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section == subsBannerIndex{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath as IndexPath) as! BannerTableViewCell
            cell.bannerImageView.sd_setImage(with: URL(string: sponsorshipviewModel.slider[0].imageURL) , completed: nil)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.bannerImageView.isUserInteractionEnabled = true
            cell.bannerImageView.addGestureRecognizer(tapGestureRecognizer)
            cell.backgroundColor = .clear
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath as IndexPath) as! mainTableViewCell
            cell.backgroundColor = .clear
            let sponsorModels =  sponsorshipviewModel.sponsorshipArray[indexPath.section]
            cell.viewAlldelegate = self
            cell.collectionView.tag = indexPath.section
            cell.sponsorshipTableCellModel = sponsorModels
            cell.sponsorshipTableCellQueryArray = sponsorshipviewModel.queryArray
            cell.sponsorshipTableCellHeaderArray =  sponsorshipviewModel.SponsorshipSectionHeaderArray
            cell.reloadCollectionView()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if sponsorshipviewModel.sponsorshipArray[indexPath.section].count != 0 && indexPath.section != subsBannerIndex {
            
            if sponsorshipviewModel.SponsorshipSectionHeaderArray[indexPath.section] == "Latest Sponsorships" || sponsorshipviewModel.SponsorshipSectionHeaderArray[indexPath.section] == "Highest Paid Sponsorships" {
                
                return 205
                
            }
            
            return 170
        }
        else if indexPath.section == subsBannerIndex {
            
            return 180
        }
        
        else{
            return 0
        }
        
    }
    
    // MARK:- Function to stop double scrolling in collection view
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        xOffsets[indexPath] = (cell as? mainTableViewCell)?.collectionView.contentOffset.x
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? mainTableViewCell)?.collectionView.contentOffset.x = xOffsets[indexPath] ?? 0
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let paymentsVC = PaymentViewController()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(paymentsVC, animated: true)
    }
}
extension SponsorshipViewController: SponsorshipViewCellDelegate {
   
   
    
    func viewAllTap(query:Query,title: String){
        
        let vc = SponsorshipVC()
        vc.fetchSponsorshipData(query: query)
        vc.navigationItem.title = title
        navigationController?.pushViewController(vc, animated: true)
         // print("item tapped\(indexPath)")
     }

}
