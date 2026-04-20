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

import Testing
@testable import CPU_Primitives

@Suite("CPU.Atomic")
struct CPUAtomicTests {

    // MARK: - Namespace

    @Test
    func `Atomic namespace exists`() {
        _ = CPU.Atomic.self
    }

    @Test
    func `Load namespace exists`() {
        _ = CPU.Atomic.Load.self
    }

    @Test
    func `Store namespace exists`() {
        _ = CPU.Atomic.Store.self
    }

    // MARK: - Load Ordering

    @Suite("Load.Ordering")
    struct LoadOrderingTests {
        @Test
        func `relaxed and acquiring are distinct`() {
            let relaxed = CPU.Atomic.Load.Ordering.relaxed
            let acquiring = CPU.Atomic.Load.Ordering.acquiring
            if case .relaxed = relaxed, case .acquiring = acquiring {
                // distinct
            } else {
                Issue.record("Cases should be distinct")
            }
        }

        @Test
        func `Ordering is Sendable`() {
            let ordering: any Sendable = CPU.Atomic.Load.Ordering.relaxed
            #expect(ordering is CPU.Atomic.Load.Ordering)
        }
    }

    // MARK: - Store Ordering

    @Suite("Store.Ordering")
    struct StoreOrderingTests {
        @Test
        func `relaxed and releasing are distinct`() {
            let relaxed = CPU.Atomic.Store.Ordering.relaxed
            let releasing = CPU.Atomic.Store.Ordering.releasing
            if case .relaxed = relaxed, case .releasing = releasing {
                // distinct
            } else {
                Issue.record("Cases should be distinct")
            }
        }

        @Test
        func `Ordering is Sendable`() {
            let ordering: any Sendable = CPU.Atomic.Store.Ordering.relaxed
            #expect(ordering is CPU.Atomic.Store.Ordering)
        }
    }

    // MARK: - UInt8

    @Suite("UInt8")
    struct UInt8Tests {
        @Test
        func `load relaxed`() {
            var value: UInt8 = 42
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 42)
        }

        @Test
        func `load acquiring`() {
            var value: UInt8 = 0xFF
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xFF)
        }

        @Test
        func `store relaxed`() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test
        func `store releasing`() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 1, ordering: .releasing)
            #expect(value == 1)
        }

        @Test
        func `load does not modify original`() {
            var value: UInt8 = 99
            _ = CPU.Atomic.load(&value, ordering: .relaxed)
            _ = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(value == 99)
        }

        @Test
        func `store then load round-trips`() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 0xAB, ordering: .releasing)
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xAB)
        }
    }

    // MARK: - UInt32

    @Suite("UInt32")
    struct UInt32Tests {
        @Test
        func `load relaxed`() {
            var value: UInt32 = 0xDEAD
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 0xDEAD)
        }

        @Test
        func `load acquiring`() {
            var value: UInt32 = 0xCAFE_BABE
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xCAFE_BABE)
        }

        @Test
        func `store relaxed`() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test
        func `store releasing`() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 0xDEAD_BEEF, ordering: .releasing)
            #expect(value == 0xDEAD_BEEF)
        }

        @Test
        func `sequential stores visible`() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 1, ordering: .relaxed)
            CPU.Atomic.store(&value, 2, ordering: .relaxed)
            CPU.Atomic.store(&value, 3, ordering: .releasing)
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 3)
        }

        @Test
        func `zero and max values`() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, UInt32.max, ordering: .relaxed)
            #expect(CPU.Atomic.load(&value, ordering: .relaxed) == UInt32.max)

            CPU.Atomic.store(&value, 0, ordering: .relaxed)
            #expect(CPU.Atomic.load(&value, ordering: .relaxed) == 0)
        }
    }

    // MARK: - UInt64

    @Suite("UInt64")
    struct UInt64Tests {
        @Test
        func `load relaxed`() {
            var value: UInt64 = 0xDEAD_BEEF_CAFE_BABE
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 0xDEAD_BEEF_CAFE_BABE)
        }

        @Test
        func `load acquiring`() {
            var value: UInt64 = 0x0123_4567_89AB_CDEF
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0x0123_4567_89AB_CDEF)
        }

        @Test
        func `store relaxed`() {
            var value: UInt64 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test
        func `store releasing`() {
            var value: UInt64 = 0
            CPU.Atomic.store(&value, UInt64.max, ordering: .releasing)
            #expect(value == UInt64.max)
        }

        @Test
        func `orderings produce same result single-threaded`() {
            var v1: UInt64 = 0
            var v2: UInt64 = 0
            CPU.Atomic.store(&v1, 42, ordering: .relaxed)
            CPU.Atomic.store(&v2, 42, ordering: .releasing)
            #expect(CPU.Atomic.load(&v1, ordering: .relaxed) == CPU.Atomic.load(&v2, ordering: .acquiring))
        }
    }
}
