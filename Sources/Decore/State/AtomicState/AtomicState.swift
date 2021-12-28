//
//  AtomicState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// AtomicState stores a single value in ``Storage``.
///
/// Define the ``AtomicState/initialValue`` to provide a value
/// when ``AtomicState`` was read before it was written.
///
/// **Usage:**
/// ```swift
/// struct A: AtomicState {
///     typealias Value = Int
///     static var initialValue: () -> Value = { 0 }
/// }
/// ```
/// In this example computed state is a sum of `A` and `B` states.
/// If `A` or/and `B` states are updated, `Sum` state value will be recalculated
/// using ``ComputedState/value(read:)`` function.
///
public protocol AtomicState: ValueContainer, KeyedContainer {

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``ValueContainer/Value``
    static var initialValue: () -> Value { get }
}

public extension AtomicState {

    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``AtomicState`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}


