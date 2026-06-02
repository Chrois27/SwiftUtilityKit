//
//  WebViewCacheManager.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

#if canImport(WebKit)
import Foundation
@preconcurrency import WebKit

/// Clears a `WKWebView`'s disk/memory cache while *preserving* records whose
/// display name matches any of the configured substrings — typically session
/// cookies you don't want to log the user out of.
public final class WebViewCacheManager {

    public static let shared = WebViewCacheManager()
    private init() {}

    /// - Parameter preserving: display-name substrings to keep (default: `["session"]`).
    public func clearCache(preserving: [String] = ["session"], completion: (() -> Void)? = nil) {
        let store = WKWebsiteDataStore.default()
        let types: Set<String> = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]

        store.fetchDataRecords(ofTypes: types) { records in
            let removable = records.filter { record in
                !preserving.contains { record.displayName.contains($0) }
            }
            store.removeData(ofTypes: types, for: removable) {
                completion?()
            }
        }
    }
}
#endif
