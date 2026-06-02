//
//  Data+Hex.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation

public extension Data {
    /// Uppercase, unseparated hex (e.g. `"F11F"`).
    var hexString: String {
        map { String(format: "%02X", $0) }.joined()
    }

    /// Lowercase, unseparated hex (e.g. `"f11f"`).
    func hexEncodedString() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
