// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Applies `numberPad` keyboard type if supported by platform.
    public func keyboardTypeNumberPadIfSupported() -> some View {
        #if os(macOS) || os(watchOS)
            self
        #else
            keyboardType(.numberPad)
        #endif
    }
}
