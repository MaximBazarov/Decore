//
//  Container.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Container is a wrapper for the ``ValueContainer/Value``.
/// Storage can read, write and observe the value using a unique key
/// returned by ``key()`` function.
///
public protocol Container: ValueContainer, KeyedContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue() -> Value
}

// MARK: - Key Defaut Implementation

public extension Container {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Container`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


// MARK: - Storage Read/Write/Observe

public extension Storage.Reader {

    func callAsFunction<C: Container>(_ container: C.Type) -> C.Value {
        return self(container.key(), fallbackValue: container.initialValue)
    }

}

