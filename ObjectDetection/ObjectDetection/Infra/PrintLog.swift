//
//  PrintLog.swift
//  ObjectDetection
//
//  Created by Victor on 2021/6/10.
//  Copyright © 2021 MachineThink. All rights reserved.
//

import Foundation

public func printLog(tag: LogTag,
              items: Any...,
              separator: String = " ",
              terminator: String = "\n") {
    #if DEBUG
        let logString: String = "\(tag.description ): \(items[0])"
        Swift.print(logString, separator:separator, terminator: terminator)
    #endif
}

public enum LogTag {
    case application
    case infrastructure(infrastructureTag)
    case presentation
    case domain
    case data
    case utility
    
    public enum infrastructureTag {
        case `default`
        case networking
    }
}

extension LogTag {
    public var description: String {
        switch self {
        case .application: return "Application"
        case .infrastructure(.default): return "Infrastructure"
        case .infrastructure(.networking): return "Infrastructure.Networking"
        case .presentation: return "Presentation"
        case .domain: return "Domain"
        case .data: return "Data"
        case .utility: return "Utility"
        }
    }
}

