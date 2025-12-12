// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

extension View {
    /// Sets a close button to the keyboard if supported.
    public func toolbarKeyboardCloseButtonIfSupported(focused: FocusState<Bool>.Binding) -> some View {
        #if os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
            self
        #else
            textFieldStyleRoundedBorder(focused)
        #endif
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    private func textFieldStyleRoundedBorder(_ focused: FocusState<Bool>.Binding) -> some View {
        toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(role: .close) {
                    focused.wrappedValue = false
                }
            }
        }
    }
}
