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
        @Test("prefetch read completes without error")
        func prefetchReadCompletes() {
            var buffer = [UInt8](repeating: 0, count: 64)
            buffer.withUnsafeBytes { ptr in
                CPU.Cache.prefetch.read(ptr.baseAddress!)
            }
        }

        @Test("prefetch write completes without error")
        func prefetchWriteCompletes() {
            var buffer = [UInt8](repeating: 0, count: 64)
            buffer.withUnsafeMutableBytes { ptr in
                CPU.Cache.prefetch.write(ptr.baseAddress!)
            }
        }

        @Test("prefetch can be called on array elements")
        func prefetchArrayElements() {
            var data = [Int](repeating: 0, count: 1000)
            data.withUnsafeMutableBufferPointer { buffer in
                // Prefetch multiple cache lines
                for i in stride(from: 0, to: buffer.count, by: 8) {
                    let ptr = buffer.baseAddress! + i
                    CPU.Cache.prefetch.read(UnsafeRawPointer(ptr))
                }
            }
        }
    }
}
