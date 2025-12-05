// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftUI

/// A button with an async action.
///
/// It automatically disables the button and shows/hides ProgressView while awaiting the async  action.
public struct AsyncButton<Label>: View where Label: View {
    /// Default task priority if not defined.
    public static var defaultPriority: TaskPriority { .userInitiated }

    /// Default duration delay for progress view is not defined.
    public static var defaultDelayForProgressView: Duration { .milliseconds(100) }

    private let action: () async -> Void
    private let delayForProgressView: Duration
    private let label: Label
    private let priority: TaskPriority
    private let role: ButtonRole?
    @State private var isPerformingTask = false
    @State private var isShowingLoading = false

    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    ///     - label: A view that describes the purpose of the button’s action.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.delayForProgressView = delayForProgressView
        self.label = label()
        self.priority = priority
        self.role = role
    }

    /// The content and behavior of the view.
    public var body: some View {
        Button(role: role) {
            withAnimation {
                isPerformingTask = true
            }
        } label: {
            // We want the button to stay the size of the label,
            // so using opacity and overlay instead of simple if else.
            label
                .opacity(isShowingLoading ? 0 : 1)
                .overlay {
                    if isShowingLoading {
                        ProgressView()
                    }
                }
        }
        .disabled(isPerformingTask)
        .task(id: isPerformingTask, priority: priority) {
            guard isPerformingTask else {
                if isShowingLoading {
                    withAnimation {
                        isShowingLoading = false
                    }
                }
                return
            }

            let delayShowingLoadingTask = Task {
                try await Task.sleep(for: delayForProgressView)
                withAnimation {
                    isShowingLoading = true
                }
            }

            await action()

            delayShowingLoadingTask.cancel()
            withAnimation {
                isPerformingTask = false
            }
        }
    }
}

// MARK: - Alternative init's

// MARK: init(priority:delayForProgressView:_:role:action:)

extension AsyncButton where Label == Text {
    /// Creates a button with a specified role that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleKey: LocalizedStringKey,
        role: ButtonRole?,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleKey) }
        )
    }

    /// Creates a button with a specified role that generates its label from a localized string resource.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleResource: Text resource for the button’s localized title, that describes the purpose of the button’s action.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleResource: LocalizedStringResource,
        role: ButtonRole?,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleResource) }
        )
    }

    /// Creates a button with a specified role that generates its label from a string.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init<Title>(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ title: Title,
        role: ButtonRole?,
        action: @escaping () async -> Void
    ) where Title: StringProtocol {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(title) }
        )
    }
}

// MARK: init(priority:delayForProgressView:_:image:role:action:)

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button with a specified role that generates its label from a localized string key and an image resource.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - image: The image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleKey: LocalizedStringKey,
        image: ImageResource,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleKey, image: image) }
        )
    }

    /// Creates a button with a specified role that generates its label from a localized string resource and an image resource.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleResource: Text resource for the button’s localized title, that describes the purpose of the button’s action.
    ///     - image: The image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleResource: LocalizedStringResource,
        image: ImageResource,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleResource, image: image) }
        )
    }

    /// Creates a button with a specified role that generates its label from a string and an image resource.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - image: The image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init<Title>(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ title: Title,
        image: ImageResource,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) where Title: StringProtocol {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(title, image: image) }
        )
    }
}

// MARK: init(priority:delayForProgressView:_:systemImage:role:action:)

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button with a specified role that generates its label from a localized string key and a system image.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleKey, systemImage: systemImage) }
        )
    }

    /// Creates a button with a specified role that generates its label from a localized string resource and a system image.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - titleResource: Text resource for the button’s localized title, that describes the purpose of the button’s action.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ titleResource: LocalizedStringResource,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(titleResource, systemImage: systemImage) }
        )
    }

    /// Creates a button with a specified role that generates its label from a string and a system image and an image resource.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - systemImage: The name of the image resource to lookup.
    ///     - role: An optional semantic role that describes the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user interacts with the button.
    public init<Title>(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ title: Title,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) where Title: StringProtocol {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: role,
            action: action,
            label: { Label(title, systemImage: systemImage) }
        )
    }
}

// MARK: init(priority:delayForProgressView:_)

extension AsyncButton where Label == PrimitiveButtonStyleConfiguration.Label {
    /// Creates a button based on a configuration for a style with a custom appearance and custom interaction behavior.
    ///
    /// - Parameters:
    ///     - priority: The task priority to use when creating the asynchronous task. The default priority is .userInitiated.
    ///     - delayForProgressView: The duration to delay showing progress view. The default duration is 100 milliseconds.
    ///     - configuration: A configuration for a style with a custom appearance and custom interaction behavior.
    public init(
        priority: TaskPriority = Self.defaultPriority,
        delayForProgressView: Duration = Self.defaultDelayForProgressView,
        _ configuration: PrimitiveButtonStyleConfiguration
    ) {
        self.init(
            priority: priority,
            delayForProgressView: delayForProgressView,
            role: configuration.role,
            action: configuration.trigger,
            label: { configuration.label }
        )
    }
}

// MARK: - Preview

private func previewContent<Label>(
    sleepDuration: Duration = .seconds(3),
    @ViewBuilder _ label: () -> Label
) -> some View where Label: View {
    VStack {
        AsyncButton {
            try? await Task.sleep(for: sleepDuration)
        } label: {
            label()
        }
    }
}

#Preview("Text") {
    previewContent {
        Text("Perform action")
    }
}

#Preview("Image") {
    previewContent {
        Image(systemName: "square.and.arrow.up")
    }
}

#Preview("Label") {
    previewContent {
        Label("Export", systemImage: "square.and.arrow.up")
    }
}

#Preview("Bordered style") {
    previewContent {
        Text("Perform action")
    }
    .buttonStyle(.bordered)
}

#Preview("List") {
    List {
        previewContent {
            Text("Perform action")
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview("Quick action") {
    previewContent(sleepDuration: .milliseconds(90)) {
        Text("Perform action")
    }
}
