// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

/// Wrapper that allows using Menu on all platforms.
///
/// If a platform does not support Menu, it will fallback to using a button and sheet approach.
public struct MenuWithFallback<Content, Label>: View where Content: View, Label: View {
    @State private var isFallbackPresented = false
    private let content: Content
    private let label: Label

    /// Creates a menu or button/sheet with a specified content and label.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }

    /// The content and behavior of the view.
    public var body: some View {
        #if os(watchOS)
            fallbackContent
        #else
            Menu {
                content
            } label: {
                label
            }
        #endif

    }

    private var fallbackContent: some View {
        Button(action: { isFallbackPresented = true }, label: { label })
            .sheet(isPresented: $isFallbackPresented) {
                List {
                    content
                }
            }
    }
}
