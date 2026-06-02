//
//  TOTP.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation

/// Time-based One-Time Password generator (RFC 6238).
///
/// ```swift
/// let totp = TOTP(asciiSecret: "12345678901234567890")  // SHA1, 6 digits, 30s
/// totp.code()                       // current code
/// totp.code(at: someDate)           // code for a specific instant
/// ```
public struct TOTP {

    public let secret: Data
    public let digits: Int
    public let period: TimeInterval
    public let epoch: Date
    public let algorithm: HMACAlgorithm

    public init(
        secret: Data,
        digits: Int = 6,
        period: TimeInterval = 30,
        epoch: Date = Date(timeIntervalSince1970: 0),
        algorithm: HMACAlgorithm = .sha1
    ) {
        precondition((1...9).contains(digits), "digits must be 1...9")
        precondition(period > 0, "period must be positive")
        self.secret = secret
        self.digits = digits
        self.period = period
        self.epoch = epoch
        self.algorithm = algorithm
    }

    /// Convenience for the common case of an ASCII shared secret.
    public init(
        asciiSecret: String,
        digits: Int = 6,
        period: TimeInterval = 30,
        epoch: Date = Date(timeIntervalSince1970: 0),
        algorithm: HMACAlgorithm = .sha1
    ) {
        self.init(secret: Data(asciiSecret.utf8), digits: digits, period: period, epoch: epoch, algorithm: algorithm)
    }

    /// The code valid at `date` (defaults to now).
    public func code(at date: Date = Date()) -> String {
        let counter = UInt64(date.timeIntervalSince(epoch) / period)
        return code(counter: counter)
    }

    /// HOTP-style code for an explicit moving-factor counter (RFC 4226).
    public func code(counter: UInt64) -> String {
        var bigEndianCounter = counter.bigEndian
        let counterData = withUnsafeBytes(of: &bigEndianCounter) { Data($0) }

        let hash = HMAC.authenticate(counterData, key: secret, using: algorithm)

        // Dynamic truncation (RFC 4226 §5.3).
        let offset = Int(hash[hash.count - 1] & 0x0F)
        let binary = (UInt32(hash[offset] & 0x7F) << 24)
            | (UInt32(hash[offset + 1]) << 16)
            | (UInt32(hash[offset + 2]) << 8)
            | UInt32(hash[offset + 3])

        let modulus = UInt32(pow(10.0, Double(digits)))
        return String(format: "%0\(digits)d", binary % modulus)
    }

    /// Seconds until the current code rolls over — handy for a countdown UI.
    public func secondsRemaining(at date: Date = Date()) -> TimeInterval {
        period - date.timeIntervalSince(epoch).truncatingRemainder(dividingBy: period)
    }
}
