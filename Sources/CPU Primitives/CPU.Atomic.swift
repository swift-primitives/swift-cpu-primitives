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

extension CPU {
    /// Memory-ordered load and store on externally-owned pointers.
    ///
    /// For memory not owned by a Swift `Atomic<T>` — mmap'd ring buffers,
    /// shared-memory IPC, lock-free data structures on raw pointers.
    ///
    /// ## Atomic Load/Store vs Standalone Fences
    ///
    /// `CPU.Barrier.hardware` emits standalone fences that order ALL memory
    /// operations. `CPU.Atomic` orders only the SPECIFIC load or store —
    /// lighter on ARM64 (`ldar`/`stlr` vs `dmb`), zero-cost on both
    /// architectures for relaxed.
    ///
    /// ## Supported Widths
    ///
    /// - `UInt8` — boolean flags, byte-level signaling
    /// - `UInt32` — io_uring ring buffer indices, 32-bit counters
    /// - `UInt64` — 64-bit counters, pointer-sized metadata
    public enum Atomic {}
}
