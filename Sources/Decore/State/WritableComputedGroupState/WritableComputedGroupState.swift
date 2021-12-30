//
//  WritableComputedGroupState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Writable Computed Group State is a ``ComputedGroupState`` that also
/// writes other states based on assigned value.
///
/// Define the ``WritableComputedGroupState/setValue(_:at:read:write:)`` function
/// that sets other states using provided ``Storage/Writer``.
/// Use provided ``Storage/Reader`` to access values of other states.
///
/// Calculation and storage is the same as in ``ComputedGroupState``.
///
/// **Usage:**
/// ```swift
/// struct Sum: WritableComputedState {
///     typealias Value = Int
///
///     static func value(read: Storage.Reader) -> Value {
///         let a = read(A.self)
///         let b = read(B.self)
///         return a + b
///     }
///
///     // calculate and write other states
///     static func setValue(_ value: Value, read: Storage.Reader, write: Storage.Writer) {
///         let a = read(A.self)
///         write(value - a, B.self)
///     }
/// }
/// ```
/// In this example computed state is a sum of `A` and `B` states.
/// When new value is assigned to computation, it keeps the value of `A` unchanged.
/// But sets the value of `B` to the difference between new value and `A`
///
public protocol WritableComputedGroupState: ComputedGroupState {

    /// ComputedState value calculation
    static func setValue(_ value: Element, at id: ID, read: Storage.Reader, write: Storage.Writer)
}


