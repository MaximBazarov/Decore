

/// Group is a container for the group of ``Value``s
/// sharing the same Value type.
/// There's no other relation among these ``Value``s
/// - The only possible access is by ``ID``.
///
/// **Usage:**
/// ```swift
/// struct FeatureFlags: Group {
///     static func initial(for id: String) -> Bool {
///         false
///     }
/// }
/// ```
public protocol Group: Container {
    associatedtype Value
    associatedtype ID: Hashable
    
    static func initial(for id: ID) -> Value
}

public extension Group {
    
    static func key(at id: ID) -> Storage.Key {
        .grouped(String(describing: Self.self), id: id)
    }
    
}

public extension Group where Self: Mutable {
    static func setValue(_ value: Value, write: Writer) {
        // nothing special on mutation
    }
}

