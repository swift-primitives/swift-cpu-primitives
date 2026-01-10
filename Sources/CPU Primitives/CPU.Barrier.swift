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
    /// Memory ordering fences.
    ///
    /// Provides both compiler-only and hardware memory barriers.
    /// Hardware barriers include a compiler barrier implicitly.
    public enum Barrier {}
}

extension CPU.Barrier {
    /// Accessor for compiler-only barriers.
    public static var compiler: Compiler { Compiler() }

    /// Accessor for hardware barriers.
    public static var hardware: Hardware { Hardware() }
}
