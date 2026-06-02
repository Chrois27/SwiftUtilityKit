import XCTest
@testable import SwiftUtilityKit

/// Official RFC 6238 Appendix B test vectors.
final class TOTPTests: XCTestCase {

    private func code(_ totp: TOTP, atUnix t: TimeInterval) -> String {
        totp.code(at: Date(timeIntervalSince1970: t))
    }

    func testRFC6238_SHA1() {
        // Seed = ASCII "12345678901234567890" (20 bytes), 8 digits, 30s step.
        let totp = TOTP(asciiSecret: "12345678901234567890", digits: 8, algorithm: .sha1)
        XCTAssertEqual(code(totp, atUnix: 59),          "94287082")
        XCTAssertEqual(code(totp, atUnix: 1111111109),  "07081804")
        XCTAssertEqual(code(totp, atUnix: 1111111111),  "14050471")
        XCTAssertEqual(code(totp, atUnix: 1234567890),  "89005924")
        XCTAssertEqual(code(totp, atUnix: 2000000000),  "69279037")
        XCTAssertEqual(code(totp, atUnix: 20000000000), "65353130")
    }

    func testRFC6238_SHA256() {
        // 32-byte ASCII seed for SHA-256.
        let totp = TOTP(asciiSecret: "12345678901234567890123456789012", digits: 8, algorithm: .sha256)
        XCTAssertEqual(code(totp, atUnix: 59),         "46119246")
        XCTAssertEqual(code(totp, atUnix: 1111111109), "68084774")
    }

    func testRFC6238_SHA512() {
        // 64-byte ASCII seed for SHA-512.
        let totp = TOTP(asciiSecret: "1234567890123456789012345678901234567890123456789012345678901234",
                        digits: 8, algorithm: .sha512)
        XCTAssertEqual(code(totp, atUnix: 59),         "90693936")
        XCTAssertEqual(code(totp, atUnix: 1111111109), "25091201")
    }

    func testDefaultIsSixDigits() {
        let totp = TOTP(asciiSecret: "12345678901234567890")
        XCTAssertEqual(code(totp, atUnix: 59).count, 6)
        XCTAssertEqual(code(totp, atUnix: 59), "287082")  // last 6 of 94287082
    }

    func testSecondsRemaining() {
        let totp = TOTP(asciiSecret: "x", period: 30)
        XCTAssertEqual(totp.secondsRemaining(at: Date(timeIntervalSince1970: 25)), 5, accuracy: 0.001)
        XCTAssertEqual(totp.secondsRemaining(at: Date(timeIntervalSince1970: 60)), 30, accuracy: 0.001)
    }
}

final class HMACTests: XCTestCase {
    func testRFC2202_SHA1() {
        // key = 20×0x0b, data = "Hi There"  →  known digest.
        let key = Data(repeating: 0x0b, count: 20)
        let mac = HMAC.authenticate(Data("Hi There".utf8), key: key, using: .sha1)
        XCTAssertEqual(mac.hexEncodedString(), "b617318655057264e28bc0b6fb378c8ef146be00")
    }
}

final class DataHexTests: XCTestCase {
    func testHexEncodings() {
        let data = Data([0xF1, 0x1F, 0x0A])
        XCTAssertEqual(data.hexString, "F11F0A")
        XCTAssertEqual(data.hexEncodedString(), "f11f0a")
    }
}

final class LocalizationTests: XCTestCase {
    func testSupportedDetection() {
        XCTAssertTrue(Localization.isSupported("en"))
        XCTAssertFalse(Localization.isSupported("zz-not-a-language"))
    }

    func testSetLanguageRejectsUnsupported() {
        XCTAssertFalse(Localization.setLanguage("zz-not-a-language"))
    }
}

final class HTTPCookiePersistenceTests: XCTestCase {
    func testPropertyDictionaryRoundTrip() throws {
        let original = HTTPCookie(properties: [
            .name: "sid", .value: "abc123", .domain: "example.com", .path: "/"
        ])
        let cookie = try XCTUnwrap(original)
        let rebuilt = HTTPCookie.from(dictionary: cookie.propertyDictionary)
        XCTAssertEqual(rebuilt?.name, "sid")
        XCTAssertEqual(rebuilt?.value, "abc123")
        XCTAssertEqual(rebuilt?.domain, "example.com")
    }
}
