import Testing

@testable import CPU_Primitives

@Suite
struct `CPU.Timestamp Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `read returns a value`() {
        let value = CPU.Timestamp.read()

        #expect(value.rawValue > 0)
    }

    @Test
    func `read can be called repeatedly`() {
        (0..<1000).forEach { _ in
            let _ = CPU.Timestamp.read()
        }
    }

    @Test
    func `successive reads generally increase`() {

        let first = CPU.Timestamp.read()

        var sum: UInt64 = 0
        (UInt64(0)..<10000).forEach { i in
            sum &+= i
        }
        _ = sum

        let second = CPU.Timestamp.read()

        if second.rawValue < first.rawValue {

            Issue.record("Timestamp decreased: \(first) -> \(second)")
        }
    }

    @Test
    func `read from concurrent tasks`() async {
        let taskCount = 4
        let iterations = 100

        await withTaskGroup(of: CPU.Timestamp.self) { group in
            (0..<taskCount).forEach { _ in
                group.addTask {
                    var lastValue: CPU.Timestamp = 0
                    (0..<iterations).forEach { _ in
                        lastValue = CPU.Timestamp.read()
                    }
                    return lastValue
                }
            }

            for await value in group {

                #expect(value.rawValue > 0)
            }
        }
    }
}
