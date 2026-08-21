public import CPU_Shims

extension CPU {

    public enum Spin {}
}

extension CPU.Spin {

    @inline(always)
    public static func hint() {
        swift_cpu_spin_hint_v1()
    }
}
