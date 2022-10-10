//
//  File.swift
//  Flytant
//
//  Created by Vivek Rai on 02/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import UIKit
import InstantSearch

class MovieHitsTableViewController<HitType: Codable>: UITableViewController, HitsController {
    
  let cellIdentifier = "CellID"
  
  var hitsSource: HitsInteractor<HitType>?
  
  //MARK: - UITableViewDataSource
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hitsSource?.numberOfHits() ?? 0
    }
      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let hit = hitsSource?.hit(atIndex: indexPath.row)
        switch hit {
        case let movie as UserItem:
          (cell as? UIView & MovieCell).flatMap(MovieCellViewState().configure)?(movie)
        case let movieHit as Hit<UserItem>:
          MovieHitCellConfigurator.configure(cell)(movieHit)
        default:
          break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = hitsSource?.hit(atIndex: indexPath.row)
        switch hit {
        case let movie as UserItem:
//            let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//            socialProfileVC.username = movie.username
//            let presentVC = UINavigationController(rootViewController: socialProfileVC)
//            self.present(presentVC, animated: true)
            DataService.instance.fetchUserWithUsername(with: movie.username) { (user) in
                let socialProfileVC = SocialProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                socialProfileVC.user = user
                socialProfileVC.changeHeader = true
                let backButton = UIBarButtonItem()
                backButton.title = ""
                self.navigationItem.backBarButtonItem = backButton
                self.navigationController?.pushViewController(socialProfileVC, animated: true)
//                let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//                profileVC.user = user
//                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        default:
          break
        }
    }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }

  
}

