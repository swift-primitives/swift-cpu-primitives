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

/// CPU-level primitives.
///
/// This namespace provides policy-free wrappers for CPU-specific hints
/// and instructions with portable semantics across architectures.
///
/// ## Semantic Contract: Weakest-Semantics Rule
///
/// Portable operations guarantee no stronger semantics than the weakest
/// supported architecture. Callers must consult properties or capabilities
/// before relying on stronger behavior.
///
/// ## Architecture-Specific Extensions
///
/// For operations unique to a specific architecture:
/// - `CPU.X86` (swift-x86-primitives) - x86-only operations
/// - `CPU.ARM` (swift-arm-primitives) - ARM-only operations
public enum CPU {}
