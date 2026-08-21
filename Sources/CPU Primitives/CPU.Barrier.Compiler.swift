public import CPU_Shims

extension CPU.Barrier {

    public struct Compiler: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Barrier.Compiler {

    @inline(always)
    public func callAsFunction() {
        swift_cpu_barrier_compiler_v1()
    }
}
