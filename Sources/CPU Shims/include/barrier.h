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

// Single-instruction CPU operations: barriers, spin hints, cache prefetch.
//
// These are static inline because each compiles to exactly one instruction.
// A function call (~4-10 cycles) would dominate the actual work (~1 cycle).

#ifndef SWIFT_CPU_BARRIER_SHIM_H
#define SWIFT_CPU_BARRIER_SHIM_H

// Architecture detection
#if defined(__x86_64__) || defined(__i386__) || defined(_M_X64) || defined(_M_IX86)
    #define SWIFT_CPU_BARRIER_X86 1
#elif defined(__aarch64__) || defined(__arm64__) || defined(_M_ARM64)
    #define SWIFT_CPU_BARRIER_ARM64 1
#elif defined(__arm__) || defined(_M_ARM)
    #define SWIFT_CPU_BARRIER_ARM32 1
#endif

#if defined(_MSC_VER)
    #include <intrin.h>
    #define SWIFT_CPU_BARRIER_MSVC 1
#elif defined(__GNUC__) || defined(__clang__)
    #if SWIFT_CPU_BARRIER_X86
        #include <x86intrin.h>
    #endif
#endif

// ============================================================================
// Spin Hints
// ============================================================================

static inline void swift_cpu_spin_hint_v1(void) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_pause();
    #else
        __builtin_ia32_pause();
    #endif
#elif SWIFT_CPU_BARRIER_ARM64 || SWIFT_CPU_BARRIER_ARM32
    __asm__ __volatile__("yield" ::: "memory");
#else
    (void)0;
#endif
}

// ============================================================================
// Memory Barriers
// ============================================================================

static inline void swift_cpu_barrier_compiler_v1(void) {
#if defined(SWIFT_CPU_BARRIER_MSVC)
    _ReadWriteBarrier();
#else
    __asm__ __volatile__("" ::: "memory");
#endif
}

static inline void swift_cpu_barrier_full_v1(void) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_mfence();
    #else
        __asm__ __volatile__("mfence" ::: "memory");
    #endif
#elif SWIFT_CPU_BARRIER_ARM64
    __asm__ __volatile__("dmb ish" ::: "memory");
#elif SWIFT_CPU_BARRIER_ARM32
    __asm__ __volatile__("dmb ish" ::: "memory");
#else
    __asm__ __volatile__("" ::: "memory");
#endif
}

static inline void swift_cpu_barrier_load_v1(void) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_lfence();
    #else
        __asm__ __volatile__("lfence" ::: "memory");
    #endif
#elif SWIFT_CPU_BARRIER_ARM64
    __asm__ __volatile__("dmb ishld" ::: "memory");
#elif SWIFT_CPU_BARRIER_ARM32
    __asm__ __volatile__("dmb ish" ::: "memory");
#else
    __asm__ __volatile__("" ::: "memory");
#endif
}

static inline void swift_cpu_barrier_store_v1(void) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_sfence();
    #else
        __asm__ __volatile__("sfence" ::: "memory");
    #endif
#elif SWIFT_CPU_BARRIER_ARM64
    __asm__ __volatile__("dmb ishst" ::: "memory");
#elif SWIFT_CPU_BARRIER_ARM32
    __asm__ __volatile__("dmb ish" ::: "memory");
#else
    __asm__ __volatile__("" ::: "memory");
#endif
}

// ============================================================================
// Cache Prefetch
// ============================================================================

static inline void swift_cpu_cache_prefetch_read_v1(const void* ptr) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_prefetch((const char*)ptr, _MM_HINT_T0);
    #else
        __builtin_prefetch(ptr, 0, 3);
    #endif
#elif SWIFT_CPU_BARRIER_ARM64 || SWIFT_CPU_BARRIER_ARM32
    __builtin_prefetch(ptr, 0, 3);
#else
    (void)ptr;
#endif
}

static inline void swift_cpu_cache_prefetch_write_v1(void* ptr) {
#if SWIFT_CPU_BARRIER_X86
    #if defined(SWIFT_CPU_BARRIER_MSVC)
        _mm_prefetch((const char*)ptr, _MM_HINT_T0);
    #else
        __builtin_prefetch(ptr, 1, 3);
    #endif
#elif SWIFT_CPU_BARRIER_ARM64 || SWIFT_CPU_BARRIER_ARM32
    __builtin_prefetch(ptr, 1, 3);
#else
    (void)ptr;
#endif
}

#endif // SWIFT_CPU_BARRIER_SHIM_H
