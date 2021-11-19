/// Container Group is the group of ``ValueContainer``
/// that share the same ``ValueContainer/Value`` type and distinguished by ``ID``.
public protocol ContainerGroup: ValueContainer {

    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable


    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue(for id: ID) -> Value

    /// Must return a unique key to store the value in the storage
    /// using a given ``ID``.
    ///
    /// - Returns: ``Storage/Key``
    static func key(for id: ID) -> Storage.Key
}

public extension ContainerGroup {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``ContainerGroup`` adding the element id.
    static func key(for id: ID) -> Storage.Key {
        .group(String(describing: Self.self), container: id)
    }
}

