//
//  TwitterUserController.swift
//  Flytantapp
//
//  Created by Vivek Singh Mehta on 02/10/21.
//

import UIKit
import OhhAuth
import Alamofire

protocol TwitterDelegate: AnyObject {
    func twitterID(id: String, stats: TwitterStatsModel)
    func twitterUserCancled()
}

class TwitterUserController: UIViewController {
    
    
    enum CardViewState {
          case expanded
          case normal
      }

    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var twitterhandlerLabel: UILabel!
    @IBOutlet weak var handlerTF: UITextField!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var notYourProfileButton: UIButton!
    @IBOutlet weak var twitterButtonTopConstraint: NSLayoutConstraint!
    
    var backingImage: UIImage?
    weak var delegate: TwitterDelegate?
    
    var cardViewState : CardViewState = .normal
    var cardPanStartingTopConstant: CGFloat = 30.0
    var getTweets: Bool = false
    var userTwitterData: TwitterDataModel?
    var userTwitterStats: TwitterStatsModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
        dimmingView.alpha = 0.0
        addTapGesture()
        addPanGesture()
        twitterInit()
    }
    
    private func twitterInit() {
        nameLabel.text = "Enter your twitter handler"
        twitterhandlerLabel.isHidden = true
        notYourProfileButton.isHidden = true
    }
    

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        showCard()
    }
    
    fileprivate func addPanGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
    }
    
    fileprivate func addTapGesture() {
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmingView.addGestureRecognizer(dimmerTap)
        dimmingView.isUserInteractionEnabled = true
    }
    
    fileprivate func viewInit() {
        backingImageView.image = backingImage
        cardView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        twitterButton.layer.cornerRadius = 8
        twitterButton.layer.masksToBounds = true
        
        
        let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
    }
    
    // @IBAction is required in front of the function name due to how selector works
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.twitterUserCancled()
        hideCardAndGoBack()
    }
    
    @IBAction func notYourProfileAction(_ sender: UIButton) {
        getTweets = false
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.twitterButtonTopConstraint.constant = 8
        }, completion: nil)
        notYourProfileButton.isHidden = true
        handlerTF.text = ""
        handlerTF.isHidden = false
        profileImageView.image = UIImage(named: "twitterMain")
        twitterInit()
    }
    
    
    @IBAction func getProfileAction(_ sender: UIButton) {
        if getTweets {
            if let stats = userTwitterStats {
            delegate?.twitterID(id: userTwitterData?.data?.id ?? "", stats: stats)
            }
            hideCardAndGoBack()
        } else {
            getTwitterData()
        }
    }
    
    private func getTwitterData() {
        let username = handlerTF.text ?? ""
        
        var req = URLRequest(url: URL(string: "https://api.twitter.com/2/users/by/username/" + username)!)
        
        req.oAuthSign(method: "GET", urlFormParameters: [:], consumerCredentials: TwitterConstants.CC, userCredentials: TwitterConstants.UC)
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                do {
                    let twitterData = try JSONDecoder().decode(TwitterDataModel.self, from: data)
                    if twitterData.data != nil {
                        self?.userTwitterData = twitterData
                        self?.getTwitterUserStats(model: twitterData)
                    } else {
                        print("Error in twitter data")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    private func getTwitterUserStats(model: TwitterDataModel) {
        
        var req = URLRequest(url: URL(string: "https://api.twitter.com/2/users?ids=\(model.data?.id ?? "")&user.fields=public_metrics,created_at,profile_image_url")!)
        req.oAuthSign(method: "GET", urlFormParameters: [:], consumerCredentials: TwitterConstants.CC, userCredentials: TwitterConstants.UC)
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                do {
                    let twitterstats = try JSONDecoder().decode(TwitterStatsModel.self, from: data)
                    if twitterstats.data != nil {
                        self?.showTwitterProfile(model: twitterstats)
                    } else {
                        print("Error")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    private func showTwitterProfile(model: TwitterStatsModel) {
        userTwitterStats = model
        let profileurl = model.data?.first?.profileImageURL ?? ""
        let username = model.data?.first?.username ?? ""
        let name = model.data?.first?.name ?? ""
        DispatchQueue.main.async {
            self.getTweets = true
            self.profileImageView.downloaded(from: URL(string: profileurl)!)
            self.nameLabel.text = name
            self.twitterhandlerLabel.text = "@" + username
            self.twitterhandlerLabel.isHidden = false
            self.twitterButton.setTitle("Get my tweets", for: .normal)
            self.handlerTF.isHidden = true
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                self.twitterButtonTopConstraint.constant = -20
            }, completion: nil)
            self.notYourProfileButton.isHidden = false
        }
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let translation = panRecognizer.translation(in: self.view)
        
        switch panRecognizer.state {
        case .began:
          cardPanStartingTopConstant = cardViewTopConstraint.constant
        case .changed :
          if self.cardPanStartingTopConstant + translation.y > 30.0 {
              self.cardViewTopConstraint.constant = self.cardPanStartingTopConstant + translation.y
          }
        case .ended :
          let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
            let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
            
            if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
              // show the card at expanded state
//              showCard(atState: .expanded)
                showCard(atState: .normal)
            } else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
              // show the card at normal state
              showCard(atState: .normal)
            } else {
              // hide the card and dismiss current view controller
              delegate?.twitterUserCancled()
              hideCardAndGoBack()
            }
        default:
          break
        }
     }
    
    private func hideCardAndGoBack() {
        self.view.layoutIfNeeded()
          
          // set the new top constraint value for card view
          // card view won't move down just yet, we need to call layoutIfNeeded()
          // to tell the app to refresh the frame/position of card view
          let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
            let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
            
            // move the card view to bottom of screen
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
          
          // move card down to bottom
          // create a new property animator
          let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
          })
          
          // hide dimmer view
          // this will animate the dimmerView alpha together with the card move down animation
          hideCard.addAnimations {
            self.dimmingView.alpha = 0.0
          }
          
          // when the animation completes, (position == .end means the animation has ended)
          // dismiss this view controller (if there is a presenting view controller)
          hideCard.addCompletion({ position in
            if position == .end {
              if(self.presentingViewController != nil) {
                self.dismiss(animated: false, completion: nil)
              }
            }
          })
          
          // run the animation
          hideCard.startAnimation()
    }
    
    private func showCard(atState: CardViewState = .normal) {
       
      // ensure there's no pending layout changes before animation runs
      self.view.layoutIfNeeded()
      
      // set the new top constraint value for card view
      // card view won't move up just yet, we need to call layoutIfNeeded()
      // to tell the app to refresh the frame/position of card view
      let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        
        if atState == .expanded {
          // if state is expanded, top constraint is 30pt away from safe area top
          cardViewTopConstraint.constant = 30.0
        } else {
          cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
        }
        
        cardPanStartingTopConstant = cardViewTopConstraint.constant
      
      // move card up from bottom
      // create a new property animator
      let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
        self.view.layoutIfNeeded()
      })
      
      // show dimmer view
      // this will animate the dimmerView alpha together with the card move up animation
      showCard.addAnimations {
        self.dimmingView.alpha = 0.7
      }
      
      // run the animation
      showCard.startAnimation()
    }
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
      let fullDimAlpha : CGFloat = 0.7
      
      // ensure safe area height and safe area bottom padding is not nil
      let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
      
      // when card view top constraint value is equal to this,
      // the dimmer view alpha is dimmest (0.7)
      let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
      
      // when card view top constraint value is equal to this,
      // the dimmer view alpha is lightest (0.0)
      let noDimPosition = safeAreaHeight + bottomPadding
      
      // if card view top constraint is lesser than fullDimPosition
      // it is dimmest
      if value < fullDimPosition {
        return fullDimAlpha
      }
      
      // if card view top constraint is more than noDimPosition
      // it is dimmest
      if value > noDimPosition {
        return 0.0
      }
      
      // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
      return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }

}

extension UIView  {
    // render the view within the view's bounds, then capture it as image
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
      return renderer.image(actions: { rendererContext in
        layer.render(in: rendererContext.cgContext)
    })
  }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
