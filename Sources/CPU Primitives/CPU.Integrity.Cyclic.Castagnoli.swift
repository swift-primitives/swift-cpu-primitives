public import CPU_Shims

extension CPU.Integrity.Cyclic {

    public enum Castagnoli {}
}

extension CPU.Integrity.Cyclic.Castagnoli {

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

    @unsafe
    @inline(always)
    static func software(
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
