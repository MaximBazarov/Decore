//
//  GroupState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// GroupState stores many values of the same type ``Element``
/// distinguished by ``ID``.
///
/// **Usage:**
/// ```swift
/// struct Name: GroupState {
///     typealias Element = String
///     typealias ID = Int
///
///     static func initialValue(for id: Int) -> String {
///         ""
///     }
/// }
/// ```
/// to access the value you need to provide an ``ID`` e.g.
/// ```swift
/// struct TodoItemView: View {
///     var id: TodoList.Item.ID
///     @Bind(Name.self) var name
///
///     var body: some View {
///         TextField("name", text: $name[id])
///     }
/// }
/// ```
///
public protocol GroupState: ValueContainer, KeyedContainer where Value == GroupOf<ID, Element> {

    associatedtype Element
    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable

    /// Must return a unique key to store the value in the storage
    /// using a given ``ID`` `Value == GroupOf<>`.
    ///
    /// - Returns: ``Storage/Key``
    static func key(for id: ID) -> Storage.Key

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue(for id: ID) -> Element

    // Group proxy
    static func initialValue(context: Context, in storage: Storage) -> Value
    static func getValue(for id: ID, context: Context, in storage: Storage) -> Element
    static func setValue(_ value: Element, for id: ID, context: Context, in storage: Storage)
}

public extension GroupState where Value == GroupOf<ID, Element> {
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
            set: { element, id in setValue(element, for: id, context: context, in: storage) }
        )
    }

    static func getValue(for id: ID, context: Context, in storage: Storage) -> Element {
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

    static func setValue(_ value: Element, for id: ID, context: Context, in storage: Storage)  {
        storage.write(value: value, atKey: key(for: id))
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
