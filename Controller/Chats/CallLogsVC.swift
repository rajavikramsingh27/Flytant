//
//  CallLogsVC.swift
//  Flytant
//
//  Created by Vivek Rai on 20/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ProgressHUD
import FirebaseFirestore
import MessageUI
import ProgressHUD

private let reuseIdentifier = "callsCollectionViewCell"

class CallLogsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    MARK: - Properties
    var chatCalls = [ChatCalls]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var callListener: ListenerRegistration!
    
//    MARK: - Views
    let activityIndicatorView = FActivityIndicatorView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureCollectionView()
        configureNavigationBar()
        fetchCalls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - Configure Views
    
    private func configureNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.label
        navigationController?.navigationBar.tintColor = UIColor.label
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.systemBackground, UIColor.systemBackground, UIColor.systemBackground], startPoint: .topLeft, endPoint: .topRight)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "RoundedMplus1c-Bold", size: 20)!]
        navigationItem.title = "Call Logs"
    }
    
    private func configureCollectionView(){
        self.collectionView.register(CallsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
    }
    
    private func showIndicatorView() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }

    private func dismissIndicatorView(){
        activityIndicatorView.removeFromSuperview()
    }
       
//    MARK: - CollectionView Delegate and DataSource
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 72)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !chatCalls.isEmpty{
            print(chatCalls.count)
            return chatCalls.count
        }else{
             return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CallsCollectionViewCell
        if !chatCalls.isEmpty{
            cell.chatCalls = chatCalls[indexPath.row]
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleCall(chatCall: chatCalls[indexPath.row])
    }

    

        
    
//    MARK: - Handlers
    
    private func handleCall(chatCall: ChatCalls){
        guard let userId = chatCall.withUserId else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let currentUsername = UserDefaults.standard.string(forKey: USERNAME) else {return}
        DataService.instance.fetchPartnerUser(with: userId) { (user) in
            let call = ChatCalls(callerId: currentUserId, callerName: currentUsername, withUserName: user.username, withUserId: userId)
            call.saveCall()
            self.callUser(chatCall: chatCall)
        }
    }

    private func callUser(chatCall: ChatCalls){
        guard let userId = chatCall.withUserId else {return}
        let call = callClient()?.callUser(withId: userId)
        let callVC = CallVC()
        callVC.call = call
        let navController = UINavigationController(rootViewController: callVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    private func callClient() -> SINCallClient?{
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
       return sceneDelegate.client.call()
   }
    

    private func fetchCalls(){
        chatCalls.removeAll()
        showIndicatorView()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        CALL_REF.document(currentUserId).collection(currentUserId).order(by: "callDate", descending: true).limit(to: 20).addSnapshotListener({ (snapshot, error) in
            if let _ = error{
                self.dismissIndicatorView()
                return
            }
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty{
                print("Now Here")
                let sortedDictionary = ChatService.instance.dictionaryFromSnapshots(snapshots: snapshot.documents)
                for callDictionary in sortedDictionary{
                    let call = ChatCalls(dictionary: callDictionary)
                    self.chatCalls.append(call)
                }
            }
            self.dismissIndicatorView()
            self.collectionView.reloadData()
            print(self.chatCalls.count)
        })
    }
}
