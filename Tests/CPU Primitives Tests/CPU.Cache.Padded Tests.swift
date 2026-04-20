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

import Testing
import Synchronization
@testable import CPU_Primitives

@Suite("CPU.Cache.Padded")
struct CPUCachePaddedTests {

    @Test
    func `wraps a trivial value and reads it back`() {
        let padded = CPU.Cache.Padded<Int>(42)
        #expect(padded.value == 42)
    }

    @Test
    func `wraps a larger struct and reads fields back`() {
        struct Payload: Sendable {
            var a: Int
            var b: Int
            var c: Double
        }
        let padded = CPU.Cache.Padded<Payload>(Payload(a: 1, b: 2, c: 3.5))
        #expect(padded.value.a == 1)
        #expect(padded.value.b == 2)
        #expect(padded.value.c == 3.5)
    }

    @Test
    func `storage address is 128-byte aligned`() {
        let padded = CPU.Cache.Padded<UInt64>(0xDEADBEEF)
        let rawAddress = unsafe UInt(bitPattern: padded._storage)
        #expect(rawAddress % 128 == 0)
    }

    @Test
    func `byte count is at least 128 for small T`() {
        let padded = CPU.Cache.Padded<UInt8>(7)
        #expect(padded._byteCount == 128)
    }

    @Test
    func `byte count matches stride for T larger than 128 bytes`() {
        struct Jumbo: Sendable {
            var chunk: (Int, Int, Int, Int, Int, Int, Int, Int,
                        Int, Int, Int, Int, Int, Int, Int, Int,
                        Int, Int, Int, Int)  // 160 bytes on 64-bit
        }
        let zero = (0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0)
        let padded = CPU.Cache.Padded<Jumbo>(Jumbo(chunk: zero))
        #expect(padded._byteCount >= MemoryLayout<Jumbo>.stride)
        #expect(padded._byteCount >= 128)
    }

    @Test
    func `wraps Atomic<Int> and atomic operations work through accessor`() {
        let padded = CPU.Cache.Padded<Atomic<Int>>(Atomic<Int>(0))
        padded.value.store(42, ordering: .releasing)
        let loaded = padded.value.load(ordering: .acquiring)
        #expect(loaded == 42)

        let (exchanged, _) = padded.value.compareExchange(
            expected: 42,
            desired: 100,
            ordering: .acquiringAndReleasing
        )
        #expect(exchanged == true)
        #expect(padded.value.load(ordering: .acquiring) == 100)
    }

    @Test
    func `two padded atomics on different cache lines`() {
        let a = CPU.Cache.Padded<Atomic<Int>>(Atomic<Int>(1))
        let b = CPU.Cache.Padded<Atomic<Int>>(Atomic<Int>(2))
        let addressA = unsafe UInt(bitPattern: a._storage)
        let addressB = unsafe UInt(bitPattern: b._storage)
        let distance = addressA > addressB ? addressA - addressB : addressB - addressA
        #expect(distance >= 128, "two heap-allocated padded values should be ≥ 128 bytes apart")
    }
}
