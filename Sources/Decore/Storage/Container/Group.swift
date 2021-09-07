

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



// MARK: - Reader -
public extension Reader {
    
    /// Returns the value from storage for an item of given ``Group`` at id.
    func callAsFunction<G: Group>(_ table: G.Type, at id: G.ID) -> G.Value {
        storage.read(
            G.key(at: id),
            context: context,
            fallbackValue: { G.initial(for: id) },
            observation: observation
        )
    }
}

// MARK: - Writer -
public extension Writer {
    
    /// Writes the value into storage an item of given ``Group`` at id.
    func callAsFunction<G: Group>(_ value: G.Value, for table: G.Type, at id: G.ID) {
        storage.write(
            value,
            into: G.key(at: id),
            context: context)
    }
}

