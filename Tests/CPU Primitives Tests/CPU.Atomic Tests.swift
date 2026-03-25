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

    @Test("Atomic namespace exists")
    func namespaceExists() {
        _ = CPU.Atomic.self
    }

    @Test("Load namespace exists")
    func loadNamespaceExists() {
        _ = CPU.Atomic.Load.self
    }

    @Test("Store namespace exists")
    func storeNamespaceExists() {
        _ = CPU.Atomic.Store.self
    }

    // MARK: - Load Ordering

    @Suite("Load.Ordering")
    struct LoadOrderingTests {
        @Test("relaxed and acquiring are distinct")
        func casesDistinct() {
            let relaxed = CPU.Atomic.Load.Ordering.relaxed
            let acquiring = CPU.Atomic.Load.Ordering.acquiring
            if case .relaxed = relaxed, case .acquiring = acquiring {
                // distinct
            } else {
                Issue.record("Cases should be distinct")
            }
        }

        @Test("Ordering is Sendable")
        func isSendable() {
            let ordering: any Sendable = CPU.Atomic.Load.Ordering.relaxed
            #expect(ordering is CPU.Atomic.Load.Ordering)
        }
    }

    // MARK: - Store Ordering

    @Suite("Store.Ordering")
    struct StoreOrderingTests {
        @Test("relaxed and releasing are distinct")
        func casesDistinct() {
            let relaxed = CPU.Atomic.Store.Ordering.relaxed
            let releasing = CPU.Atomic.Store.Ordering.releasing
            if case .relaxed = relaxed, case .releasing = releasing {
                // distinct
            } else {
                Issue.record("Cases should be distinct")
            }
        }

        @Test("Ordering is Sendable")
        func isSendable() {
            let ordering: any Sendable = CPU.Atomic.Store.Ordering.relaxed
            #expect(ordering is CPU.Atomic.Store.Ordering)
        }
    }

    // MARK: - UInt8

    @Suite("UInt8")
    struct UInt8Tests {
        @Test("load relaxed")
        func loadRelaxed() {
            var value: UInt8 = 42
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 42)
        }

        @Test("load acquiring")
        func loadAcquiring() {
            var value: UInt8 = 0xFF
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xFF)
        }

        @Test("store relaxed")
        func storeRelaxed() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test("store releasing")
        func storeReleasing() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 1, ordering: .releasing)
            #expect(value == 1)
        }

        @Test("load does not modify original")
        func loadPreservesValue() {
            var value: UInt8 = 99
            _ = CPU.Atomic.load(&value, ordering: .relaxed)
            _ = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(value == 99)
        }

        @Test("store then load round-trips")
        func roundTrip() {
            var value: UInt8 = 0
            CPU.Atomic.store(&value, 0xAB, ordering: .releasing)
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xAB)
        }
    }

    // MARK: - UInt32

    @Suite("UInt32")
    struct UInt32Tests {
        @Test("load relaxed")
        func loadRelaxed() {
            var value: UInt32 = 0xDEAD
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 0xDEAD)
        }

        @Test("load acquiring")
        func loadAcquiring() {
            var value: UInt32 = 0xCAFE_BABE
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0xCAFE_BABE)
        }

        @Test("store relaxed")
        func storeRelaxed() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test("store releasing")
        func storeReleasing() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 0xDEAD_BEEF, ordering: .releasing)
            #expect(value == 0xDEAD_BEEF)
        }

        @Test("sequential stores visible")
        func sequentialStores() {
            var value: UInt32 = 0
            CPU.Atomic.store(&value, 1, ordering: .relaxed)
            CPU.Atomic.store(&value, 2, ordering: .relaxed)
            CPU.Atomic.store(&value, 3, ordering: .releasing)
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 3)
        }

        @Test("zero and max values")
        func extremes() {
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
        @Test("load relaxed")
        func loadRelaxed() {
            var value: UInt64 = 0xDEAD_BEEF_CAFE_BABE
            let loaded = CPU.Atomic.load(&value, ordering: .relaxed)
            #expect(loaded == 0xDEAD_BEEF_CAFE_BABE)
        }

        @Test("load acquiring")
        func loadAcquiring() {
            var value: UInt64 = 0x0123_4567_89AB_CDEF
            let loaded = CPU.Atomic.load(&value, ordering: .acquiring)
            #expect(loaded == 0x0123_4567_89AB_CDEF)
        }

        @Test("store relaxed")
        func storeRelaxed() {
            var value: UInt64 = 0
            CPU.Atomic.store(&value, 42, ordering: .relaxed)
            #expect(value == 42)
        }

        @Test("store releasing")
        func storeReleasing() {
            var value: UInt64 = 0
            CPU.Atomic.store(&value, UInt64.max, ordering: .releasing)
            #expect(value == UInt64.max)
        }

        @Test("orderings produce same result single-threaded")
        func orderingsEquivalent() {
            var v1: UInt64 = 0
            var v2: UInt64 = 0
            CPU.Atomic.store(&v1, 42, ordering: .relaxed)
            CPU.Atomic.store(&v2, 42, ordering: .releasing)
            #expect(CPU.Atomic.load(&v1, ordering: .relaxed) == CPU.Atomic.load(&v2, ordering: .acquiring))
        }
    }
}
