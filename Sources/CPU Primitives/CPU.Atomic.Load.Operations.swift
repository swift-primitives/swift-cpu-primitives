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
    /// Performs a load with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to load from.
    ///   - ordering: The memory ordering for the load.
    /// - Returns: The value at the memory location.
    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt8>,
        ordering: Load.Ordering
    ) -> UInt8 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u8_v1(pointer)
        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u8_v1(pointer)
        }
    }
}

// MARK: - UInt32

extension CPU.Atomic {
    /// Performs a load with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to load from.
    ///   - ordering: The memory ordering for the load.
    /// - Returns: The value at the memory location.
    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt32>,
        ordering: Load.Ordering
    ) -> UInt32 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u32_v1(pointer)
        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u32_v1(pointer)
        }
    }
}

// MARK: - UInt64

extension CPU.Atomic {
    /// Performs a load with the specified memory ordering.
    ///
    /// - Parameters:
    ///   - pointer: The memory location to load from.
    ///   - ordering: The memory ordering for the load.
    /// - Returns: The value at the memory location.
    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt64>,
        ordering: Load.Ordering
    ) -> UInt64 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u64_v1(pointer)
        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u64_v1(pointer)
        }
    }
}
