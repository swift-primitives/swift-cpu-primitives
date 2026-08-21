import Testing

@testable import CPU_Primitives

extension CPU.Atomic.Flag {
    @Suite struct Tests {
        @Suite struct Unit {}
    }
}

extension CPU.Atomic.Flag.Tests.Unit {
    @Test
    func `set defaults isSet to false until called`() {
        let flag = CPU.Atomic.Flag()
        #expect(flag.isSet == false)
        flag.set()
        #expect(flag.isSet == true)
    }

    @Test
    func `initial value true starts isSet as set`() {
        let flag = CPU.Atomic.Flag(true)
        #expect(flag.isSet == true)
    }

    @Test
    func `concurrent set and isSet on a shared instance never trap under exclusivity enforcement`()
        async
    {
        let flag = CPU.Atomic.Flag()
        let workerCount = 32
        let iterationsPerWorker = 50_000

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<workerCount {
                group.addTask {
                    for _ in 0..<iterationsPerWorker {
                        flag.set()
                        _ = flag.isSet
                    }
                }
            }
        }

        #expect(flag.isSet)
    }
}
