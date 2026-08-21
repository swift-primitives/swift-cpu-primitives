extension CPU.Integrity.Cyclic {

    public struct Checksum: Sendable, Hashable, RawRepresentable, Comparable,
        ExpressibleByIntegerLiteral
    {

        public var rawValue: UInt32

        @inlinable
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(_ rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(integerLiteral value: UInt32) {
            self.rawValue = value
        }
    }
}

extension CPU.Integrity.Cyclic.Checksum {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {

        lhs.rawValue < rhs.rawValue
    }
}

extension CPU.Integrity.Cyclic.Checksum: Binary.Serializable {}
