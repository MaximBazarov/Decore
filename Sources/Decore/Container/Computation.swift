/// TBD
public protocol ComputationConfiguration {

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool
}

/// Computation is the ``Container`` that calculates a value
/// depending on the other values in the storage that ``Computation`` reads during computation.
/// if ``Computation/shouldStoreComputedValue()-2c6d5`` returns true,
/// the computed value will be written into the ``Storage``.
/// By default it returns `true`.
///
/// **Usage:**
/// TBD
public protocol Computation: ComputationConfiguration, Container {
    /// Called when when computation value is read
    /// and there is no valid value in the ``Storage``.
    ///
    /// `shouldStoreComputedValue()`: Defines whether a computed value
    /// should be written into the ``Storage``
    ///
    /// - Returns: ``Value``
    static func value(read: Reader) -> Value
}

extension Computation {
    static func value() -> Value { value(read: Reader()) }
    static func shouldStoreComputedValue() -> Bool { true }
}


public struct Reader {

    public func callAsFunction<C: Container>(_ container: C.Type) -> C.Value {
        fatalError()
    }

    public func callAsFunction<C: Computation>(_ container: C.Type) -> C.Value {
        fatalError()
    }
    public func callAsFunction<C: ContainerGroup>(
        _ container: C.Type,
        at id: C.ID
    ) -> C.Value {
        fatalError()
    }
}
