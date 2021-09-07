
/// Keyed container of data in the storage
public protocol Container {
    associatedtype Value
}

public extension Storage {
    /// A key for the ``Container`` that is used to access the value.
    /// First parameter is always the type name of the child e.g. `Atom<Int>` would have a key `.atom("Int")`.
    enum Key: Hashable  {

        /// Atomic value, accessed by type name
        case atom(String)

        /// Group of Containers that accessed by id and type name
        case grouped(String, id: AnyHashable)

        /// A key for the container that is computed and stored.
        case derived(String)

        /// A key for the container that is computed but never stored.
        /// A result of the computation is provided every time the value is read.
        case computation(String)

        // MARK: - Utility -

        /// A key for the container that depends on other container.
        case observation(String)

        /// For operations that are being performed by the storage itself.
        case storage(String)

        /// For consumers of the storage e.g. operator classes, views, readers etc.
        case consumer(String)
    }
}
