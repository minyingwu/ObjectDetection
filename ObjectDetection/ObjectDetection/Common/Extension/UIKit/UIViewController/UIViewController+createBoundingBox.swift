//
//  UIViewController+createBoundingBox.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/10.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import CoreMedia
import CoreML
import UIKit
import Vision

extension UIViewController {
    
    func createMLBoundingBox(maxBoundingBox: Int) -> (boundingBoxViews: [BoundingBoxView], colors: [String: UIColor]){
        let coreMLModel = MobileNetV2_SSDLite()
        var boundingBoxViews = [BoundingBoxView]()
        var colors: [String: UIColor] = [:]
        
        for _ in 0 ..< maxBoundingBox {
            boundingBoxViews.append(BoundingBoxView())
        }

        // The label names are stored inside the MLModel's metadata.
        guard let userDefined = coreMLModel.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String],
              let allLabels = userDefined["classes"] else {
            fatalError("Missing metadata")
        }

        let labels = allLabels.components(separatedBy: ",")

        // Assign random colors to the classes.
        for label in labels {
            colors[label] = UIColor(red: CGFloat.random(in: 0...1),
                                    green: CGFloat.random(in: 0...1),
                                    blue: CGFloat.random(in: 0...1),
                                    alpha: 1)
        }

        // Add the bounding box layers to the UI, on top of the video preview.
        for box in boundingBoxViews {
            box.addToLayer(self.view.layer)
        }
        return (boundingBoxViews, colors)
    }
    
}
