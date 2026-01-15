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

extension CPU.Cache {
    /// Prefetch operation accessor.
    ///
    /// Portable across architectures. These are hints only;
    /// the CPU may ignore them entirely.
    ///
    /// ## Weakest-Semantics Guarantee
    ///
    /// This operation makes no guarantees about:
    /// - Which cache level will receive the data
    /// - Locality/temporal hints
    /// - Whether prefetch actually occurs
    public struct Prefetch: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Cache.Prefetch {
    /// Prefetch for reading.
    ///
    /// Hints to the CPU that the memory at `pointer` will be read soon.
    ///
    /// - x86: PREFETCHT0
    /// - ARM: PRFM PLDL1KEEP
    ///
    /// - Parameter pointer: Memory location to prefetch.
    @unsafe
    @inline(__always)
    public func read(_ pointer: UnsafeRawPointer) {
        unsafe swift_cpu_cache_prefetch_read_v1(pointer)
    }

    /// Prefetch for writing.
    ///
    /// Hints to the CPU that the memory at `pointer` will be written soon.
    ///
    /// - x86: PREFETCHW
    /// - ARM: PRFM PSTL1KEEP
    ///
    /// - Parameter pointer: Memory location to prefetch.
    @unsafe
    @inline(__always)
    public func write(_ pointer: UnsafeMutableRawPointer) {
        unsafe swift_cpu_cache_prefetch_write_v1(pointer)
    }
}
