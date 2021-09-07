/// Observing accessor to the ``Atom`` value,
/// and providing the access to mutate the value.
/// calls onChange every time the ``Atom`` has changed.
///
/// **Usage:**
/// ```swift
/// public extension BindingTo where C: Atom {
///
///     convenience init<T>(
///         _ atom: C.Type,
///         as observer: T.Type,
///         onChange: @escaping (C.Value) -> Void = { _ in }
///     ) {
///         self.init(observer: observer) { read in
///             read(atom)
///         } write: { value, write in
///             write(value, for: atom)
///         } onChange: { value in
///             onChange(value)
///         }
///     }
///
/// }
/// ```
@propertyWrapper
public class StateOf<C: Container> {

    private let observation: Observation
    private let readValue: () -> C.Value

    /// Access to the value:
    public var wrappedValue: C.Value {
        get { readValue() }
    }

    /// Creates an observing accessor to the ``Container``.
    /// - Parameters:
    ///   - context: Where this initializer was called from.
    ///   - reader: The container that access was initiated from.
    ///   - read: Inject a reading function.
    ///   - write: Inject a writing function.
    ///   - onChange: A callback called with the read function provided
    ///    that will be called every time the value changes.
    internal init(
        context: Context,
        read: @escaping (Reader) -> (C.Value),
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        let storage = StorageManager.storage
        self.observation = Observation(context)
        let reader = Reader(
            storage: storage,
            observation: observation,
            context: context)

        self.readValue = {
            read(reader)
        }

        self.observation.onInvalidate = {
            onChange({ read(reader) })
        }
    }

    /// Forces observer to emit the current value
    public func standby() {
        observation.onInvalidate()
    }
}
