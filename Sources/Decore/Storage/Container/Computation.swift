

/// Computation is a container for the ``Value`` that is never stored in the ``Storage``.
/// It gets invalidated every time one of it's dependencies changed.
///
/// **Usage:**
/// ```swift
/// struct SelectedItem: Computation {
///     static var value = { read in
///         let id = read(SelectedItemID)
///         read(Items, at: id)
///     }
/// }
/// ```
public protocol Computation: Container {
    associatedtype Value

    static var value: (Reader) -> Value { get }
}

public extension Computation {

    static var key: Storage.Key {
        .computation(String(describing: Self.self))
    }

}
