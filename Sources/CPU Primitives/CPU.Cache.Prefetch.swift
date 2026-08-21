public import CPU_Shims

extension CPU.Cache {

    public struct Prefetch: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.Cache.Prefetch {

    @unsafe
    @inline(always)
    public func read(_ pointer: UnsafeRawPointer) {
        unsafe swift_cpu_cache_prefetch_read_v1(pointer)
    }

    @unsafe
    @inline(always)
    public func write(_ pointer: UnsafeMutableRawPointer) {
        unsafe swift_cpu_cache_prefetch_write_v1(pointer)
    }
}
