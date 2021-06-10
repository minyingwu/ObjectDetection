//
//  CVPixelBuffer+image.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/10.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import UIKit

extension CVPixelBuffer {
    
    var ciimage: CIImage {
        CIImage(cvPixelBuffer: self)
    }
    
    var cgimage: CGImage? {
        CIContext().createCGImage(ciimage, from: ciimage.extent)
    }
    
    var image: UIImage? {
        cgimage != nil ? UIImage(cgImage: cgimage!) : nil
    }
    
}
