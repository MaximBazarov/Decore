//
//  Computation.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Computation is the ``AtomicState`` that calculates a value
/// depending on the other values in the storage that ``Computation`` reads during computation.
/// if ``Computation/shouldStoreComputedValue()-2c6d5`` returns true,
/// the computed value will be written into the ``Storage``.
/// By default it returns `true`.
///
/// **Usage:**
/// TBD
public protocol Computation: ValueContainer, KeyedContainer {

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


// MARK: - Key Defaut Implementation

public extension Computation {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``AtomicState`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}

public extension Computation {
    static func shouldStoreComputedValue() -> Bool { true }
}
