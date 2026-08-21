extension CPU.Atomic.Store {

    public enum Ordering: Sendable {

        case relaxed

        case releasing
    }
}
