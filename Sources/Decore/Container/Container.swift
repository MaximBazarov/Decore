/// Container is a wrapper for the ``ValueContainer/Value``.
/// Storage can read, write and observe the value using a unique key
/// returned by ``key()-9gare`` function.
///
public protocol Container: ValueContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue() -> Value


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

extension Storage {

    /// Writes s given ``ValueContainer/Value`` into a ``Container`` storage.
    func write<C: Container>(
        _ value: C.Value,
        into container: C.Type
    ) {
        let destination = C.key()
        update(value: value, atKey: destination)
    }

    func observe<C: Container>(
        container: C.Type,
        observation: Observation
    ) -> C.Value {
        let destination = container.key()
        let read = Reader(storage: self)
        insertObservation(observation, for: destination)
        return read(container)
    }
}

public extension Storage.Reader {

    func callAsFunction<C: Container>(_ container: C.Type) -> C.Value {
        let destination = container.key()
        guard let value = self.read(key: destination) as? C.Value else {
            let newValue = container.initialValue()
            storage.update(value: newValue, atKey: destination)
            return newValue
        }
        return value
    }

}
