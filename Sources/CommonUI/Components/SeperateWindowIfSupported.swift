// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

/// Creates a Scene for launching in a seperate window.
///
/// While the scene can always be created, the logic to launch it depends on the platform.
public struct SeperateWindowIfSupported: Scene {
    /// A Boolean value that indicates whether the app may display multiple scenes simultaneously.
    public static var supportsMultipleScenes: Bool {
        OpenWindowIfSupported.supportsMultipleScenes
    }

    private let windowType: WindowType

    /// Creates an instance of ``SeperateWindowIfSupported``.
    /// - Parameter windowType: The configuration of the window to launch.
    public init(windowType: WindowType) {
        self.windowType = windowType
    }

    /// The content and behavior of the scene.
    public var body: some Scene {
        WindowGroup(windowType) {
            NavigationStack {
                windowType.content()
            }
        }
    }
}

extension WindowGroup {
    fileprivate init(
        _ windowType: SeperateWindowIfSupported.WindowType,
        @ViewBuilder makeContent: @escaping () -> Content
    ) {
        if let title = windowType.title {
            self.init(title, id: windowType.id, makeContent: makeContent)
        } else {
            self.init(id: windowType.id, makeContent: makeContent)
        }
    }
}

extension SeperateWindowIfSupported {
    /// The configuration of a seperate window.
    ///
    /// Contains the content, title and id used to launch it.
    /// If the platform does not support launching seperate windows then this will be used to launch a sheet instead.
    public struct WindowType {
        let content: () -> AnyView
        let id: String
        let title: Text?

        /// Creates an instance of ``WindowType``.
        /// - Parameters:
        ///   - title: Title to display on the window.
        ///   - id: Id used to launch the window. Important that this is unique compared to other windows.
        ///   - makeContent: Creates the view for the window.
        public init<Content>(
            _ title: Text,
            id: String,
            @ViewBuilder makeContent: @escaping () -> Content
        ) where Content: View {
            self.id = id
            self.content = { AnyView(erasing: makeContent()) }
            self.title = title
        }
    }
}

extension SeperateWindowIfSupported.WindowType {
    /// Creates an instance of ``WindowType``.
    /// - Parameters:
    ///   - titleKey: Title to display on the window.
    ///   - id: Id used to launch the window. Important that this is unique compared to other windows.
    ///   - makeContent: Creates the view for the window.
    public init<Content>(
        _ titleKey: LocalizedStringKey,
        id: String,
        @ViewBuilder makeContent: @escaping () -> Content
    ) where Content: View {
        self.init(Text(titleKey), id: id, makeContent: makeContent)
    }

    /// Creates an instance of ``WindowType``.
    /// - Parameters:
    ///   - titleResource: Title to display on the window.
    ///   - id: Id used to launch the window. Important that this is unique compared to other windows.
    ///   - makeContent: Creates the view for the window.
    public init<Content>(
        _ titleResource: LocalizedStringResource,
        id: String,
        @ViewBuilder makeContent: @escaping () -> Content
    ) where Content: View {
        self.init(Text(titleResource), id: id, makeContent: makeContent)
    }

    /// Creates an instance of ``WindowType``.
    /// - Parameters:
    ///   - title: Title to display on the window.
    ///   - id: Id used to launch the window. Important that this is unique compared to other windows.
    ///   - makeContent: Creates the view for the window.
    public init<Content, Title>(
        _ title: Title,
        id: String,
        @ViewBuilder makeContent: @escaping () -> Content
    ) where Content: View, Title: StringProtocol {
        self.init(Text(title), id: id, makeContent: makeContent)
    }
}

extension View {
    /// Applies a view modifier for launch a seperate window,
    /// or a sheet if seperate windows is not supported by the platform.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///   to present the sheet that you create in the modifier's
    ///   - windowType: The configuration of the window to show.
    /// - Returns: The current view wrapped in the `OpenWindowIfSupported` view modifier.
    public func openWindowIfSupported(
        isPresented: Binding<Bool>,
        windowType: SeperateWindowIfSupported.WindowType
    ) -> some View {
        modifier(OpenWindowIfSupported(isPresented: isPresented, windowType: windowType))
    }
}

private struct OpenWindowIfSupported: ViewModifier {
    #if os(iOS) || os(macOS) || os(visionOS)
        @Environment(\.openWindow) private var openWindow
    #endif

    static var supportsMultipleScenes: Bool {
        #if os(iOS)
            return UIApplication.shared.supportsMultipleScenes
        #elseif os(macOS) || os(visionOS)
            return true
        #else
            return false
        #endif
    }

    @Binding private var isPresented: Bool
    private let windowType: SeperateWindowIfSupported.WindowType

    init(
        isPresented: Binding<Bool>,
        windowType: SeperateWindowIfSupported.WindowType
    ) {
        self._isPresented = isPresented
        self.windowType = windowType
    }

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS)
            applyWindow(to: content)
        #else
            applySheet(to: content)
        #endif
    }

    private func applySheet(to content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    windowType.content()
                        .toolbar {
                            ToolbarItem {
                                Button(role: .close) {
                                    isPresented = false
                                }
                            }
                        }
                }
                .presentationDragIndicator(.visible)
            }
    }

    #if os(iOS) || os(macOS) || os(visionOS)
        @ViewBuilder
        private func applyWindow(to content: Content) -> some View {
            if Self.supportsMultipleScenes {
                content
                    .onChange(of: isPresented) { _, isPresented in
                        guard isPresented else {
                            return
                        }

                        openWindow(id: windowType.id)
                        self.isPresented = false
                    }
            } else {
                applySheet(to: content)
            }
        }
    #endif
}
