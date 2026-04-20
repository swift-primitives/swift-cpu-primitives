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

import Testing
@testable import CPU_Primitives

@Suite("CPU.Cache")
struct CPUCacheTests {

    @Suite("Prefetch")
    struct PrefetchTests {
        @Test
        func `prefetch read completes without error`() {
            let buffer = [UInt8](repeating: 0, count: 64)
            unsafe buffer.withUnsafeBytes { ptr in
                unsafe CPU.Cache.prefetch.read(ptr.baseAddress!)
            }
        }

        @Test
        func `prefetch write completes without error`() {
            var buffer = [UInt8](repeating: 0, count: 64)
            unsafe buffer.withUnsafeMutableBytes { ptr in
                unsafe CPU.Cache.prefetch.write(ptr.baseAddress!)
            }
        }

        @Test
        func `prefetch can be called on array elements`() {
            var data = [Int](repeating: 0, count: 1000)
            unsafe data.withUnsafeMutableBufferPointer { buffer in
                // Prefetch multiple cache lines
                for i in stride(from: 0, to: buffer.count, by: 8) {
                    let ptr = unsafe buffer.baseAddress! + i
                    unsafe CPU.Cache.prefetch.read(UnsafeRawPointer(ptr))
                }
            }
        }
    }
}
