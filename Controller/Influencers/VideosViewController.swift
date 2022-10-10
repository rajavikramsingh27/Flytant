//
//  VideosViewController.swift
//  Flytant-1
//
//  Created by GranzaX on 28/02/22.
//

import UIKit

class VideosViewController: UIViewController {
    var navBar: UIView!
    var collVideos: UICollectionView!
    
    var arrVideos = [[String: Any]]()
    
    var limit = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        PresenterInfluencer.pageToken = ""
        getYouTubeVideos()
    }
    
    func makeUI() {
        setNavigationBar()
        topInfluencersUI()
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
                label.text = "Videos"
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
    
    func topInfluencersUI() {
        collVideos = {
            let collectionCell = ((self.view.frame.width-32)/2)-6
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 30, right: 16)
            layout.itemSize = CGSize(width: collectionCell, height: collectionCell-25)
            layout.scrollDirection = .vertical
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.collectionViewLayout = layout
            collectionView.register(VideosCollectionViewCell.self, forCellWithReuseIdentifier: "videos")

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .systemBackground

            collectionView.showsHorizontalScrollIndicator = false

            return collectionView
        }()

        self.view.addSubview(collVideos)
        
        NSLayoutConstraint.activate([
            collVideos.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0),
            collVideos.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            collVideos.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            collVideos.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
        ])

    }
    
    func getYouTubeVideos() {
        PresenterInfluencer.maxResults = 12
        let loader = showLoader()
        PresenterInfluencer.youTubeVideos { (arrVideos, error) in
            DispatchQueue.main.async {
                loader.removeFromSuperview()
                self.arrVideos = self.arrVideos+arrVideos
                self.collVideos.reloadData()
            }
        }
    }
    
}




extension VideosViewController {
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        if let dictID = arrVideos[sender.tag]["id"] as? [String: Any] {
            if let videoId = dictID["videoId"] as? String {
                "https://www.youtube.com/watch?v=\(videoId)".urlLaunch()
            }
        }
        
    }
    
}


extension VideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videos", for: indexPath) as! VideosCollectionViewCell
        
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(btnPlay(_:)), for: .touchUpInside)
        
        cell.setData(arrVideos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
 
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            limit = limit+12
            
            if arrVideos.count < PresenterInfluencer.totalResultsYoutube {
                getYouTubeVideos()
            }
        }
    }
    
}
