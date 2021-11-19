public extension Storage {

    /// Wraps a ``Storage`` and optionally a ``Storage/Key`` of the reader.
    /// Calling it as function updates the dependency graph and returns a value.
    ///
    /// It's done because storage doesn't store the type of the value, in container,
    /// so each ``ValueContainer`` must extend the ``Storage/Reader`` with the
    /// `callAsFunction<C: Container>(_ container: C.Type) -> C.Value` function,
    /// where `Container` is the ``ValueContainer`` that extends.
    struct Reader {

        let storage: Storage
        let owner: Storage.Key?

        /// Read the value for key: ``Storage/Key`` from ``Storage``
        func read(key destination: Storage.Key) -> Any? {
            if let owner = owner {
                storage.insertDependency(owner, for: destination)
            }
            return storage.readValue(at:destination)
        }

        /// Initialize a reader that reads the storage adding dependency.
        /// - Parameters:
        ///   - storage: ``Storage`` to read from
        ///   - reader: A key of the ``ValueContainer`` that reads the value
        public init(storage: Storage? = nil, owner: Storage.Key? = nil) {
            self.storage = storage ?? Warehouse[.defaultStorage]
            self.owner = owner
        }

        func callAsFunction<V>(_ key: Storage.Key, fallbackValue: () -> V ) -> V {
            if let owner = owner {
                storage.insertDependency(owner, for: key)
            }
            guard let storedValue = storage.readValue(at: key) as? V else {
                let newValue = fallbackValue()
                storage.update(value: newValue, atKey: key)
                return newValue
            }
            return storedValue
        }

    }
}
