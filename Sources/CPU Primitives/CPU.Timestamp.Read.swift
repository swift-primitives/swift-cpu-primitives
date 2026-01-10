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

extension CPU.Timestamp {
    /// Timestamp read operation accessor.
    public struct Read: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Timestamp.Read {
    /// Read the high-resolution counter.
    ///
    /// **WARNING:** The returned value has no implied ordering, monotonicity,
    /// or cross-core comparability. Do not use for:
    /// - Cross-thread timing comparisons (values may not be comparable)
    /// - Precise elapsed time measurement (no frequency guarantee)
    /// - Security-sensitive timing (may be virtualized or offset)
    ///
    /// Consumers requiring stronger guarantees must consult architecture-specific
    /// documentation or use `CPU.X86.Timestamp` / `CPU.ARM.Timestamp` variants.
    ///
    /// - x86: RDTSC (may be reordered with surrounding instructions)
    /// - ARM: CNTVCT_EL0 (virtual counter, may have hypervisor offset)
    ///
    /// - Returns: A counter value with architecture-dependent semantics.
    @inline(__always)
    public func callAsFunction() -> CPU.Timestamp {
        .init(swift_cpu_timestamp_read_v1())
    }
}
