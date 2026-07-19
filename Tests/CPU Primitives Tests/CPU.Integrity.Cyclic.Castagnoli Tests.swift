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

// Regression coverage for fable-448 F-001: the CRC-32C software fallback
// re-inverted its working state (processing from `seed` instead of `~seed`)
// immediately before the table loop, silently diverging from every hardware
// path. `computeUsingSoftwareFallback` always calls the unconditionally
// compiled `swift_cpu_integrity_cyclic_castagnoli_software_v1` symbol, so the
// software path is exercised here regardless of the host's own hardware
// CRC32C support (this machine has hardware CRC32C, so `compute(_:seed:)`
// alone would never reach the buggy branch).
extension CPU.Integrity.Cyclic.Castagnoli {
    @Suite struct Tests {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension CPU.Integrity.Cyclic.Castagnoli.Tests.Unit {
    @Test
    func `software fallback matches known CRC-32C test vector`() {
        // "123456789" has a well-known CRC-32C value: 0xE3069283
        let data = Array("123456789".utf8)

        let crc = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.computeUsingSoftwareFallback(buffer)
        }

        #expect(crc == 0xE306_9283)
    }

    @Test
    func `software fallback agrees with the hardware path on this host`() {
        let data = Array("The quick brown fox jumps over the lazy dog".utf8)

        let hardware = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }
        let software = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.computeUsingSoftwareFallback(buffer)
        }

        #expect(hardware == software)
    }
}

extension CPU.Integrity.Cyclic.Castagnoli.Tests.`Edge Case` {
    @Test
    func `software fallback chains seed the same way as a single pass`() {
        let data1 = Array("abc".utf8)
        let data2 = Array("def".utf8)
        let combined = Array("abcdef".utf8)

        let combinedSoftware = unsafe combined.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.computeUsingSoftwareFallback(buffer)
        }

        let part1 = unsafe data1.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.computeUsingSoftwareFallback(buffer)
        }
        let chained = unsafe data2.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.computeUsingSoftwareFallback(buffer, seed: part1)
        }

        #expect(combinedSoftware == chained)
    }
}
