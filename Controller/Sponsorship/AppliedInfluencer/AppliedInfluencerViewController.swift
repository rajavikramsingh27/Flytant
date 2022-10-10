//
//  AppliedInfluencerViewController.swift
//  Flytant
//
//  Copyright © 2022 Vivek Rai. All rights reserved.
//

import UIKit

class AppliedInfluencerViewController: UIViewController {
    //MARK:- Properties
    
    let appliedInfluencerViewModel = AppliedInfluencerViewModel()
    var selectedUserId = [String]()
    var appliedInfluencerId = [String]()
    var campaignId = ""
    var firstIndex : Int = 0
    var lastIndex : Int = 10
    var isLoading = true
    var selectedfirstIndex : Int = 0
    var selectedlastIndex : Int = 10
    var selectedisLoading = true
    var isSelectedTap = false
    var limitArray = Array<String>()
    
    let AppliedInfluencerTableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(AppliedInfluencerTableViewCell.self, forCellReuseIdentifier:"AppliedInfluencerTableViewCell")
        table.register(selectedTableViewCell.self, forCellReuseIdentifier:"selectedTableViewCell")
        return table
    }()
    
    
    
    
    
    var label: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y:self.view.center.y, width: view.frame.width, height: 40))
        label.text = "No influencer found"
        label.textAlignment = .center
        label.font = AppFont.font(type: .Medium, size: 14)
        label.tag = 400
        return label
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(createNavBar(navTitle: "Influencers Applied", isBack: true))
        
        // Do any additional setup after loading the view.
        
        addControl()
        setAppliedInfluencerTableView()
        
        
        appliedInfluencerViewModel.getselectedUserData(CampId: campaignId, completionHandler: { [self]response,error in
            
            self.selectedUserId = response ?? []
            getAppliedInfluencerData(firstIndex:firstIndex,lastIndex:lastIndex)
            
            getSelectedInfluencerData(firstIndex:selectedfirstIndex,lastIndex:selectedlastIndex)
        })
        
    }
    
    
    func getSelectedUserData(){
        //  label.removeFromSuperview()
        label.alpha = 0
        appliedInfluencerViewModel.getselectedUserData(CampId: campaignId, completionHandler: { [self]response,error in
            
            self.selectedUserId = response ?? []
            
            if isSelectedTap{
                if  appliedInfluencerViewModel.SelectedInfluencers.count == 0{
                    
                    
                    DispatchQueue.main.async {
                        label.alpha = 1
                    }
                    
                }
                else{
                    //  label.removeFromSuperview()
                    DispatchQueue.main.async {
                        label.alpha = 0
                    }
                   
                  
                   
                  
                    
                    
                }
            }
            else{
                if appliedInfluencerViewModel.AppliedInfluencers.count == 0 {
                    //AppliedInfluencerTableView.addSubview(label)
                    label.alpha = 1
                }
                else{
                    //  label.removeFromSuperview()
                    label.alpha = 0
                }
                
            }
            
            
            AppliedInfluencerTableView.reloadData()
            
            
            
        })
    }
    
    
    
    //MARK:- View
    func addControl() {
        
        
        let segmentItems = ["Applicant", "Selected"]
        let InfluencerSegmentedControl = UISegmentedControl(items: segmentItems)
        
        InfluencerSegmentedControl.layer.cornerRadius = 25.0
        InfluencerSegmentedControl.layer.borderColor = UIColor.white.cgColor
        InfluencerSegmentedControl.layer.borderWidth = 1.0
        InfluencerSegmentedControl.layer.masksToBounds = true
        
        InfluencerSegmentedControl.frame = CGRect(x: 10, y: view.safeAreaInsets.top+getStatusBarHeight()+40, width: (self.view.frame.width - 20), height: 45)
        InfluencerSegmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        InfluencerSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(InfluencerSegmentedControl)
        
        view.addSubview(AppliedInfluencerTableView)
        
        AppliedInfluencerTableView.anchor(top: InfluencerSegmentedControl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        label.center = view.center
      //  AppliedInfluencerTableView.addSubview(label)
        
        
    }
    
    func setAppliedInfluencerTableView(){
        AppliedInfluencerTableView.dataSource = self
        AppliedInfluencerTableView.delegate = self
        
        // getSelectedUserData()
    }
    
    
    func getAppliedInfluencerData(firstIndex:Int,lastIndex:Int){
        if appliedInfluencerId.count != 0  {
            if lastIndex > appliedInfluencerId.count && appliedInfluencerId.count != 0 {
                
                limitArray = Array(appliedInfluencerId[firstIndex...appliedInfluencerId.count-1])
                
                isLoading = false
                
            }
            else{
                limitArray = Array(appliedInfluencerId[firstIndex...lastIndex-1])
                
            }
            
            appliedInfluencerViewModel.getAppliedInfluencerData(userIdList: limitArray, completionHandler: { _,_   in
                
                self.getSelectedUserData()
                
            })
        }
    }
    
    
    func getSelectedInfluencerData(firstIndex:Int,lastIndex:Int){
        
        if selectedUserId.count != 0 {
            
            if lastIndex > selectedUserId.count && selectedUserId.count != 0{
                
                if selectedUserId.count == 1{
                    
                    limitArray = [selectedUserId[0]]
                }
                else{
                    limitArray = Array(selectedUserId[selectedfirstIndex...selectedUserId.count-1])
                    
                }
                
                
                selectedisLoading = false
                
            }
            else{
                limitArray = Array(selectedUserId[selectedfirstIndex...selectedlastIndex-1])
                
            }
            
            appliedInfluencerViewModel.getSelectedInfluencerData(userIdList: limitArray, completionHandler: { _,_   in
                
                self.getSelectedUserData()
                
            })
        }
    }
    
    
    
    //MARK:- Handler
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            // First segment tapped
            isSelectedTap = false
            
            getSelectedUserData()
            break
        case 1:
            // Second segment tapped
            isSelectedTap = true
            
            getSelectedUserData()
            
            break
        default:
            break
        }
    }
}
extension AppliedInfluencerViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectedTap{
            return appliedInfluencerViewModel.SelectedInfluencers.count
        }
        return appliedInfluencerViewModel.AppliedInfluencers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if isSelectedTap{
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedTableViewCell", for: indexPath) as! selectedTableViewCell
            
            cell.user = appliedInfluencerViewModel.SelectedInfluencers[indexPath.row]
            cell.isAppliedSelected = isSelectedTap
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppliedInfluencerTableViewCell", for: indexPath) as! AppliedInfluencerTableViewCell
            cell.user = appliedInfluencerViewModel.AppliedInfluencers[indexPath.row]
            
            if selectedUserId.contains(appliedInfluencerViewModel.AppliedInfluencers[indexPath.row].userID){
                cell.AppliedInfluencerSelectBox.setImage(UIImage(named: "selected"), for: .normal)
            }
            else{
                cell.AppliedInfluencerSelectBox.setImage(UIImage(named: "unselected"), for: .normal)
            }
            cell.isAppliedSelected = isSelectedTap
            cell.AppliedInfluencerSelectBox.tag = indexPath.row
            cell.AppliedInfluencerSelectBox.addTarget(self, action: #selector(selectClicked), for: .touchUpInside)
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    @objc func selectClicked(sender:AnyObject){
        
        guard let index = sender.tag else { return  }
        
        if selectedUserId.contains(appliedInfluencerViewModel.AppliedInfluencers[index].userID){
            print("remove user from appliedInfluencerViewModel.SelectedInfluencers")
            
            appliedInfluencerViewModel.updateSelectedUserData(selected: false, CampId: campaignId, userId: appliedInfluencerViewModel.AppliedInfluencers[index].userID)
            let abc =  appliedInfluencerViewModel.SelectedInfluencers.filter({$0.userID != appliedInfluencerViewModel.AppliedInfluencers[index].userID })
            
            appliedInfluencerViewModel.SelectedInfluencers = abc
            
            self.getSelectedUserData()
        }
        else{
            print("add user to  appliedInfluencerViewModel.SelectedInfluencers")
            appliedInfluencerViewModel.updateSelectedUserData(selected: true, CampId: campaignId, userId: appliedInfluencerViewModel.AppliedInfluencers[index].userID)
            
            appliedInfluencerViewModel.getSingleUserData(userId: [appliedInfluencerViewModel.AppliedInfluencers[index].userID], index: index){
                
                self.getSelectedUserData()
            }
            // update appliedInfluencerId array
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isSelectedTap{
            if selectedisLoading && indexPath.row == appliedInfluencerViewModel.SelectedInfluencers.count - 1 {
                selectedfirstIndex = selectedlastIndex
                selectedlastIndex = selectedlastIndex+10
                getSelectedInfluencerData(firstIndex:selectedfirstIndex,lastIndex:selectedlastIndex)
            }
            
        }
        else{
            //add pagination for Applied
            if isLoading && indexPath.row == appliedInfluencerViewModel.AppliedInfluencers.count - 1 {
                firstIndex = lastIndex
                lastIndex = lastIndex+10
                getAppliedInfluencerData(firstIndex:firstIndex,lastIndex:lastIndex)
            }
            
        }
    }
}
