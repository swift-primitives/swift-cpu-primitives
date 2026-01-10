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
    /// Cache hints.
    ///
    /// Provides portable cache prefetch operations.
    public enum Cache {}
}

extension CPU.Cache {
    /// Accessor for prefetch operations.
    public static var prefetch: Prefetch { Prefetch() }
}
