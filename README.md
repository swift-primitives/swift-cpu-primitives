# CPU Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A `CPU` namespace of policy-free, portable wrappers over CPU-specific instructions — pointer atomics, memory barriers, cache prefetch and false-sharing padding, spin-wait hints, hardware CRC-32C, and high-resolution timestamps — with zero platform dependencies.

---

## Quick Start

`CPU` exposes the instructions the compiler and standard library do not give you directly, with one rule running through all of them: the **weakest-semantics guarantee**. A portable operation promises no more than the weakest supported architecture delivers, so code written against it behaves the same on x86-64 and ARM64.

The atomics order a *single* load or store on memory you own through a raw pointer — an mmap'd ring buffer, shared-memory IPC, or a lock-free structure — rather than a Swift `Atomic<T>`. They are lighter than a standalone fence (`ldar`/`stlr` on ARM64, not `dmb`).

```swift
import CPU_Primitives

// A producer publishes a ring-buffer tail; a consumer observes it.
// The index lives in memory both sides share directly, not in a Swift `Atomic<T>`.
var tail: UInt32 = 0

withUnsafeMutablePointer(to: &tail) { slot in
    // Release the write so the producer's prior stores become visible first.
    CPU.Atomic.store(slot, 42, ordering: .releasing)

    // Acquire the read so the consumer's later loads see that payload.
    let published = CPU.Atomic.load(slot, ordering: .acquiring)
    print(published)   // 42
}
```

`CPU.Cache.Padded` heap-allocates its value on its own 128-byte cache line, so a write-contended atomic cannot false-share with read-mostly neighbours (the sharded-cursor pattern). It wraps `~Copyable` values, which makes `Atomic` and `Mutex` the primary use case.

```swift
import CPU_Primitives
import Synchronization

let cursor = CPU.Cache.Padded(Atomic<Int>(0))
cursor.value.store(42, ordering: .releasing)
```

`CPU.Integrity.Cyclic.Castagnoli` computes CRC-32C — the checksum used by iSCSI, NVMe, and SCTP — on the hardware CRC instruction where present (SSE4.2 / the ARMv8 CRC extension), with a software table fallback. This is *not* the IEEE polynomial used by Ethernet and ZIP.

```swift
import CPU_Primitives

let bytes: [UInt8] = Array("123456789".utf8)
let checksum = bytes.withUnsafeBytes { buffer in
    CPU.Integrity.Cyclic.Castagnoli.compute(buffer)
}
print(checksum.rawValue)   // 0xE3069283 — the CRC-32C reference check value
```

`CPU.Spin.hint()` (a `PAUSE` / `YIELD` hint for bounded spin loops), `CPU.Barrier.hardware` / `CPU.Barrier.compiler` (standalone fences), `CPU.Cache.prefetch`, and `CPU.Timestamp.read()` round out the surface. Every one is advisory under the weakest-semantics rule: consult the type's documentation before relying on stronger behaviour.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-cpu-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "CPU Primitives", package: "swift-cpu-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products over an internal C shim. Depends only on the `Binary` primitives for its `Binary.Serializable` conformances.

| Product | Target | Purpose |
|---------|--------|---------|
| `CPU Primitives` | `Sources/CPU Primitives/` | The `CPU` namespace: pointer atomics (`CPU.Atomic`), memory barriers (`CPU.Barrier`), cache hints (`CPU.Cache` prefetch + `CPU.Cache.Padded`), spin-wait (`CPU.Spin`), hardware CRC-32C (`CPU.Integrity.Cyclic.Castagnoli`), and high-resolution timestamps (`CPU.Timestamp`). Backed by the internal `CCPUShim` C target. |
| `CPU Primitives Test Support` | `Tests/Support/` | Re-exports the main target for downstream test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
