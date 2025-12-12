// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Returns `true` if the platform supports the navigation subtitle.
    ///
    /// This is useful to know if we need to add the content somewhere else in the View.
    public var isNavigationSubtitleSupported: Bool {
        navigationSubtitleIfSupportedConfiguration.isSupported
    }

    /// Applies input to the navigation subtitle if supported by platform.
    public func navigationSubtitleIfSupported(_ value: Text) -> some View {
        navigationSubtitleIfSupportedConfiguration.action(value)
    }

    // Grouped them together so the logic of setting and if it is supported is together with the same conditions.
    private var navigationSubtitleIfSupportedConfiguration: (action: (Text) -> some View, isSupported: Bool) {
        #if os(tvOS) || os(visionOS) || os(watchOS)
            ({ _ in self }, false)
        #else
            (navigationSubtitle, true)
        #endif
    }
}
