//
//  Atom.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Atom is a wrapper for the ``ValueContainer/Value``.
/// Storage can read, write and observe the value using a unique key
/// returned by ``key()`` function.
///
public protocol Atom: ValueContainer, KeyedContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static var initialValue: () -> Value { get }
}

public extension Atom {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Atom`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


