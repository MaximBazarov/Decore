/// Container Group is the ``Container`` for the same type Containers distinguished by their ``ID``.
///
/// **Usage:**
/// TBD
public protocol ContainerGroup: Container {

    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable


    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func value(_ id: ID) -> Value

    /// Must return a unique key to store the value in the storage
    /// using a given ``ID``.
    ///
    /// - Returns: ``Storage/Key``
    static func key(_ id: ID) -> Storage.Key
}

public extension ContainerGroup {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``ContainerGroup`` adding the element id.
    static func key(_ id: ID) -> Storage.Key {
        .group(String(describing: Self.self), container: id)
    }
}

