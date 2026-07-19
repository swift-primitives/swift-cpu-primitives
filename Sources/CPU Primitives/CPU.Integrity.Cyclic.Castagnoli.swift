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

extension CPU.Integrity.Cyclic {
    /// Castagnoli polynomial (0x1EDC6F41) operations.
    ///
    /// Also known as CRC-32C. Used by iSCSI, NVMe, and other storage/networking.
    /// **NOT** the IEEE polynomial used by Ethernet/ZIP.
    ///
    /// Portable across architectures with hardware acceleration:
    /// - x86: CRC32C instruction (SSE4.2)
    /// - ARM: CRC32C instruction (ARMv8 CRC extension)
    /// - Fallback: Software implementation using lookup table
    public enum Castagnoli {}
}

extension CPU.Integrity.Cyclic.Castagnoli {
    /// Compute checksum via hardware instruction.
    ///
    /// Uses hardware CRC32C instruction when available, with software
    /// fallback on unsupported architectures.
    ///
    /// - Parameters:
    ///   - data: The data to compute the checksum for.
    ///   - seed: Initial CRC value (default 0). Use for chained computation.
    /// - Returns: The CRC-32C checksum.
    @unsafe
    @inline(always)
    public static func compute(
        _ data: UnsafeRawBufferPointer,
        seed: CPU.Integrity.Cyclic.Checksum = 0
    ) -> CPU.Integrity.Cyclic.Checksum {
        guard let baseAddress = data.baseAddress else { return seed }
        return .init(
            unsafe swift_cpu_integrity_cyclic_castagnoli_v1(
                baseAddress,
                UInt64(data.count),
                seed.rawValue
            )
        )
    }

    /// Compute checksum using only the portable, table-based software
    /// implementation — never the hardware CRC32C instruction.
    ///
    /// `compute(_:seed:)` compiles to whichever path
    /// (`swift_cpu_integrity_cyclic_castagnoli_v1`) the host's hardware
    /// feature detection selects at build time, which means the software
    /// fallback branch is untestable on any host that has hardware CRC32C
    /// (e.g. Apple Silicon, most modern x86_64). This entry point always
    /// calls the unconditionally-compiled
    /// `swift_cpu_integrity_cyclic_castagnoli_software_v1` symbol so the
    /// software path — and its parity with the hardware path — can be
    /// verified regardless of host capability. Not part of the public API:
    /// exists for regression coverage only.
    @unsafe
    @inline(always)
    static func computeUsingSoftwareFallback(
        _ data: UnsafeRawBufferPointer,
        seed: CPU.Integrity.Cyclic.Checksum = 0
    ) -> CPU.Integrity.Cyclic.Checksum {
        guard let baseAddress = data.baseAddress else { return seed }
        return .init(
            unsafe swift_cpu_integrity_cyclic_castagnoli_software_v1(
                baseAddress,
                UInt64(data.count),
                seed.rawValue
            )
        )
    }
}
