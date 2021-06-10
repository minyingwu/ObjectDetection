//
//  Predictor.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/10.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import CoreMedia
import CoreML
import UIKit
import Vision

protocol PredictDelegate: AnyObject {
    func processObservations(from pixelBuffer: CVPixelBuffer?, for request: VNRequest, error: Error?)
}

class Predictor {
    
    weak var delegate: PredictDelegate?
    
    var coreMLModel: MobileNetV2_SSDLite
    
    private var currentBuffer: CVPixelBuffer?
    
    init(coreMLModel: MobileNetV2_SSDLite) {
        self.coreMLModel = coreMLModel
    }
    
    lazy var visionModel: VNCoreMLModel = {
        do {
            return try VNCoreMLModel(for: coreMLModel.model)
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    lazy var visionRequest: VNCoreMLRequest = {
        let request = VNCoreMLRequest(model: visionModel, completionHandler: {
            [weak self] request, error in
            self?.delegate?.processObservations(from: self?.currentBuffer, for: request, error: error)
        })
        
        // NOTE: If you use another crop/scale option, you must also change
        // how the BoundingBoxView objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
        return request
    }()
    
    func predict(sampleBuffer: CMSampleBuffer) {
        if currentBuffer == nil,
           let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            self.currentBuffer = pixelBuffer
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
            do {
                try handler.perform([self.visionRequest])
            }catch {
                printLog(tag: .utility, items: "Failed to perform Vision request: \(error)")
            }
            currentBuffer = nil
        }
    }
    
}
