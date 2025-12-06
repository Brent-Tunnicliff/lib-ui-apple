// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

/// Wrapper that allows using Menu on all platforms.
///
/// If a platform does not support Menu, it will fallback to using a button and sheet approach.
public struct MenuWithFallback<Content, Label>: View where Content: View, Label: View {
    @State private var isFallbackPresented = false
    private let content: Content
    private let label: Label

    /// Creates a menu with a custom label.
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

// MARK: - Alternative init's

// MARK: init(_:content:)

extension MenuWithFallback where Label == Text {
    /// Creates a menu that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link’s localized title, which describes the contents of the menu.
    ///     - content: A group of menu items.
    public init(
        _ titleKey: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: { Label(titleKey) }
        )
    }

    /// Creates a menu that generates its label from a localized string resource.
    ///
    /// - Parameters:
    ///     - titleResource: Text resource for the link’s localized title, which describes the contents of the menu.
    ///     - content: A group of menu items.
    public init(
        _ titleResource: LocalizedStringResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: { Label(titleResource) }
        )
    }

    /// Creates a menu that generates its label from a string.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - content: A group of menu items.
    public init<Title>(
        _ title: Title,
        @ViewBuilder content: () -> Content
    ) where Title: StringProtocol {
        self.init(
            content: content,
            label: { Label(title) }
        )
    }
}

// MARK: init(_:image:content:)

extension MenuWithFallback where Label == SwiftUI.Label<Text, Image> {
    /// Creates a menu that generates its label from a localized string key and image resource.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link’s localized title, which describes the contents of the menu.
    ///     - image: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init(
        _ titleKey: LocalizedStringKey,
        image: ImageResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(titleKey) },
                    icon: { Image(image) }
                )
            }
        )
    }

    /// Creates a menu that generates its label from a localized string resource and image resource.
    ///
    /// - Parameters:
    ///     - titleResource: Text resource for the link’s localized title, which describes the contents of the menu.
    ///     - image: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init(
        _ titleResource: LocalizedStringResource,
        image: ImageResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(titleResource) },
                    icon: { Image(image) }
                )
            }
        )
    }

    /// Creates a menu that generates its label from a string and image resource.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - image: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init<Title>(
        _ title: Title,
        image: ImageResource,
        @ViewBuilder content: () -> Content
    ) where Title: StringProtocol {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(title) },
                    icon: { Image(image) }
                )
            }
        )
    }
}

// MARK: init(_:systemImage:content:)

extension MenuWithFallback where Label == SwiftUI.Label<Text, Image> {
    /// Creates a menu that generates its label from a localized string key and system image.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link’s localized title, which describes the contents of the menu.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(titleKey) },
                    icon: { Image(systemName: systemImage) }
                )
            }
        )
    }

    /// Creates a menu that generates its label from a localized string resource and system image.
    ///
    /// - Parameters:
    ///     - titleResource: Text resource for the link’s localized title, which describes the contents of the menu.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init(
        _ titleResource: LocalizedStringResource,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(titleResource) },
                    icon: { Image(systemName: systemImage) }
                )
            }
        )
    }

    /// Creates a menu that generates its label from a string and system image.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - content: A group of menu items.
    public init<Title>(
        _ title: Title,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) where Title: StringProtocol {
        self.init(
            content: content,
            label: {
                Label(
                    title: { Text(title) },
                    icon: { Image(systemName: systemImage) }
                )
            }
        )
    }
}
