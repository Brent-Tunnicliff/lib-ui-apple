// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Applies `roundedBorder` text field style if supported by platform.
    public func textFieldStyleRoundedBorderIfSupported() -> some View {
        #if os(watchOS) || os(tvOS)
            self
        #else
            textFieldStyleRoundedBorder()
        #endif
    }

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    private func textFieldStyleRoundedBorder() -> some View {
        textFieldStyle(.roundedBorder)
    }
}
