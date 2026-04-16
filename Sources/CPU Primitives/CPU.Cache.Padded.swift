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

extension CPU.Cache {
    /// Cache-line-aligned heap storage for `T`.
    ///
    /// Heap-allocates storage for one `T` in a 128-byte-aligned region
    /// of at least 128 bytes. Prevents false sharing when `T` is a
    /// write-contended atomic co-located with read-mostly neighbours
    /// (the Sharded-cursor pattern).
    ///
    /// ## Cache-line size
    ///
    /// Apple Silicon: 128 bytes (`sysctl hw.cachelinesize`).
    /// x86-64: 64 bytes (Intel Optimization Manual §2.6.2).
    /// 128 is the safe portable minimum — over-padding on x86 cannot
    /// cause false sharing; under-padding on Apple Silicon can.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let paddedCursor = CPU.Cache.Padded(Atomic<Int>(0))
    /// paddedCursor.value.store(42, ordering: .releasing)
    /// ```
    ///
    /// ## Wrapping `~Copyable` types
    ///
    /// `T: ~Copyable` is supported; `Atomic<V>`, `Mutex<V>`, and other
    /// noncopyable concurrency primitives are the primary use case.
    /// The value is consumed into the heap slot at construction and
    /// accessed via the `value` coroutine accessor thereafter.
    ///
    /// ## Why not `@_alignment(128)`
    ///
    /// The `@_alignment` attribute caps at 16 in Swift 6.3; 128-byte
    /// alignment cannot be requested on a stored struct layout. Heap
    /// allocation via `UnsafeMutableRawPointer.allocate(alignment: 128)`
    /// is the only way to guarantee the alignment today.
    // WHY: @safe — the type encapsulates the unsafe pointer behind a
    // WHY: checked API (init consumes T into the slot, deinit deinitializes
    // WHY: and deallocates, `value` is the only accessor and runs under
    // WHY: coroutine borrow/exclusive semantics). Consumers don't need to
    // WHY: annotate use with `unsafe`.
    @safe
    public struct Padded<T: ~Copyable>: ~Copyable {

        /// The 128-byte-aligned heap storage. Non-null for the lifetime
        /// of `self`; deallocated in `deinit`.
        @usableFromInline
        internal let _storage: UnsafeMutablePointer<T>

        /// Size of the allocation in bytes — always at least 128, at
        /// least `MemoryLayout<T>.stride` — recorded for `deinit` to
        /// deallocate with matching size.
        @usableFromInline
        internal let _byteCount: Int

        /// Allocates a 128-byte-aligned slot and consumes `value` into it.
        @inlinable
        public init(_ value: consuming T) {
            let byteCount = Swift.max(MemoryLayout<T>.stride, 128)
            let raw = UnsafeMutableRawPointer.allocate(
                byteCount: byteCount,
                alignment: 128
            )
            let typed = unsafe raw.bindMemory(to: T.self, capacity: 1)
            unsafe typed.initialize(to: value)
            unsafe self._storage = typed
            self._byteCount = byteCount
        }

        @inlinable
        deinit {
            unsafe _storage.deinitialize(count: 1)
            unsafe UnsafeMutableRawPointer(_storage).deallocate()
        }
    }
}

extension CPU.Cache.Padded where T: ~Copyable {
    /// Borrow or mutate the underlying value.
    ///
    /// For ~Copyable `T` (e.g. `Atomic<V>`), method calls on the
    /// yielded value operate directly on the heap slot — no copy,
    /// no intermediate binding.
    @inlinable
    public var value: T {
        _read { yield unsafe _storage.pointee }
        _modify {
            yield unsafe &_storage.pointee
        }
    }
}

// MARK: - Sendable

// The wrapper is Sendable iff the wrapped value is Sendable — the
// heap allocation is exclusive to this instance and immovable after
// init. ~Copyable storage prevents accidental aliasing.
extension CPU.Cache.Padded: @unchecked Sendable where T: ~Copyable & Sendable {}
