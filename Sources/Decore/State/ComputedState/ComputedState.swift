//
//  ComputedState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// ComputedState calculates its value based on other states.
///
/// Define the ``ComputedState/value(read:)`` function that provides
/// a ``Storage/Reader`` to access values of other states.
/// When the value is read, ``Storage`` will add this ``ComputedState``
/// as a depender, recalculating the ``ComputedState`` value when one or many
/// dependencies are updated.
///
/// **Storing value:**
/// if ``ComputedState/shouldStoreComputedValue()-bjf6`` returns true,
/// the computed value will be written into the ``Storage``
/// after the recalculation.
/// Default value is `true`.
///
/// **Usage:**
/// ```swift
/// struct Sum: ComputedState {
///     typealias Value = Int
///     static func value(read: Storage.Reader) -> Value {
///         let a = read(A.self)
///         let b = read(B.self)
///         return a + b
///     }
/// }
/// ```
/// In this example computed state is a sum of `A` and `B` states.
/// If `A` or/and `B` states are updated, `Sum` state value will be recalculated
/// using ``ComputedState/value(read:)`` function.
///
public protocol ComputedState: ValueContainer, KeyedContainer {

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool

    /// ComputedState value calculation
    static func value(read: Storage.Reader) -> Value

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}


// MARK: - Key Default Implementation

public extension ComputedState {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``AtomicState`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}

public extension ComputedState {
    static func shouldStoreComputedValue() -> Bool { true }
}


