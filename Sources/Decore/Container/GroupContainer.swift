import CloudKit

/// Container Group is the group of ``ValueContainer``
/// that share the same ``ValueContainer/Value`` type and distinguished by ``ID``.
public protocol GroupContainer: ValueContainer, KeyedContainer where Value == GroupOf<Element> {

    associatedtype Element
    /// Unique identifier in addition to the group type name.
    associatedtype ID: Hashable

    /// Must return a unique key to store the value in the storage
    /// using a given ``ID``.
    ///
    /// - Returns: ``Storage/Key``
    static func key(for id: ID) -> Storage.Key

    /// Called when storage needs a value.
    /// For example when value hasn't been written yet,
    /// storage will call this function to get the initial value.
    /// - Returns: ``Value``
    static func initialValue(for id: ID) -> Element

}

public extension GroupContainer {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``ContainerGroup`` adding the element id.
    static func key(for id: ID) -> Storage.Key {
        .groupItem(String(describing: Self.self), id: id)
    }


    static func key() -> Storage.Key {
        .group(String(describing: Self.self))
    }
}

public final class GroupOf<Value> {
    static func initialValue() -> Self { Self() }
}


@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Bind where  C: GroupContainer  {

    subscript(_ id: C.ID) -> C.Element {
        get { fatalError() }
        set { fatalError() }
    }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Observe where  C: GroupContainer  {

    subscript(_ id: C.ID) -> C.Element {
        get { fatalError() }
    }
}


