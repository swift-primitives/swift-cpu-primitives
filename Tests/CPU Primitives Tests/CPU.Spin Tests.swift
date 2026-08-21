import Testing

@testable import CPU_Primitives

@Suite
struct `CPU.Spin Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `hint completes without error`() {

        CPU.Spin.hint()
    }

    @Test
    func `hint can be called repeatedly`() {

        for _ in 0..<1000 {
            CPU.Spin.hint()
        }
    }

    @Test
    func `hint from concurrent tasks`() async {

        let iterations = 100
        let taskCount = 4

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<taskCount {
                group.addTask {
                    for _ in 0..<iterations {
                        CPU.Spin.hint()
                    }
                }
            }
        }
    }
}
