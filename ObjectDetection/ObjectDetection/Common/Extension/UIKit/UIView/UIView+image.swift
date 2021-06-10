//
//  UIView+image.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/9.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import UIKit

extension UIView {
    
    var renderImage: UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
    
}
