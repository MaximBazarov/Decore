//
//  ComputedState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// ComputedState calculates its value based on other states.
/// It calculates the value exactly like ``ComputedGroupState``.
///
/// Define the ``WritableComputedGroupState/setValue(_:at:read:write:)`` 
/// to set states values using provided `write` function.

/// **Usage:**
/// ```swift
/// struct Sum: WritableComputedGroupState {
///     typealias Element = Int
///     typealias ID = Int
///
///     static func value(at id: Int, read: Storage.Reader) -> Int {
///         return read(A.self, at: id) + read(B.self, at: id)
///     }
///
///     static func setValue(_ value: Int, at id: Int, read: Storage.Reader, write: Storage.Writer) {
///         let a = read(A.self)
///         let newValueOfB = value - a
///         write(newValueOfB, into: B.self, at: id)
///     }
/// }
///
/// ```
/// In this `Sum` is a sum of of `A` and `B` states,
/// where `B` is a ``GroupState`` too that are also a group states.
/// When value is assigned to ``Sum`` it keeps the `A` value unchanged,
/// and calculates an appropriate value for `B` at id.
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


