// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-cpu-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-cpu-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Moved here from swift-iso-9945's `ISO 9945 Kernel System` (2026-07-02):
// the implementation is pure CPU.Atomic load/store — no POSIX content — so
// its home is the platform-neutral atomics module. The prior placement made
// the type invisible on Windows (which does not consume the POSIX chain).

public import Synchronization

extension CPU.Atomic {
    /// A one-way atomic boolean flag for cross-thread signaling.
    ///
    /// Flag provides a minimal, policy-free primitive for signaling between
    /// threads. Once set, a flag cannot be cleared - this is intentional
    /// to avoid race conditions and ensure deterministic behavior.
    ///
    /// ## Memory Ordering
    /// - `isSet` uses acquiring semantics (sees all writes before `set()`)
    /// - `set()` uses releasing semantics (all prior writes become visible)
    ///
    /// ## Usage
    /// ```swift
    /// let shutdown = CPU.Atomic.Flag()
    ///
    /// // Thread A: signal shutdown
    /// shutdown.set()
    ///
    /// // Thread B: check shutdown
    /// while !shutdown.isSet {
    ///     // do work
    /// }
    /// ```
    ///
    /// ## Thread Safety
    /// Flag is safe to share across threads without additional synchronization.
    /// Backed by `Synchronization.Atomic<Bool>` rather than a raw byte reached
    /// through `withUnsafeMutablePointer(to:)` on class storage — the prior
    /// implementation took the address of a class-instance stored property via
    /// an `inout` access and handed it to `CPU.Atomic.load`/`.store`, whose own
    /// documented contract (`CPU.Atomic.swift`) is "memory not owned by a Swift
    /// `Atomic<T>`". `inout`-to-pointer on a class property is only guaranteed
    /// valid for the duration of that single call; nothing prevents the
    /// compiler from materializing a temporary copy-in/copy-out instead of the
    /// field's real address, and Swift's exclusivity model does not account for
    /// a concurrent thread observing that address outside the formal access
    /// scope. `Atomic<Bool>` is the correct, upstream-provided tool for
    /// same-object cross-thread atomic state and carries no such hazard.
    /// `@unchecked Sendable` because the sole stored property is itself an
    /// atomic, race-free cell.
    public final class Flag: @unchecked Sendable {
        @usableFromInline
        let _atomic: Atomic<Bool>

        /// Creates a new flag with the given initial value.
        ///
        /// - Parameter initialValue: The initial state of the flag. Defaults to `false`.
        public init(_ initialValue: Bool = false) {
            self._atomic = .init(initialValue)
        }
    }
}

extension CPU.Atomic.Flag {
    /// Whether the flag has been set.
    ///
    /// Uses acquiring memory ordering to ensure visibility of all
    /// writes that happened before `set()` was called.
    public var isSet: Bool {
        _atomic.load(ordering: .acquiring)
    }

    /// Sets the flag to `true`.
    ///
    /// Uses releasing memory ordering to ensure all prior writes
    /// are visible to threads that observe `isSet == true`.
    ///
    /// This operation is idempotent - calling it multiple times
    /// has the same effect as calling it once.
    public func set() {
        _atomic.store(true, ordering: .releasing)
    }
}
