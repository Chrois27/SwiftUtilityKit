//
//  Log.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation
import os.log

public extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "SwiftUtilityKit"
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug   = OSLog(subsystem: subsystem, category: "Debug")
    static let info    = OSLog(subsystem: subsystem, category: "Info")
    static let error   = OSLog(subsystem: subsystem, category: "Error")
}

/// Thin, call-site-aware wrapper over `os_log` with ready-made categories.
///
/// ```swift
/// Log.debug("loaded \(items.count) items")
/// Log.error("decode failed: \(error)")
/// ```
public enum Log {

    public enum Level {
        case debug, info, network, error
        case custom(category: String)

        var osLog: OSLog {
            switch self {
            case .debug:               return .debug
            case .info:                return .info
            case .network:             return .network
            case .error:               return .error
            case .custom(let category):
                return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "SwiftUtilityKit", category: category)
            }
        }

        var type: OSLogType {
            switch self {
            case .debug:    return .debug
            case .info:     return .info
            case .network:  return .default
            case .error:    return .error
            case .custom:   return .default
            }
        }
    }

    public static func debug(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        write(.debug, message(), file: file, function: function, line: line)
    }

    public static func info(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        write(.info, message(), file: file, function: function, line: line)
    }

    public static func network(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        write(.network, message(), file: file, function: function, line: line)
    }

    public static func error(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        write(.error, message(), file: file, function: function, line: line)
    }

    private static func write(_ level: Level, _ message: String, file: String, function: String, line: Int) {
        let filename = (file as NSString).lastPathComponent
        os_log("%{public}@", log: level.osLog, type: level.type, "[\(filename):\(line)] \(function) — \(message)")
    }
}
