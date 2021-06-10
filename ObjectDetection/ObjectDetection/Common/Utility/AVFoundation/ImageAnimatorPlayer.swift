//
//  ImageAnimatorPlayer.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/9.
//  Copyright © 2021 MachineThink. All rights reserved.
//
// Reference:
// https://stackoverflow.com/questions/3741323/how-do-i-export-uiimage-array-as-a-movie

import UIKit
import AVFoundation

class ImageAnimatorPlayer {
    
    let kTimescale: Int32 = 600
    let settings: RenderSettings
    let videoWriter: VideoWriter
    
    var images: [UIImage]
    
    var frameNum = 0
    
    init(settings: RenderSettings, images: [UIImage]) {
        self.settings = settings
        self.images = images
        videoWriter = VideoWriter(renderSettings: settings)
    }
    
    func render(completion: (()->Void)?) {
        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
        PhotoLibrary.remove(fileURL: settings.outputURL)
        
        videoWriter.start()
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) {
            PhotoLibrary.save(fileURL: self.settings.outputURL)
            completion?()
        }
    }
    
    func appendPixelBuffers(writer: VideoWriter) -> Bool {
        let frameDuration = CMTimeMake(value: Int64(kTimescale / settings.fps),
                                       timescale: kTimescale)
        
        while !images.isEmpty {
            if writer.isReadyForData == false {
                // Inform writer we have more buffers to write.
                return false
            }
            
            let image = images.removeFirst()
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = videoWriter.addImage(image: image, withPresentationTime: presentationTime)
            if !success {
                fatalError("addImage() failed")
            }
            
            frameNum += 1
        }

        // Inform writer all buffers have been written.
        return true
    }
    
}
