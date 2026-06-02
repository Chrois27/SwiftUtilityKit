//
//  DisabledButton.swift
//  SwiftUtilityKit
//
//  Created by Chris Choi.
//

#if canImport(UIKit)
import UIKit

/// A `UIButton` that reports a tap through `onDisabledTap` whenever it is tapped
/// while `isEnabled == false`, instead of silently swallowing the gesture.
///
/// Pair it with a transparent overlay (or keep the control enabled and gate the
/// primary action yourself) when you want the greyed-out button to still nudge
/// the user — e.g. "complete the form first".
public final class DisabledButton: UIButton {

    /// Invoked on tap while the button is disabled.
    public var onDisabledTap: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        guard !isEnabled else { return }
        onDisabledTap?()
    }
}
#endif
