/// Container is a wrapper for the ``ValueContainer/Value``.
/// Storage can read, write and observe the value using a unique key
/// returned by ``key()-9gare`` function.
///
public protocol Container: KeyedContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue() -> Value
}

public protocol KeyedContainer: ValueContainer {

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}

// MARK: - Key Defaut Implementation

public extension Container {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Container`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


// MARK: - Storage Read/Write/Observe

//extension Storage {
//
//    /// Writes s given ``ValueContainer/Value`` into a ``Container`` storage.
//    func write<C: Container>(
//        _ value: C.Value,
//        into container: C.Type
//    ) {
//        let destination = C.key()
//        update(value: value, atKey: destination)
//    }
//
//    func read<C: Container>(
//        _ container: C.Type
//    ) -> C.Value {
//        let destination = C.key()
//        guard let value = readValue(at: destination) as? C.Value else {
//            let newValue = container.initialValue()
//            update(value: newValue, atKey: destination)
//            return newValue
//        }
//        return value
//    }
//
//}

public extension Storage.Reader {

    func callAsFunction<C: Container>(_ container: C.Type) -> C.Value {
        return self(container.key(), fallbackValue: container.initialValue)
    }

}

