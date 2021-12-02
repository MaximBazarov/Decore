public extension Storage {

    /// Wraps a ``Storage`` and optionally a ``Storage/Key`` of the reader.
    /// Calling it as function updates the dependency graph and returns a value.
    ///
    /// It's done because storage doesn't store the type of the value, in container,
    /// so each ``ValueContainer`` must extend the ``Storage/Reader`` with the
    /// `callAsFunction<C: Container>(_ container: C.Type) -> C.Value` function,
    /// where `Container` is the ``ValueContainer`` that extends.
    struct Reader {

        let owner: Storage.Key?

        var storage: Storage

        /// Initialize a reader that reads the storage adding dependency.
        /// - Parameters:
        ///   - storage: ``Storage`` to read from
        ///   - reader: A key of the ``ValueContainer`` that reads the value
        public init(storage: Storage? = nil, owner: Storage.Key? = nil) {
            self.owner = owner
            self.storage = storage ?? Warehouse.storage(for: Self.self)
        }

        func callAsFunction<V>(_ key: Storage.Key, fallbackValue: () -> V) -> V {
            return storage.readValue(at: key, fallbackValue: fallbackValue, depender: owner)
        }

    }
}
