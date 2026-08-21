extension CPU {

    public enum Barrier {}
}

extension CPU.Barrier {

    public static var compiler: Compiler { Compiler() }

    public static var hardware: Hardware { Hardware() }
}
