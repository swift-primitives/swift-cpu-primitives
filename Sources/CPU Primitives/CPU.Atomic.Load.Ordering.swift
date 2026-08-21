extension CPU.Atomic.Load {

    public enum Ordering: Sendable {

        case relaxed

        case acquiring
    }
}
