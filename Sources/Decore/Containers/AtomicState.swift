//
//  AtomicState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// AtomicState is a wrapper for the ``ValueContainer/Value``.
/// Storage can read, write and observe the value using a unique key
/// returned by ``key()`` function.
///
public protocol AtomicState: ValueContainer, KeyedContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue() -> Value
}

// MARK: - Key Defaut Implementation

public extension AtomicState {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``AtomicState`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


// MARK: - Storage Read/Write/Observe

public extension Storage.Reader {

    func callAsFunction<C: AtomicState>(_ container: C.Type) -> C.Value {
        return self(container.key(), fallbackValue: container.initialValue)
    }

}

public extension Storage.Writer {

    func callAsFunction<C: AtomicState>(_ value: C.Value, into container: C.Type) {
        return self(value, into: container.key())
    }

}

