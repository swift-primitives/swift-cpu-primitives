import Testing

@testable import CPU_Primitives

@Suite
struct `CPU.Cache Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Suite
    struct `Prefetch Tests` {
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

                for i in stride(from: 0, to: buffer.count, by: 8) {
                    let ptr = unsafe buffer.baseAddress! + i
                    unsafe CPU.Cache.prefetch.read(UnsafeRawPointer(ptr))
                }
            }
        }
    }
}
