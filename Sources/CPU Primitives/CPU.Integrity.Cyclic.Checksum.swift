// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-cpu-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-cpu-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension CPU.Integrity.Cyclic {
    /// A cyclic redundancy checksum value.
    ///
    /// Wraps a raw `UInt32` CRC value. Use this type to ensure type-safe
    /// handling of checksum values and prevent accidental mixing with
    /// other numeric values.
    public struct Checksum: Sendable, Hashable, RawRepresentable, Comparable, ExpressibleByIntegerLiteral {
        /// The underlying 32-bit CRC value.
        public var rawValue: UInt32

        /// Creates a checksum from its raw 32-bit CRC value.
        @inlinable
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Creates a checksum from a 32-bit CRC value.
        @inlinable
        public init(_ rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Creates a checksum from an integer literal.
        @inlinable
        public init(integerLiteral value: UInt32) {
            self.rawValue = value
        }
    }
}

extension CPU.Integrity.Cyclic.Checksum {
    /// Returns whether one checksum's raw value orders before another's.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Binary.Serializable

extension CPU.Integrity.Cyclic.Checksum: Binary.Serializable {}
