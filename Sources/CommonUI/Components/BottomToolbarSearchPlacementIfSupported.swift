// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

/// Sets position of search bar location to bottom toolbar if the platform supports it.
///
/// This requires also using `.searchable` view modifier to enable the search bar logic.
/// Currently having the search bar on bottom bar only supported on iOS, and not even in iPadOS.
public struct BottomToolbarSearchPlacementIfSupported: ToolbarContent {
    private let spaces: [BottomToolbarSearchPlacementIfSupported.Space]

    /// Creates a toolbar search placement if supported.
    ///
    /// - Parameter spaces: Add fixed spacers to the input positions based on the spacebar if platform supports that. Defaults to none.
    ///
    /// Returns nil if the platform does not support placing custom toolbar position.
    public init?(spaces: [BottomToolbarSearchPlacementIfSupported.Space] = []) {
        #if os(iOS)
            self.init(forIOS: spaces)
        #else
            return nil
        #endif
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    private init(forIOS spaces: [BottomToolbarSearchPlacementIfSupported.Space]) {
        self.spaces = spaces
    }

    /// The composition of content that comprise the toolbar content.
    public var body: some ToolbarContent {
        #if os(iOS)
            content
        #else
            ToolbarItem {}
        #endif
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    @ToolbarContentBuilder
    private var content: some ToolbarContent {
        if spaces.contains(.leading) {
            ToolbarSpacer(.fixed, placement: .bottomBar)
        }

        DefaultToolbarItem(kind: .search, placement: .bottomBar)

        if spaces.contains(.trailing) {
            ToolbarSpacer(.fixed, placement: .bottomBar)
        }
    }
}

extension BottomToolbarSearchPlacementIfSupported {
    /// Space to place compared to the search bar position.
    public struct Space: Equatable {
        /// Place space leading the search bar.
        public static var leading: BottomToolbarSearchPlacementIfSupported.Space {
            BottomToolbarSearchPlacementIfSupported.Space(position: .leading)
        }

        /// Place space trailing the search bar.
        public static var trailing: BottomToolbarSearchPlacementIfSupported.Space {
            BottomToolbarSearchPlacementIfSupported.Space(position: .trailing)
        }

        let position: Position

        enum Position: CaseIterable, Equatable {
            case leading
            case trailing
        }
    }
}

extension Collection where Element == BottomToolbarSearchPlacementIfSupported.Space {
    /// Place spaces in all supported positions.
    public static var all: [Element] {
        Element.Position.allCases.map(Element.init(position:))
    }

    /// Place space leading the search bar.
    public static var leading: [Element] { [.leading] }

    /// Place space trailing the search bar.
    public static var trailing: [Element] { [.trailing] }
}

// MARK: - View

extension View {
    /// Sets position of search bar location to bottom toolbar if the platform supports it.
    ///
    /// - Parameter spaces: Add fixed spacers to the input positions based on the spacebar if platform supports that. Defaults to none.
    ///
    /// - Returns: the view configured with the toolbar item if supported.
    ///
    /// This is a convenient wrapper of ``BottomToolbarSearchPlacementIfSupported`` if all you need is the one
    /// toolbar item added.
    public func toolbarBottomToolbarSearchPlacementIfSupported(
        spaces: [BottomToolbarSearchPlacementIfSupported.Space] = []
    ) -> some View {
        toolbar {
            if let searchPlacement = BottomToolbarSearchPlacementIfSupported(spaces: spaces) {
                searchPlacement
            }
        }
    }
}

// MARK: - Preview

#Preview("with spaces") {
    PreviewContent(withSpaces: true)
}

#Preview("without spaces") {
    PreviewContent(withSpaces: false)
}

private struct PreviewContent: View {
    private let withSpaces: Bool
    @State private var text: String = ""

    init(withSpaces: Bool) {
        self.withSpaces = withSpaces
    }

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, world!")
            }
            .searchable(text: $text, prompt: "Search...")
            .toolbar {
                #if !os(macOS)
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                #endif

                BottomToolbarSearchPlacementIfSupported(spaces: withSpaces ? .all : [])

                #if !os(macOS)
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                #endif
            }
        }
    }
}
