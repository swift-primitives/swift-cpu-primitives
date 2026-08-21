public import Synchronization

extension CPU.Atomic {

    public final class Flag: @unchecked Sendable {
        @usableFromInline
        let _atomic: Atomic<Bool>

        public init(_ initialValue: Bool = false) {
            self._atomic = .init(initialValue)
        }
    }
}

extension CPU.Atomic.Flag {

    public var isSet: Bool {
        _atomic.load(ordering: .acquiring)
    }

    public func set() {
        _atomic.store(true, ordering: .releasing)
    }
}
