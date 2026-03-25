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

extension CPU.Atomic.Store {
    /// Ordering semantics for store operations.
    public enum Ordering: Sendable {
        /// No ordering guarantees.
        case relaxed

        /// Release semantics: prior reads/writes cannot be reordered after this store.
        case releasing
    }
}
