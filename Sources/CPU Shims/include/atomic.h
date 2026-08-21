#ifndef SWIFT_CPU_ATOMIC_SHIM_H
#define SWIFT_CPU_ATOMIC_SHIM_H

#include <stdatomic.h>
#include <stdint.h>

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

#endif
