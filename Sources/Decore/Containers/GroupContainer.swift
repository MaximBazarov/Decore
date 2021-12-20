//
//  GroupContainer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Container Group is the group of ``ValueContainer``
/// that share the same ``ValueContainer/Value`` type and distinguished by ``ID``.
public protocol GroupContainer: ValueContainer, KeyedContainer where Value == GroupOf<ID, Element> {

    associatedtype Element
    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable

    /// Must return a unique key to store the value in the storage
    /// using a given `IDValue == GroupOf<>``.
    ///
    /// - Returns: ``Storage/Key``
    static func key(for id: ID) -> Storage.Key

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue(for id: ID) -> Element

    static func initialValue(context: Context) -> Value
    static func getValue(for id: ID, context: Context) -> Element
    static func setValue(_ value: Element, for id: ID, context: Context)
}

public extension GroupContainer where Value == GroupOf<ID, Element> {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``ContainerGroup`` adding the element id.
    static func key(for id: ID) -> Storage.Key {
        .groupItem(String(describing: Self.self), id: id)
    }

    static func key() -> Storage.Key {
        .group(String(describing: Self.self))
    }

    static func initialValue(context: Context) -> Value {
        GroupOf<Self.ID, Self.Element> (
            get: { id in getValue(for: id, context: context) },
            set: { element, id in setValue(element, for: id, context: context) }
        )
    }

    static func getValue(for id: ID, context: Context) -> Element {
        @StorageFor(Self.self) var storage
        let elementKey = key(for: id)
        let groupKey = key()
        return storage.readValue(
            at: elementKey,
            fallbackValue: { initialValue(for: id) },
            context: context,
            shouldStoreFallbackValue: true,
            depender: groupKey
        )
    }

    static func setValue(_ value: Element, for id: ID, context: Context)  {
        @StorageFor(Self.self) var storage;
        storage.update(value: value, atKey: key(for: id))
    }
}


public final class GroupOf<ID: Hashable, Element> {

    public init(get: @escaping (ID) -> Element, set: @escaping (Element, ID) -> Void) {
        self.get = get
        self.set = set
    }

    public var get: (ID) -> Element
    public var set: (Element, ID) -> Void

    public subscript(_ id: ID) -> Element {
        get { get(id) }
        set { set(newValue, id) }
    }
}
