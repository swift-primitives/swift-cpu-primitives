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

@Suite
struct `CPU.Timestamp Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `read returns a value`() {
        let value = CPU.Timestamp.read()
        // We can't assert much about the value, but it should be non-zero
        // on any real hardware after the system has been running
        // swift-linter:disable:next raw value access
        // REASON: test-only sanity assertion on an opaque hardware counter; no typed comparison API is exposed for this.
        #expect(value.rawValue > 0)
    }

    @Test
    func `read can be called repeatedly`() {
        (0..<1000).forEach { _ in
            let _ = CPU.Timestamp.read()
        }
    }

    @Test
    func `successive reads generally increase`() {
        // Note: This is not guaranteed by the portable API,
        // but should hold on most hardware under normal conditions
        let first = CPU.Timestamp.read()

        // Do some work to ensure time passes
        var sum: UInt64 = 0
        (UInt64(0)..<10000).forEach { i in
            sum &+= i
        }
        _ = sum  // Prevent optimization

        let second = CPU.Timestamp.read()

        // We expect second >= first, but due to weakest-semantics
        // we only warn if it decreases significantly
        // swift-linter:disable:next raw value access
        // REASON: test-only ordering check on an opaque hardware counter; no typed comparison API is exposed for this.
        if second.rawValue < first.rawValue {
            // This could happen under virtualization or migration
            // Just note it, don't fail
            Issue.record("Timestamp decreased: \(first) -> \(second)")
        }
    }

    @Test
    func `read from concurrent tasks`() async {
        let taskCount = 4
        let iterations = 100

        await withTaskGroup(of: CPU.Timestamp.self) { group in
            (0..<taskCount).forEach { _ in
                group.addTask {
                    var lastValue: CPU.Timestamp = 0
                    (0..<iterations).forEach { _ in
                        lastValue = CPU.Timestamp.read()
                    }
                    return lastValue
                }
            }

            // Collect all results - they should all be non-zero
            for await value in group {
                // swift-linter:disable:next raw value access
                // REASON: test-only sanity assertion on an opaque hardware counter; no typed comparison API is exposed for this.
                #expect(value.rawValue > 0)
            }
        }
    }
}
