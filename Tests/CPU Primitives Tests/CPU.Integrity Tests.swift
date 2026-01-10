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

@Suite("CPU.Integrity.Cyclic.Castagnoli")
struct CPUIntegrityCyclicCastagnoliTests {

    @Test("compute returns consistent results")
    func computeConsistent() {
        let data: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05]

        let crc1 = data.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        let crc2 = data.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc1 == crc2)
    }

    @Test("compute with empty data returns seed")
    func computeEmptyData() {
        let data: [UInt8] = []

        let crc = data.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer, seed: 0)
        }

        #expect(crc == 0)
    }

    @Test("compute with seed chains correctly")
    func computeWithSeedChains() {
        let data1: [UInt8] = [0x01, 0x02, 0x03]
        let data2: [UInt8] = [0x04, 0x05, 0x06]
        let combined: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06]

        // Compute CRC of combined data
        let crcCombined = combined.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        // Compute CRC in two parts using seed
        let crcPart1 = data1.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }
        let crcChained = data2.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer, seed: crcPart1)
        }

        #expect(crcCombined == crcChained)
    }

    @Test("compute known test vector")
    func computeKnownTestVector() {
        // "123456789" has a well-known CRC-32C value: 0xE3069283
        let data = Array("123456789".utf8)

        let crc = data.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc == 0xE3069283)
    }

    @Test("compute different data produces different CRC")
    func computeDifferentDataDifferentCRC() {
        let data1: [UInt8] = [0x01, 0x02, 0x03]
        let data2: [UInt8] = [0x01, 0x02, 0x04]

        let crc1 = data1.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        let crc2 = data2.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc1 != crc2)
    }

    @Test("compute large data")
    func computeLargeData() {
        // Test with 1MB of data
        let data = [UInt8](repeating: 0xAB, count: 1024 * 1024)

        let crc = data.withUnsafeBytes { buffer in
            CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        // Just verify it completes and returns a value
        #expect(crc != 0) // Very unlikely to be 0 for non-trivial data
    }
}
