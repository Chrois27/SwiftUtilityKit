//
//  Localization.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

import Foundation

/// Runtime in-app language switching backed by the `AppleLanguages` preference.
///
/// Posting ``languageChangedNotification`` lets the UI reload localized strings
/// without forcing the user to restart the app.
public enum Localization {

    public static let languageChangedNotification = Notification.Name("SwiftUtilityKit.LanguageChanged")

    /// Overrides the app language (e.g. `"en"`, `"fr"`, `"ko"`). No-op if unsupported.
    @discardableResult
    public static func setLanguage(_ languageCode: String) -> Bool {
        guard isSupported(languageCode) else { return false }
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        NotificationCenter.default.post(name: languageChangedNotification, object: nil)
        return true
    }

    /// The currently selected language code.
    public static func currentLanguage() -> String {
        let stored = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        return stored?.first ?? Locale.current.languageCode ?? "en"
    }

    public static func isSupported(_ languageCode: String) -> Bool {
        Locale.availableIdentifiers.contains(languageCode)
    }
}
