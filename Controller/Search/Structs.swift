//
//  Struicts.swift
//  Flytant
//
//  Created by Vivek Rai on 02/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation
import SDWebImage
import InstantSearch


struct MovieTableViewCellConfigurator: InstantSearch.CellConfigurable {
  
  static var cellIdentifier: String = "movieCell"
  
  typealias Model = UserItem
  
  let movie: UserItem
  
  init(model: UserItem, indexPath: IndexPath) {
    self.movie = model
  }

}

struct MovieCellViewState {
  
  func configure(_ cell: UIView & MovieCell) -> (UserItem) -> () {
    return { movie in
        cell.artworkImageView.sd_setImage(with: URL(string: movie.profileImageUrl), placeholderImage: UIImage(named: "")) { (_, _, _, _) in
        DispatchQueue.main.async {
          cell.setNeedsLayout()
        }
      }
      cell.titleLabel.text = "NO NAME"
        cell.yearLabel.text = movie.username
        
//      cell.genreLabel.text = movie.genre.joined(separator: ", ")
//      cell.yearLabel.text = String(movie.year)e
    }
  }
  
  
  
}

protocol CellConfigurable {
  associatedtype T
  static func configure(_ cell: UITableViewCell) -> (T) -> Void
}

struct MovieHitCellConfigurator: CellConfigurable {
   
  static func configure(_ cell: UITableViewCell) -> (Hit<UserItem>) -> Void {
    return { movieHit in
      let movie = movieHit.object
      if let highlightedTitle = movieHit.hightlightedString(forKey: "username") {
        if let textLabel = cell.textLabel {
          textLabel.attributedText = NSAttributedString(highlightedString: highlightedTitle, attributes: [.font:
            UIFont.systemFont(ofSize: textLabel.font.pointSize, weight: .black)])

        }
      }
      
        cell.detailTextLabel?.text = movie.username
        cell.imageView?.sd_setImage(with: URL(string: movie.profileImageUrl), completed: { (_, _, _, _) in
        cell.setNeedsLayout()
      })
    }
  }
  
}
