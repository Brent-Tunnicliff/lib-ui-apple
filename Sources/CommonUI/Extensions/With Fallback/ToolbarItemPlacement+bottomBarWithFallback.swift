// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension ToolbarItemPlacement {
    /// Returns `.bottomBar` if supported by platform, otherwise uses fallback style.
    public static func bottomBarWithFallback(
        _ fallback: ToolbarItemPlacement = .automatic
    ) -> ToolbarItemPlacement {
        #if os(macOS)
            fallback
        #else
            .bottomBar
        #endif
    }
}
