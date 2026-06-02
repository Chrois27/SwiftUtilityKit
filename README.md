# SwiftUtilityKit

[![CI](https://github.com/Chrois27/SwiftUtilityKit/actions/workflows/ci.yml/badge.svg)](https://github.com/Chrois27/SwiftUtilityKit/actions/workflows/ci.yml)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2013+%20%7C%20macOS%2011+-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/Chrois27/SwiftUtilityKit?sort=semver)](https://github.com/Chrois27/SwiftUtilityKit/releases)

A small, dependency-free collection of production-tested iOS/macOS utilities,
extracted and generalized from real apps. Pure-Swift components are cross-platform
and unit-tested; UIKit/WebKit pieces are compiled in only where available
(`#if canImport(...)`).

## Installation

Swift Package Manager — add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Chrois27/SwiftUtilityKit.git", from: "1.0.0")
]
```

Or in Xcode: **File ▸ Add Package Dependencies…** and paste the repository URL.

## Components

### 🔐 TOTP — RFC 6238 one-time passwords
Standards-compliant time-based OTP (and RFC 4226 HOTP) over HMAC-SHA1/256/512,
with configurable digits, period and epoch.

```swift
let totp = TOTP(asciiSecret: "12345678901234567890")  // SHA1, 6 digits, 30s
totp.code()                       // e.g. "287082"
totp.code(at: date)               // code at a specific instant
totp.secondsRemaining()           // for a countdown ring
```

Verified against the **official RFC 6238 Appendix B test vectors** for all three
hash algorithms (see tests).

### 🧱 HMAC
A thin, typed `HMAC.authenticate(_:key:using:)` over CommonCrypto
(SHA1 / SHA256 / SHA512). Verified against RFC 2202.

### 🌐 Localization
Runtime in-app language switching via `AppleLanguages`, with a change notification
so the UI can reload without an app restart.

```swift
Localization.setLanguage("ko")
Localization.currentLanguage()    // "ko"
```

### 🍪 HTTPCookieStorage persistence
`clear()` / `save()` / `restore()` plus `HTTPCookie ↔︎ property-dictionary`
conversion — handy for surviving cookies across reinstalls or hybrid web sessions.

### 📝 Log
A call-site-aware `os_log` wrapper with ready-made categories.

```swift
Log.debug("loaded \(items.count) items")   // [File.swift:42] viewDidLoad — loaded 8 items
Log.error("decode failed: \(error)")
```

### 🔢 Data+Hex
`Data.hexString` (uppercase) and `hexEncodedString()` (lowercase).

### 📱 UIKit / WebKit *(iOS)*
- `DisabledButton` — a `UIButton` that still reports taps while disabled.
- `WebViewCacheManager` — clears `WKWebView` cache while preserving chosen records
  (e.g. session cookies).

## Build & test

```bash
swift build
swift test      # 10 tests — RFC 6238/4226 TOTP, RFC 2202 HMAC, hex, localization, cookies
```

## Layout

```
Sources/SwiftUtilityKit/
├── Security/    TOTP.swift · HMAC.swift
├── Logging/     Log.swift
├── Foundation/  Data+Hex.swift · Localization.swift · HTTPCookieStorage+Persistence.swift
├── WebKit/      WebViewCacheManager.swift   (#if canImport(WebKit))
└── UIKit/       DisabledButton.swift         (#if canImport(UIKit))
```

## License

MIT © Chris Choi
