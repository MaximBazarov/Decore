//
//  ComputedAtom.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// ComputedAtom is the ``Atom`` that calculates a value
/// depending on the other values in the storage that ``ComputedAtom`` reads during computation.
/// if ``ComputedAtom/shouldStoreComputedValue()-2c6d5`` returns true,
/// the computed value will be written into the ``Storage``.
/// By default it returns `true`.
///
/// **Usage:**
/// TBD
public protocol ComputedAtom: ValueContainer, KeyedContainer {

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool

    /// Called when when computation value is read
    /// and there is no valid value in the ``Storage``.
    ///
    /// `shouldStoreComputedValue()`: Defines whether a computed value
    /// should be written into the ``Storage``
    ///
    /// - Returns: ``Value``
    static func value(read: Storage.Reader) -> Value

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}


// MARK: - Key Default Implementation

public extension ComputedAtom {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Atom`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}

public extension ComputedAtom {
    static func shouldStoreComputedValue() -> Bool { true }
}
