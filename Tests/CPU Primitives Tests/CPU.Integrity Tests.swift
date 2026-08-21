import Testing

@testable import CPU_Primitives

@Suite
struct `CPU.Integrity.Cyclic.Castagnoli Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `compute returns consistent results`() {
        let data: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05]

        let crc1 = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        let crc2 = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc1 == crc2)
    }

    @Test
    func `compute with empty data returns seed`() {
        let data: [UInt8] = []

        let crc = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer, seed: 0)
        }

        #expect(crc == 0)
    }

    @Test
    func `compute with seed chains correctly`() {
        let data1: [UInt8] = [0x01, 0x02, 0x03]
        let data2: [UInt8] = [0x04, 0x05, 0x06]
        let combined: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06]

        let crcCombined = unsafe combined.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        let crcPart1 = unsafe data1.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }
        let crcChained = unsafe data2.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer, seed: crcPart1)
        }

        #expect(crcCombined == crcChained)
    }

    @Test
    func `compute known test vector`() {

        let data = Array("123456789".utf8)

        let crc = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc == 0xE306_9283)
    }

    @Test
    func `compute different data produces different CRC`() {
        let data1: [UInt8] = [0x01, 0x02, 0x03]
        let data2: [UInt8] = [0x01, 0x02, 0x04]

        let crc1 = unsafe data1.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        let crc2 = unsafe data2.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc1 != crc2)
    }

    @Test
    func `compute large data`() {

        let data = [UInt8](repeating: 0xAB, count: 1024 * 1024)

        let crc = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
        }

        #expect(crc != 0)
    }
}
