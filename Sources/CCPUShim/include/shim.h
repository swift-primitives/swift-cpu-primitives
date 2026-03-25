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

#ifndef SWIFT_CPU_SHIM_H
#define SWIFT_CPU_SHIM_H

#ifdef __cplusplus
extern "C" {
#endif

// Symbol Versioning Rule:
// All symbols use _v1 suffix. Symbols are never removed, only superseded.
// This prevents silent ABI breakage if semantics need revision.

// Multi-instruction operations (non-inline).
// Single-instruction operations (barriers, spin, prefetch) are in barrier.h.

// Timestamp counter (RDTSC on x86, CNTVCT_EL0 on ARM)
unsigned long long swift_cpu_timestamp_read_v1(void);

// CRC-32C (Castagnoli polynomial) - hardware accelerated
unsigned int swift_cpu_integrity_cyclic_castagnoli_v1(const void* data, unsigned long long len, unsigned int seed);

#ifdef __cplusplus
}
#endif

#endif // SWIFT_CPU_SHIM_H
