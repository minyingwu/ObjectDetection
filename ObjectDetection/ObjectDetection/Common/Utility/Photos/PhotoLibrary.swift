//
//  PhotoLibrary.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/9.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import UIKit
import Photos

class PhotoLibrary {
    
    static func save(fileURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }) { success, error in
                if !success, let error = error {
                    printLog(tag: .utility, items: "Could not save file to photo library: \(error)")
                }
            }
        }
    }
    
    static func remove(fileURL: URL) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }catch {
            printLog(tag: .utility, items: "Could not remove file to photo library: \(error)")
        }
    }
    
}
