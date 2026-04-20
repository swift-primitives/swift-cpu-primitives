// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-cpu-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-cpu-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
@testable import CPU_Primitives

@Suite("CPU.Spin")
struct CPUSpinTests {

    @Test
    func `hint completes without error`() {
        // Smoke test - hint should complete without crashing
        CPU.Spin.hint()
    }

    @Test
    func `hint can be called repeatedly`() {
        // Verify repeated hints don't cause issues
        for _ in 0..<1000 {
            CPU.Spin.hint()
        }
    }

    @Test
    func `hint from concurrent tasks`() async {
        // Verify hint is safe under concurrent execution
        let iterations = 100
        let taskCount = 4

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<taskCount {
                group.addTask {
                    for _ in 0..<iterations {
                        CPU.Spin.hint()
                    }
                }
            }
        }
    }
}
