//
//  HTTPCookieStorage+Persistence.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation

public extension HTTPCookie {
    /// A property dictionary suitable for re-creating the cookie via `HTTPCookie(properties:)`.
    var propertyDictionary: [HTTPCookiePropertyKey: Any] {
        [
            .name: name,
            .value: value,
            .domain: domain,
            .path: path,
            .version: version,
            .expires: expiresDate ?? Date()
        ]
    }

    static func from(dictionary: [HTTPCookiePropertyKey: Any]) -> HTTPCookie? {
        HTTPCookie(properties: dictionary)
    }
}

public extension HTTPCookieStorage {

    /// Removes every cookie from the shared storage.
    static func clear() {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        cookies.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
    }

    /// Persists the shared storage's cookies into `UserDefaults` (expiry stored as epoch seconds).
    static func save(key: String = "persistedCookies") {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        let serialized: [[HTTPCookiePropertyKey: Any]] = cookies.map { cookie in
            var properties: [HTTPCookiePropertyKey: Any] = [
                .name: cookie.name,
                .value: cookie.value,
                .domain: cookie.domain,
                .path: cookie.path,
                .version: cookie.version
            ]
            if let expires = cookie.expiresDate {
                properties[.expires] = expires.timeIntervalSince1970
            }
            return properties
        }
        UserDefaults.standard.set(serialized, forKey: key)
    }

    /// Restores cookies previously written by ``save(key:)``.
    static func restore(key: String = "persistedCookies") {
        guard let stored = UserDefaults.standard.value(forKey: key) as? [[HTTPCookiePropertyKey: Any]] else { return }
        for var properties in stored {
            if let epoch = properties[.expires] as? TimeInterval {
                properties[.expires] = Date(timeIntervalSince1970: epoch)
            }
            if let cookie = HTTPCookie(properties: properties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}
