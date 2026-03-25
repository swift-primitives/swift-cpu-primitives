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

public import CCPUShim

// MARK: - UInt8

extension CPU.Atomic {
    /// Performs a store with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to store to.
    ///   - value: The value to store.
    ///   - ordering: The memory ordering for the store.
    @inline(always)
    public static func store(
        _ pointer: UnsafeMutablePointer<UInt8>,
        _ value: UInt8,
        ordering: Store.Ordering
    ) {
        switch ordering {
        case .relaxed:
            unsafe swift_cpu_atomic_store_relaxed_u8_v1(pointer, value)
        case .releasing:
            unsafe swift_cpu_atomic_store_release_u8_v1(pointer, value)
        }
    }
}

// MARK: - UInt32

extension CPU.Atomic {
    /// Performs a store with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to store to.
    ///   - value: The value to store.
    ///   - ordering: The memory ordering for the store.
    @inline(always)
    public static func store(
        _ pointer: UnsafeMutablePointer<UInt32>,
        _ value: UInt32,
        ordering: Store.Ordering
    ) {
        switch ordering {
        case .relaxed:
            unsafe swift_cpu_atomic_store_relaxed_u32_v1(pointer, value)
        case .releasing:
            unsafe swift_cpu_atomic_store_release_u32_v1(pointer, value)
        }
    }
}

// MARK: - UInt64

extension CPU.Atomic {
    /// Performs a store with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to store to.
    ///   - value: The value to store.
    ///   - ordering: The memory ordering for the store.
    @inline(always)
    public static func store(
        _ pointer: UnsafeMutablePointer<UInt64>,
        _ value: UInt64,
        ordering: Store.Ordering
    ) {
        switch ordering {
        case .relaxed:
            unsafe swift_cpu_atomic_store_relaxed_u64_v1(pointer, value)
        case .releasing:
            unsafe swift_cpu_atomic_store_release_u64_v1(pointer, value)
        }
    }
}
