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

// Memory-ordered atomic load/store for externally-owned memory.
//
// Uses C11 <stdatomic.h> to emit per-instruction ordering:
// - ARM64: ldar/ldarb (load-acquire), stlr/stlrb (store-release)
// - x86-64: plain mov (TSO provides acquire/release for free)
//
// This is identical to liburing's barrier.h approach for io_uring ring buffers.

#ifndef SWIFT_CPU_ATOMIC_SHIM_H
#define SWIFT_CPU_ATOMIC_SHIM_H

#include <stdatomic.h>
#include <stdint.h>

// --- 8-bit ---

static inline uint8_t
swift_cpu_atomic_load_acquire_u8_v1(const uint8_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint8_t *)p, memory_order_acquire);
}

static inline void
swift_cpu_atomic_store_release_u8_v1(uint8_t *_Nonnull p, uint8_t v) {
    atomic_store_explicit(
        (_Atomic uint8_t *)p, v, memory_order_release);
}

static inline uint8_t
swift_cpu_atomic_load_relaxed_u8_v1(const uint8_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint8_t *)p, memory_order_relaxed);
}

static inline void
swift_cpu_atomic_store_relaxed_u8_v1(uint8_t *_Nonnull p, uint8_t v) {
    atomic_store_explicit(
        (_Atomic uint8_t *)p, v, memory_order_relaxed);
}

// --- 32-bit ---

static inline uint32_t
swift_cpu_atomic_load_acquire_u32_v1(const uint32_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint32_t *)p, memory_order_acquire);
}

static inline void
swift_cpu_atomic_store_release_u32_v1(uint32_t *_Nonnull p, uint32_t v) {
    atomic_store_explicit(
        (_Atomic uint32_t *)p, v, memory_order_release);
}

static inline uint32_t
swift_cpu_atomic_load_relaxed_u32_v1(const uint32_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint32_t *)p, memory_order_relaxed);
}

static inline void
swift_cpu_atomic_store_relaxed_u32_v1(uint32_t *_Nonnull p, uint32_t v) {
    atomic_store_explicit(
        (_Atomic uint32_t *)p, v, memory_order_relaxed);
}

// --- 64-bit ---

static inline uint64_t
swift_cpu_atomic_load_acquire_u64_v1(const uint64_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint64_t *)p, memory_order_acquire);
}

static inline void
swift_cpu_atomic_store_release_u64_v1(uint64_t *_Nonnull p, uint64_t v) {
    atomic_store_explicit(
        (_Atomic uint64_t *)p, v, memory_order_release);
}

static inline uint64_t
swift_cpu_atomic_load_relaxed_u64_v1(const uint64_t *_Nonnull p) {
    return atomic_load_explicit(
        (_Atomic const uint64_t *)p, memory_order_relaxed);
}

static inline void
swift_cpu_atomic_store_relaxed_u64_v1(uint64_t *_Nonnull p, uint64_t v) {
    atomic_store_explicit(
        (_Atomic uint64_t *)p, v, memory_order_relaxed);
}

#endif // SWIFT_CPU_ATOMIC_SHIM_H
