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
    /// Compiler-only barrier accessor.
    ///
    /// **WARNING:** This does NOT establish inter-thread happens-before.
    /// It only constrains compiler reordering within a single thread.
    /// Use atomics or `CPU.Barrier.hardware.*` for cross-thread ordering.
    public struct Compiler: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Barrier.Compiler {
    /// Compiler-only barrier. No CPU instruction emitted.
    ///
    /// Prevents the compiler from reordering memory operations across
    /// this point. Does NOT prevent CPU reordering. Does NOT provide
    /// inter-thread synchronization.
    ///
    /// ## When to Use
    ///
    /// - Volatile-like semantics within a single thread
    /// - Preventing compiler optimization across a boundary
    /// - Memory-mapped I/O ordering (single-threaded access)
    ///
    /// ## When NOT to Use
    ///
    /// - Cross-thread synchronization (use `hardware.*` or atomics)
    /// - Ensuring visibility to other cores (use `hardware.*`)
    @inline(__always)
    public func callAsFunction() {
        swift_cpu_barrier_compiler_v1()
    }
}
