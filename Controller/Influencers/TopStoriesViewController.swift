//
//  TopStoriesViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 28/02/22.
//

import UIKit

class TopStoriesViewController: UIViewController {
    var navBar: UIView!
    var tblTopStories: UITableView!
    
    var arrTopStories = [[String: Any]]()
    
    var limit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        getTopStories()
    }
    
    func makeUI() {
        setNavigationBar()
        tableViewUI()
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
            
            
            let lblTitle:UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Top Stories"
                label.textColor = .label
                label.font = UIFont (name: "RoundedMplus1c-Bold", size: 16)
                
                return label
            }()
            
            view.addSubview(lblTitle)
            
            NSLayoutConstraint.activate([
                lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                lblTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
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
    
    func tableViewUI() {
        tblTopStories = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(TopStoriesTableViewCell.self, forCellReuseIdentifier: "topStories")
            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .systemBackground
            
            return tableView
        }()
        
        view.addSubview(tblTopStories)
        
        NSLayoutConstraint.activate([
            tblTopStories.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0),
            tblTopStories.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            tblTopStories.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tblTopStories.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
        ])
        
    }
    
    func getTopStories() {
        PresenterInfluencer.limitTopStories = limit
        let loader = showLoader()
        PresenterInfluencer.topStories { (arrTopStories, error) in
            DispatchQueue.main.async {
                loader.removeFromSuperview()
                self.arrTopStories = arrTopStories
                self.tblTopStories.reloadData()
            }
        }
    }
    
}


extension TopStoriesViewController {
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension TopStoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTopStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topStories", for: indexPath) as! TopStoriesTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        cell.setData(arrTopStories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let webView = TermsOfUseViewController()
        webView.navTitle = "\(arrTopStories[indexPath.row]["title"]!)"
        webView.urlWeb = "\(arrTopStories[indexPath.row]["url"]!)"
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
//            currentPage = currentPage+1
//
//            print("currentPage currentPage currentPage currentPage currentPage currentPage currentPage ")
//            print(currentPage)
//        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            limit = limit+1
            
            getTopStories()
        }
    }
    
    
}
