//
//  shuwdbkjndlm.swift
//  Flytant
//
//  Created by Vivek Rai on 02/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCell {
  
  var artworkImageView: UIImageView { get }
  var titleLabel: UILabel { get }
  var genreLabel: UILabel { get }
  var yearLabel: UILabel { get }
  
}
