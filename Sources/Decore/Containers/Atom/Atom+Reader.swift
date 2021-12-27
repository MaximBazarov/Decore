//
//  AtomicState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage.Reader {

    /// Reads the value of the ``AtomicState``
    /// - Returns: ``AtomicState``'s wrapped value
    func callAsFunction<C: AtomicState>(_ container: C.Type) -> C.Value {
        return self(container.key(), fallbackValue: container.initialValue)
    }

}
