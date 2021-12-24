//
//  Storage+Reader.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage {

    /// Wraps a ``Storage`` and optionally a ``Storage/Key`` of the reader.
    /// Calling it as function updates the dependency graph and returns a value.
    ///
    /// It's done because storage doesn't store the type of the value, in container,
    /// so each ``ValueContainer`` must extend the ``Storage/Reader`` with the
    /// `callAsFunction<C: Atom>(_ container: C.Type) -> C.Value` function,
    /// where `Atom` is the ``ValueContainer`` that extends.
    struct Reader {

        let owner: Storage.Key?
        let context: Context

        var storage: Storage

        /// Initialize a reader that reads the storage adding dependency.
        /// - Parameters:
        ///   - storage: ``Storage`` to read from
        ///   - reader: A key of the ``ValueContainer`` that reads the value
        public init(context: Context, storage: Storage? = nil, owner: Storage.Key? = nil) {
            self.context = context
            self.owner = owner
            self.storage = storage ?? Warehouse.storage(for: Self.self)
        }

        func callAsFunction<V>(_ key: Storage.Key, fallbackValue: () -> V) -> V {
            return storage.readValue(
                at: key,
                fallbackValue: fallbackValue,
                context: context,
                depender: owner
            )
        }

    }
}
