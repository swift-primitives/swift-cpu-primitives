extension CPU.Cache {

    public struct Padded<T: ~Copyable>: ~Copyable {

        @usableFromInline
        internal let _storage: UnsafeMutablePointer<T>

        @usableFromInline
        internal let _byteCount: Int

        @inlinable
        public init(_ value: consuming T) {
            let byteCount = Swift.max(MemoryLayout<T>.stride, 128)
            let raw = UnsafeMutableRawPointer.allocate(
                byteCount: byteCount,
                alignment: 128
            )
            let typed = unsafe raw.bindMemory(to: T.self, capacity: 1)
            unsafe typed.initialize(to: value)
            unsafe self._storage = typed
            self._byteCount = byteCount
        }

        @inlinable
        deinit {
            unsafe _storage.deinitialize(count: 1)
            unsafe UnsafeMutableRawPointer(_storage).deallocate()
        }
    }
}

extension CPU.Cache.Padded where T: ~Copyable {

    @inlinable
    public var value: T {
        _read { yield unsafe _storage.pointee }
        _modify {
            yield unsafe &_storage.pointee
        }
    }
}

extension CPU.Cache.Padded: @unchecked Sendable where T: ~Copyable & Sendable {}
