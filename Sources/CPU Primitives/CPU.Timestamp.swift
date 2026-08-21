extension CPU {

    public struct Timestamp: Sendable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral {

        public var rawValue: UInt64

        @inlinable
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(_ rawValue: UInt64) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(integerLiteral value: UInt64) {
            self.rawValue = value
        }
    }
}

extension CPU.Timestamp {

    public static var read: Read { Read() }
}

extension CPU.Timestamp: Binary.Serializable {}
