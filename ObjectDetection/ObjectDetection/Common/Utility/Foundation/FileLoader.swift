//
//  FileLoader.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/8.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import Foundation

final class FileLoader {
    
    static func loadURLPath(fileName: String = "people-detection", fileExtension: String = "mp4") -> URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }
    
}
