//
//  UIView+Toast.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/10.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import UIKit

extension UIView {
    
    func showToast(text: String) {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = text
        
        showToast(label)
    }
    
    private func showToast(_ label: UILabel) {
        // Make suer there is no any toast showing on the screen
        self.hideToast()
        
        label.tag = 6666
        self.addSubview(label, constraints: [
            .equal(\.centerXAnchor),
            .equal(\.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
            label.alpha = 0.0
        }, completion: { complete in
            label.removeFromSuperview()
        })
    }
    
    func hideToast() {
        for view in self.subviews {
            if view is PaddingLabel, view.tag == 6666 {
                view.removeFromSuperview()
            }
        }
    }
}

