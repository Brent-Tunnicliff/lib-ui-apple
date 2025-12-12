// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Applies input to `listRowSeparator` if supported by platform.
    public func listRowSeparatorIfSupported(_ visibility: Visibility) -> some View {
        #if os(tvOS) || os(watchOS)
            self
        #else
            listRowSeparator(visibility)
        #endif
    }
}
