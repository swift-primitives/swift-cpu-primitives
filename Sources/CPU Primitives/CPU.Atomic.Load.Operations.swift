public import CPU_Shims

extension CPU.Atomic {

    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt8>,
        ordering: Load.Ordering
    ) -> UInt8 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u8_v1(pointer)

        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u8_v1(pointer)
        }
    }
}

extension CPU.Atomic {

    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt32>,
        ordering: Load.Ordering
    ) -> UInt32 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u32_v1(pointer)

        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u32_v1(pointer)
        }
    }
}

extension CPU.Atomic {

    @inline(always)
    public static func load(
        _ pointer: UnsafeMutablePointer<UInt64>,
        ordering: Load.Ordering
    ) -> UInt64 {
        switch ordering {
        case .relaxed:
            return unsafe swift_cpu_atomic_load_relaxed_u64_v1(pointer)

        case .acquiring:
            return unsafe swift_cpu_atomic_load_acquire_u64_v1(pointer)
        }
    }
}
