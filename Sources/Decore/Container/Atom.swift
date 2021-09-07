/// Atom is a type definition protocol that has only one value in the storage.
///
/// **Example:**
/// ```swift
/// struct Item: Atom {
///     static var initial: Int { -1 }
/// }
/// ```
public protocol Atom : Container {
    associatedtype Value
    static var initial: () -> Value { get }
}

public extension Atom {
    static var key: Storage.Key {
        .atom(String(describing: Self.self))
    }
}

public extension Atom where Self: Mutable {
    static func setValue(_ value: Value, write: Writer) {
        // nothing special on mutation
    }
}

