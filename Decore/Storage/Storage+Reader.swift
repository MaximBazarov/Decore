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
    /// `callAsFunction<C: AtomicState>(_ container: C.Type) -> C.Value` function,
    /// where `AtomicState` is the ``ValueContainer`` that extends.
    final class Reader {

        let context: Context
        let storage: Storage

        /// Initialize a reader that reads the storage adding dependency.
        /// - Parameters:
        ///   - storage: ``Storage`` to read from
        ///   - reader: A key of the ``ValueContainer`` that reads the value
        public init(context: Context, storage: Storage) {
            self.context = context
            self.storage = storage
        }

    }
}
