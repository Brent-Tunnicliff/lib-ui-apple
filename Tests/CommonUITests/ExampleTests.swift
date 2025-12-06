// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import CommonUI

@Test func example() async throws {
    await #expect(Example.shared.getMessage() == "Hello, World!")
}
