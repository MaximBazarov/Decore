

/// Derived is a container for a ``Value`` that is computed from other values in ``Storage``.
/// It's stored in the ``Storage`` and won't call a computation if no dependencies have changed.
///
/// **Usage:**
/// ```swift
/// struct SelectedItem: Derived {
///     static var value: (Reader) -> Item = { read in
///         let id = read(SelectedItemID)
///         read(Items, at: id)
///     }
/// }
/// ```
public protocol Derived: Container {
    associatedtype Value

    static var value: (Reader) -> Value { get }

    /// Implementation of writes that needs to be performed when value is set.
    /// Called only if this ``Derived`` conforms to ``Mutable``.
    ///
    /// Note: I'm not happy with this boilerplate,
    /// thinking of a better solution than that or `DerivedMutable` as a separate type.
    static func setValue(_ value: Value, write: Writer)
}


public extension Derived {

    static var key: Storage.Key {
        .derived(String(describing: Self.self))
    }

}


// MARK: - Reader -
public extension Reader {

    /// Returns the value from storage for a given ```Derived``
    func callAsFunction<D: Derived>(_ derived: D.Type) -> D.Value {
        storage.read(
            derived.key,
            context: context,
            fallbackValue: { D.value(self) },
            observation: observation
        )
    }
}


// MARK: - Writer -
public extension Writer {

    /// Writes the value into storage for given ```Atom``
    func callAsFunction<D: Derived & Mutable>(_ value: D.Value, for derived: D.Type){
        derived.setValue(value, write: self)
    }
}

