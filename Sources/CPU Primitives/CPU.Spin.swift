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

internal import CCPUShim

extension CPU {
    /// Spin-wait hints.
    public enum Spin {}
}

extension CPU.Spin {
    /// Hints to the CPU that this is a spin-wait loop.
    ///
    /// Portable across architectures:
    /// - x86/x86_64: `PAUSE` instruction
    /// - ARM64: `YIELD` instruction
    /// - Other: No-op
    ///
    /// This is purely advisory. The CPU may ignore it entirely.
    /// Use in tight spin loops with a small bounded budget.
    ///
    /// ## Weakest-Semantics Guarantee
    ///
    /// This operation makes no guarantees about:
    /// - Scheduler effects
    /// - Power state changes
    /// - Timing behavior
    ///
    /// It is a hint only, not a contract.
    @inline(always)
    public static func hint() {
        swift_cpu_spin_hint_v1()
    }
}
