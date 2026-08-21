import Testing

@testable import CPU_Primitives

extension CPU.Integrity.Cyclic.Castagnoli {
    @Suite struct Tests {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension CPU.Integrity.Cyclic.Castagnoli.Tests.Unit {
    @Test
    func `software fallback matches known CRC-32C test vector`() {

        let data = Array("123456789".utf8)

        let crc = unsafe data.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.software(buffer)
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
            unsafe CPU.Integrity.Cyclic.Castagnoli.software(buffer)
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
            unsafe CPU.Integrity.Cyclic.Castagnoli.software(buffer)
        }

        let part1 = unsafe data1.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.software(buffer)
        }
        let chained = unsafe data2.withUnsafeBytes { buffer in
            unsafe CPU.Integrity.Cyclic.Castagnoli.software(buffer, seed: part1)
        }

        #expect(combinedSoftware == chained)
    }
}
