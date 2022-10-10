//
//  CardView.swift
//  Flytant
//
//  Created by Vivek Rai on 29/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

enum SwipeDirection: Int{
    case left = -1
    case right = 1
}

class CardView: UIView{
    
//    MARK: - Properties
    
    let gradientLayer = CAGradientLayer()
    let viewModel: CardViewModel
    var delegate: CardViewDelegate?
    
//    MARK: - Views
    
    let imageView = FImageView(backgroundColor: UIColor.clear, cornerRadius: 5, image: UIImage())
    
    let infoLabel = FLabel(backgroundColor: UIColor.clear, text: "", font: UIFont.boldSystemFont(ofSize: 14), textAlignment: .left, textColor: UIColor.white)
  
    let infoButton = UIButton(type: .infoLight)
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 246/255, green: 11/255, blue: 101/255, alpha: 1)
        layer.cornerRadius = 5
        clipsToBounds = true
        
        configureGestureRecognizer()
        configureImageView()
        configureGradientLayer()
        configureInfoLabel()
        configureInfoButton()
        
        guard let imageUrl = viewModel.imageUrl else {return}
        imageView.loadImage(with: imageUrl)
        infoLabel.attributedText = viewModel.userInfoText
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    private func configureImageView(){
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func configureInfoLabel(){
        infoLabel.numberOfLines = 2
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 48, width: 0, height: 0)
    }
    
    private func configureInfoButton(){
        addSubview(infoButton)
        infoButton.tintColor = UIColor.white
        infoButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 40, height: 40)
        infoButton.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor).isActive = true
        infoButton.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        
    }
    
    private func configureGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    private func configureGestureRecognizer(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func resetCardPosition(sender: UIPanGestureRecognizer){
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard{
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            }else{
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard{
                //self.removeFromSuperview()
                let didLike = direction == .right
                self.delegate?.saveSwipe(for: self, didLike: didLike)
            }
        }
    }
    
    private func panCard(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform  = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
//    MARK: - Handlers
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            superview?.subviews.forEach({$0.layer.removeAllAnimations()})
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleInfo(){
        delegate?.showProfile(for: self, user: viewModel.user)
    }
    @objc func handleTap(sender: UITapGestureRecognizer){
//        let location = sender.location(in: nil).x
//        let showNextPhoto = location > self.frame.width/2
//        if showNextPhoto{
//            viewModel.showNextPhoto()
//        }else{
//            viewModel.showPreviousPhoto()
//        }
//        imageView.image = viewModel.imageToShow
    }
}
