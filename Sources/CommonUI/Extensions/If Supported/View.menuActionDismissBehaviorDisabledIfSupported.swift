// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Applies `menuActionDismissBehavior(.disabled)` if supported by platform.
    public func menuActionDismissBehaviorDisabledIfSupported() -> some View {
        #if os(macOS) || os(watchOS)
            self
        #else
            menuActionDismissBehavior(.disabled)
        #endif
    }
}
