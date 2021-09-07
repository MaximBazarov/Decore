@propertyWrapper
public class BindingTo<C: Container & Mutable> {

    private let observation: Observation
    private let readValue: () -> C.Value
    private let writeValue: (C.Value) -> ()

    /// Access to the value:
    public var wrappedValue: C.Value {
        get { readValue() }
        set { writeValue(newValue) }
    }

    /// Creates an observing mutating accessor to the ``Container``.
    /// - Parameters:
    ///   - context: Where this initializer was called from.
    ///   - reader: The container that access was initiated from
    ///   - read: Inject a reading function.
    ///   - write: Inject a writing function.
    ///   - onChange: A callback called with the read function provided
    ///    that will be called every time the value changes.
    internal init(
        context: Context,
        read: @escaping (Reader) -> (C.Value),
        write: @escaping (Writer, C.Value) -> (),
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
        let writer = Writer(
            storage: storage,
            context: context)
        self.writeValue = { value in
            write(writer, value)
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



