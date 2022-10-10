//
//  CallVC.swift
//  Flytant
//
//  Created by Vivek Rai on 18/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class CallVC: UIViewController, SINCallDelegate {
    
//    MARK: - Views
    var speaker = false
    var mute = false
    var durationTimer: Timer! = nil
    var call: SINCall!
    var callanswered = false

//    MARK: - Views
    let nameLabel = FLabel(backgroundColor: UIColor.clear, text: "Unknown", font: UIFont.boldSystemFont(ofSize: 28), textAlignment: .center, textColor: UIColor.white)
    let timeLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.systemFont(ofSize: 18), textAlignment: .center, textColor: UIColor(red: 244/255, green: 246/255, blue: 247/255, alpha: 1))
    let profileImageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 70, image: UIImage(named: "avatarPlaceholder")!)
    let muteButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 12))
    let speakerButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 12))
    let receiveCallButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 12))
    let dismissCallButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 12))
    let hangUpCallButton = FButton(backgroundColor: UIColor.clear, title: "", cornerRadius: 0, titleColor: UIColor.clear, font: UIFont.boldSystemFont(ofSize: 12))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        configueViews()
        setUpCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        tabBarController?.tabBar.isHidden = true
        setUpViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.black, UIColor.black, UIColor.black], startPoint: .topLeft, endPoint: .topRight)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func configueViews(){
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 24)
        
        view.addSubview(timeLabel)
        timeLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: timeLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(muteButton)
        muteButton.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        muteButton.setImage(UIImage(named: "mute"), for: .normal)
        muteButton.addTarget(self, action: #selector(handleMute), for: .touchUpInside)
        
        view.addSubview(speakerButton)
        speakerButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 80, height: 80)
        speakerButton.setImage(UIImage(named: "speaker"), for: .normal)
        speakerButton.addTarget(self, action: #selector(handleSpeaker), for: .touchUpInside)
        
        view.addSubview(receiveCallButton)
        receiveCallButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 80, height: 80)
        receiveCallButton.setImage(UIImage(named: "answer"), for: .normal)
        receiveCallButton.addTarget(self, action: #selector(handleReceive), for: .touchUpInside)
        
        view.addSubview(dismissCallButton)
        dismissCallButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 80, height: 80)
        dismissCallButton.setImage(UIImage(named: "hangup"), for: .normal)
        dismissCallButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        view.addSubview(hangUpCallButton)
        hangUpCallButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 80, height: 80)
        hangUpCallButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hangUpCallButton.setImage(UIImage(named: "hangup"), for: .normal)
        hangUpCallButton.addTarget(self, action: #selector(handleHangUp), for: .touchUpInside)
    }
    
    private func setUpViews(){
        nameLabel.text = "Unknown"
        guard let id = call.remoteUserId else {return}
        
        DataService.instance.fetchPartnerUser(with: id) { (user) in
            self.nameLabel.text = user.username
            self.profileImageView.loadImage(with: user.profileImageURL)
        }
    }
    
    private func setUpCall(){
        call.delegate = self
        if call.direction == SINCallDirection.incoming{
            showButtons()
            audioController()?.startPlayingSoundFile(pathForSound(soundName: "incoming"), loop: true)
        }else{
            callanswered = true
            setCallStatus(text: "Calling...")
            showButtons()
        }
    }
    
//    MARK: - Update UI
    
    private func setCallStatus(text: String){
        timeLabel.text = text
    }

    private func showButtons(){
        if callanswered{
            dismissCallButton.isHidden = true
            receiveCallButton.isHidden = true
            hangUpCallButton.isHidden = false
            muteButton.isHidden = false
            speakerButton.isHidden = false
        }else{
            dismissCallButton.isHidden = false
            receiveCallButton.isHidden = false
            hangUpCallButton.isHidden = true
            muteButton.isHidden = true
            speakerButton.isHidden = true
        }
    }
    
    private func audioController() -> SINAudioController?{
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
        return sceneDelegate.client.audioController()
    }
    
    //this is not called
    private func setCall(call: SINCall){
        self.call = call
        call.delegate = self
        
    }
    
    private func pathForSound(soundName: String) -> String{
        return Bundle.main.path(forResource: soundName, ofType: "wav")!
    }
    
//    MARK: - SINCallDelegate
    
    func callDidProgress(_ call: SINCall!) {
        setCall(call: call)
        debugPrint("Did Progress")
        setCallStatus(text: "Ringing")
        audioController()?.startPlayingSoundFile(pathForSound(soundName: "ringback"), loop: true)
    }
    
    func callDidEstablish(_ call: SINCall!) {
        debugPrint("Did Establish")
        startCallDurationTimer()
        showButtons()
        audioController()?.stopPlayingSoundFile()
    }
    
    func callDidEnd(_ call: SINCall!) {
        debugPrint("Did End")
        stopCallDurationTimer()
        audioController()?.stopPlayingSoundFile()
        dismiss(animated: true, completion: nil)
    }
    
//    MARK: - Timer
    
    @objc func onDuration(){
        let duration = Date().timeIntervalSince(call.details.establishedTime)
        updateTimerLabel(seconds: Int(duration))
    }
    
    private func updateTimerLabel(seconds: Int){
        let min = String(format: "%02d", (seconds/60))
        let sec = String(format: "%02d", (seconds%60))
        setCallStatus(text: "\(min) : \(sec)")
    }
    
    private func startCallDurationTimer(){
        self.durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onDuration), userInfo: nil, repeats: true)
    }
    
    private func stopCallDurationTimer(){
        if durationTimer != nil{
            durationTimer.invalidate()
            durationTimer = nil
        }
    }
    
//    MARK: - Handlers
    
    @objc private func handleMute(){
        if mute{
            audioController()?.unmute()
            muteButton.setImage(UIImage(named: "mute"), for: .normal)
        }else{
            audioController()?.mute()
            muteButton.setImage(UIImage(named: "muteSelected"), for: .normal)
        }
        mute = !mute
    }
    
    @objc private func handleSpeaker(){
        if !speaker{
            audioController()?.enableSpeaker()
            speakerButton.setImage(UIImage(named: "speakerSelected"), for: .normal)
        }else{
            audioController()?.disableSpeaker()
            speakerButton.setImage(UIImage(named: "speaker"), for: .normal)
        }
        speaker = !speaker
    }
    
    @objc private func handleReceive(){
        callanswered = true
        showButtons()
        audioController()?.stopPlayingSoundFile()
        call.answer()
    }
    
    @objc private func handleDismiss(){
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleHangUp(){
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
}

