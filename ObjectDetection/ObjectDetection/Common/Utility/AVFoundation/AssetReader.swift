//
//  AssetReader.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/8.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import Foundation
import AVFoundation

class AssetReader {
    
    static let shared: AssetReader = AssetReader()
    private init() {}
    
    var fps: Int = 0
    
    func read(url: URL, mediaType: AVMediaType, outputBuffer: ((CMSampleBuffer) -> Void)? = nil, completeHandler: ((Bool) -> Void)? = nil) {
        let asset = AVAsset(url: url)
        let reader = try? AVAssetReader(asset: asset)
        guard let videoTrack = asset.tracks(withMediaType: mediaType).first else { return }
        
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings:[kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB)])
        fps = Int(videoTrack.nominalFrameRate)
        
        reader?.add(trackReaderOutput)
        reader?.startReading()
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
            outputBuffer?(sampleBuffer)
        }
        completeHandler?(true)
    }
    
}
