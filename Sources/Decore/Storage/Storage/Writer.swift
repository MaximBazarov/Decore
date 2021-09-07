/// Writer is a wrapper to access the values in storage observing changes.
/// Calling reader as function will write the value for given ``Container``
public struct Writer {

    public let storage: Storage
    public let context: Context

    public init(storage: Storage, context: Context) {
        self.storage = storage
        self.context = context
    }

    /// Writes the value into storage for given ```Atom``
    public func callAsFunction<A: Atom>(
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
    
    /// Writes the value into storage an item of given ``Group`` at id.
    public func callAsFunction<G: Group>(_ value: G.Value, for table: G.Type, at id: G.ID) {
        storage.write(
            value,
            into: G.key(at: id),
            context: context)
    }

    /// Writes the value into storage for given ```Atom``
    public func callAsFunction<D: Derived & Mutable>(_ value: D.Value, for derived: D.Type){
        derived.setValue(value, write: self)
    }

}


