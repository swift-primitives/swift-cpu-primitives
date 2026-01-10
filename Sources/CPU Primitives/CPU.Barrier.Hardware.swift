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

extension CPU.Barrier {
    /// Hardware barrier accessor.
    ///
    /// Hardware barriers include a compiler barrier implicitly.
    /// Portable across architectures with equivalent semantics.
    public struct Hardware: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Barrier.Hardware {
    /// Full memory barrier.
    ///
    /// Orders all loads and stores before the barrier against all
    /// loads and stores after. Includes compiler barrier.
    ///
    /// - x86: MFENCE
    /// - ARM: DMB ISH
    @inline(__always)
    public func full() {
        swift_cpu_barrier_full_v1()
    }

    /// Load barrier.
    ///
    /// Orders loads before the barrier against loads after.
    /// Includes compiler barrier.
    ///
    /// - x86: LFENCE
    /// - ARM: DMB ISHLD
    @inline(__always)
    public func load() {
        swift_cpu_barrier_load_v1()
    }

    /// Store barrier.
    ///
    /// Orders stores before the barrier against stores after.
    /// Includes compiler barrier.
    ///
    /// - x86: SFENCE
    /// - ARM: DMB ISHST
    @inline(__always)
    public func store() {
        swift_cpu_barrier_store_v1()
    }
}
