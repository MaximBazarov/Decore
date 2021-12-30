//
//  GroupState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// ComputedGroupState calculates its value based on other states.
/// It can also use an ``ID`` to alter calculation based on it.
///
/// Define the ``ComputedGroupState/value(at:read:)`` function that provides
/// a ``Storage/Reader`` to access values of other states.
///
/// **Storing value:**
/// if ``ComputedGroupState/shouldStoreComputedValue()-5xc4h`` returns true,
/// the computed value will be written into the ``Storage``
/// after the recalculation.
/// Default value is `true`.
///
/// **Usage:**
/// ```swift
/// struct Name: GroupState {
///     typealias Element = String
///     typealias ID = Int
///
///     static func initialValue(for id: Int) -> String { "" }
/// }
///
///
/// struct Surname: GroupState {
///     typealias Element = String
///     typealias ID = Int
///
///     static func initialValue(for id: Int) -> String { "" }
/// }
///
/// struct FullName: ComputedGroupState {
///     typealias Element = String
///     typealias ID = Int
///
///     static func value(at id: Int, read: Storage.Reader) -> String {
///         read(Name.self,at: id) + " " + read(Surname.self, at: id)
///     }
/// }
/// ```
///
/// In this example, `FullName` is computed concatenating `Name` and `Surname` states.
/// If `Name` or/and `Surname` states are updated,
/// `FullName` state value will be recalculated
/// using ``ComputedGroupState/value(at:read:)`` function.
///
public protocol ComputedGroupState: ValueContainer, KeyedContainer where Value == GroupOf<ID, Element> {

    /// Type of the wrapped value.
    associatedtype Element
    
    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable

    /// Must return a unique key to store the value in the storage
    /// using a given ``ID`` `Value == GroupOf<>`.
    ///
    /// - Returns: ``Storage/Key``
    static func key(for id: ID) -> Storage.Key

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool

    /// ComputedState value calculation
    static func value(at id: ID, read: Storage.Reader) -> Element

    // Group proxy
    static func initialValue(context: Context, in storage: Storage) -> Value
    static func getValue(for id: ID, context: Context, in storage: Storage) -> Element
}

public extension ComputedGroupState where Value == GroupOf<ID, Element> {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``ContainerGroup`` adding the element id.
    static func key(for id: ID) -> Storage.Key {
        .groupItem(String(describing: Self.self), id: id)
    }

    static func key() -> Storage.Key {
        .group(String(describing: Self.self))
    }

    static func initialValue(context: Context, in storage: Storage) -> Value {
        GroupOf<Self.ID, Self.Element> (
            get: { id in getValue(for: id, context: context, in: storage) },
            set: { _,_ in }
        )
    }

    static func getValue(for id: ID, context: Context, in storage: Storage) -> Element {
        let elementKey = key(for: id)
        let groupKey = key()
        let depender = elementKey
        let reader = Storage.Reader(
            context: context,
            storage: storage,
            owner: depender
        )
        return storage.readValue(
            at: elementKey,
            fallbackValue: { value(at: id, read: reader) },
            context: context,
            shouldStoreFallbackValue: true,
            depender: groupKey
        )
    }

    static func shouldStoreComputedValue() -> Bool { true }
}


