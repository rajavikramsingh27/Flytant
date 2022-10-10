//
//  Indicator.swift
//  Flytant
//
//  Created by Flytant on 27/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation


class Indicator {
    
    static let shared = Indicator()
    
    let clearView = UIView()
    let progress = ProgressIndicator(text: "")
    
    private init() {}
    
    func addIndicator(controller: UIViewController?) {
        if let view = controller?.view {
            DispatchQueue.main.async {
                self.clearView.backgroundColor = .clear
                view.addSubview(self.clearView)
                self.clearView.addSubview(self.progress)
                view.translatesAutoresizingMaskIntoConstraints = false
                self.clearView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                self.clearView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                self.clearView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                self.clearView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            }
        }
    }
    
    
    func removeIndicator(controller: UIViewController?) {
        DispatchQueue.main.async {
            self.clearView.removeFromSuperview()
        }
    }
}
