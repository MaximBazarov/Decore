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

// MARK: - Reader -
public extension Reader {
    
    /// Returns the value from storage for given ```Atom``
    func callAsFunction<A: Atom>(_ atom: A.Type) -> A.Value {
        storage.read(
            atom.key,
            context: context,
            fallbackValue: { A.initial() },
            observation: observation
        )
    }
}

// MARK: - Writer -
public extension Writer {
    
    /// Writes the value into storage for given ```Atom``
    func callAsFunction<A: Atom>(
        _ value: A.Value,
        for atom: A.Type,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        storage.write(
            value,
            into: A.key,
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: atom.key))
    }
}
