//
//  DemoHelper.swift
//  Flytant
//
//  Created by Vivek Rai on 02/01/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

extension SearchClient {
  static let demo = Self(appID: "AFZLHKQDJB", apiKey: "a134c1f100e57c7ff779fbf8f60435af")
}

extension Index {

  static func demo(withName demoIndexName: IndexName) -> Index {
    return SearchClient.demo.index(withName: demoIndexName)
  }

}

struct DemoHelper {
  public static let appID = "AFZLHKQDJB"
  public static let apiKey = "a134c1f100e57c7ff779fbf8f60435af"
}

extension IndexPath {
  static let zero = IndexPath(row: 0, section: 0)
}
