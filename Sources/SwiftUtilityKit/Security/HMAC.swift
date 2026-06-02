//
//  HMAC.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation
import CommonCrypto

/// Hash function backing an HMAC.
public enum HMACAlgorithm {
    case sha1
    case sha256
    case sha512

    var ccAlgorithm: CCHmacAlgorithm {
        switch self {
        case .sha1:   return CCHmacAlgorithm(kCCHmacAlgSHA1)
        case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
        case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
        }
    }

    var digestLength: Int {
        switch self {
        case .sha1:   return Int(CC_SHA1_DIGEST_LENGTH)
        case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
        case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }
}

/// Keyed-hash message authentication code (HMAC) over CommonCrypto.
public enum HMAC {
    public static func authenticate(_ message: Data, key: Data, using algorithm: HMACAlgorithm) -> Data {
        var mac = [UInt8](repeating: 0, count: algorithm.digestLength)
        key.withUnsafeBytes { keyBytes in
            message.withUnsafeBytes { messageBytes in
                CCHmac(
                    algorithm.ccAlgorithm,
                    keyBytes.baseAddress, key.count,
                    messageBytes.baseAddress, message.count,
                    &mac
                )
            }
        }
        return Data(mac)
    }
}
