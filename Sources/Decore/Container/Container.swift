// MARK: - Container

/// Container is a wrapper for the value that allows it to be stored in the ``Storage``
public protocol Container {

    /// Type of the value stored in container.
    associatedtype Value


    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func value() -> Value


    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}

public extension Container {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Container`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


// MARK: - Container Group



// MARK: - Derivatives


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
