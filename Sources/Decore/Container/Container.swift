/// Container is a wrapper for the value that allows it to be stored in the ``Storage``
public protocol Container: ValueContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func value() -> Value


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
        update(container, value: value, atKey: destination)
    }


    func readValue<C: Container>(
        of container: C.Type,
        key destination: Key,
        initial: () -> C.Value
    ) -> C.Value {
        if let value = storage[destination] as? C.Value {
            return value
        }

        let newValue = initial()
        update(container, value: newValue, atKey: destination)
        return newValue
    }

    func observe<C: Container>(
        container: C.Type,
        observation: Observation
    ) -> C.Value {
        let destination = C.key()
        insertObservation(observation, for: destination)
        let value = readValue(of: container, key: destination, initial: C.value)
        return value
    }
}
