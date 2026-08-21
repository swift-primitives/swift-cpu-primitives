public import CPU_Shims

extension CPU.Timestamp {

    public struct Read: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Timestamp.Read {

    @inline(always)
    public func callAsFunction() -> CPU.Timestamp {
        .init(swift_cpu_timestamp_read_v1())
    }
}
