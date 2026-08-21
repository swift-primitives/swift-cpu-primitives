public import CPU_Shims

extension CPU.Barrier {

    public struct Hardware: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Barrier.Hardware {

    @inline(always)
    public func full() {
        swift_cpu_barrier_full_v1()
    }

    @inline(always)
    public func load() {
        swift_cpu_barrier_load_v1()
    }

    @inline(always)
    public func store() {
        swift_cpu_barrier_store_v1()
    }
}
