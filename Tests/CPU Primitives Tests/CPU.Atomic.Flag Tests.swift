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

@testable import CPU_Primitives

// Regression coverage for fable-448 F-003: CPU.Atomic.Flag performed pointer
// atomics through `withUnsafeMutablePointer(to: &_value)` on a class stored
// property. `withUnsafeMutablePointer(to:)` begins a formal EXCLUSIVE access
// to the referenced storage for the duration of its closure; concurrent,
// overlapping calls to `set()`/`isSet` on the *same* Flag instance from
// different threads race to open that exclusive access on the same address
// and can be caught by Swift's dynamic exclusivity enforcement, aborting the
// process ("Fatal error: Simultaneous accesses to 0x..., but modification
// requires exclusive access") — a crash, not merely a stale read. The
// underlying byte-level load/store were already real hardware atomics
// (`atomic_load_explicit`/`atomic_store_explicit`), so this was never a
// classic data race a sanitizer's shadow-memory model would flag; it is
// specifically a Swift-level formal-access violation.
//
// The fix backs the flag with `Synchronization.Atomic<Bool>` stored as a
// `let`: `load`/`store` on `Atomic` only ever require a shared (borrowing)
// access to that immutable property, so overlapping concurrent calls from
// any number of threads can never conflict.
extension CPU.Atomic.Flag {
    @Suite struct Tests {
        @Suite struct Unit {}
    }
}

extension CPU.Atomic.Flag.Tests.Unit {
    @Test
    func `set defaults isSet to false until called`() {
        let flag = CPU.Atomic.Flag()
        #expect(flag.isSet == false)
        flag.set()
        #expect(flag.isSet == true)
    }

    @Test
    func `initial value true starts isSet as set`() {
        let flag = CPU.Atomic.Flag(true)
        #expect(flag.isSet == true)
    }

    @Test
    func `concurrent set and isSet on a shared instance never trap under exclusivity enforcement`() async {
        let flag = CPU.Atomic.Flag()
        let workerCount = 32
        let iterationsPerWorker = 50_000

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<workerCount {
                group.addTask {
                    for _ in 0..<iterationsPerWorker {
                        flag.set()
                        _ = flag.isSet
                    }
                }
            }
        }

        #expect(flag.isSet)
    }
}
