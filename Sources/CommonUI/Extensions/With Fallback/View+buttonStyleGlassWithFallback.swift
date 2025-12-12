// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

// TODO: Move below to UI package

extension View {
    /// Applies `.glass` to `buttonStyle` if supported by platform, otherwise uses fallback style.
    public func buttonStyleGlassWithFallback<ButtonStyle>(
        _ fallback: ButtonStyle
    ) -> some View where ButtonStyle: PrimitiveButtonStyle {
        #if os(visionOS)
            buttonStyle(fallback)
        #else
            buttonStyle(.glass)
        #endif
    }

    /// Applies `.glass` to `buttonStyle` if supported by platform, otherwise uses `.bordered` as fallback style.
    public func buttonStyleGlassWithFallback() -> some View {
        buttonStyleGlassWithFallback(.bordered)
    }
}
