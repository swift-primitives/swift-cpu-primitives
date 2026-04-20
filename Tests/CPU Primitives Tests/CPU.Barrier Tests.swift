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

@Suite("CPU.Barrier")
struct CPUBarrierTests {

    @Suite("Compiler")
    struct CompilerTests {
        @Test
        func `compiler barrier completes without error`() {
            CPU.Barrier.compiler()
        }

        @Test
        func `compiler barrier can be called repeatedly`() {
            for _ in 0..<1000 {
                CPU.Barrier.compiler()
            }
        }
    }

    @Suite("Hardware")
    struct HardwareTests {
        @Test
        func `full barrier completes without error`() {
            CPU.Barrier.hardware.full()
        }

        @Test
        func `load barrier completes without error`() {
            CPU.Barrier.hardware.load()
        }

        @Test
        func `store barrier completes without error`() {
            CPU.Barrier.hardware.store()
        }

        @Test
        func `barriers can be called in sequence`() {
            for _ in 0..<100 {
                CPU.Barrier.hardware.load()
                CPU.Barrier.hardware.store()
                CPU.Barrier.hardware.full()
            }
        }
    }

    @Test
    func `compiler barrier alone does not synchronize threads`() {
        // This is a documentation test - we cannot easily prove the negative,
        // but we can demonstrate that the barrier returns without blocking
        var value = 0
        CPU.Barrier.compiler()
        value = 1
        CPU.Barrier.compiler()
        #expect(value == 1)
    }
}
