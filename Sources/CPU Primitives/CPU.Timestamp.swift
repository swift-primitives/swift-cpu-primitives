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

extension CPU {
    /// High-resolution cycle/counter value.
    ///
    /// Portable across architectures. For architecture-specific
    /// variants (serialized reads, physical counters), see
    /// `CPU.X86.Timestamp` and `CPU.ARM.Timestamp`.
    ///
    /// ## Weakest-Semantics Guarantee
    ///
    /// The portable timestamp makes no guarantees about:
    /// - Monotonicity
    /// - Cross-core comparability
    /// - Ordering with respect to other instructions
    /// - Frequency stability
    /// - Freedom from virtualization offsets
    ///
    /// Consumers requiring stronger guarantees must use architecture-specific
    /// variants or consult capability queries.
    ///
    /// ## No Comparable Conformance
    ///
    /// This type intentionally does not conform to `Comparable` because
    /// ordering is only meaningful under specific conditions (same core,
    /// proper serialization). Use architecture-specific APIs when you need
    /// ordered measurements.
    public struct Timestamp: Sendable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral {
        /// The underlying 64-bit counter value.
        public var rawValue: UInt64

        /// Creates a timestamp from a raw 64-bit counter value.
        @inlinable
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }

        /// Creates a timestamp from a 64-bit counter value.
        @inlinable
        public init(_ rawValue: UInt64) {
            self.rawValue = rawValue
        }

        /// Creates a timestamp from an integer literal.
        @inlinable
        public init(integerLiteral value: UInt64) {
            self.rawValue = value
        }
    }
}

extension CPU.Timestamp {
    /// Accessor for read operations.
    public static var read: Read { Read() }
}

// MARK: - Binary.Serializable

extension CPU.Timestamp: Binary.Serializable {}
