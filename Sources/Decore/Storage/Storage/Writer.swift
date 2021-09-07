/// Writer is a wrapper to access the values in storage observing changes.
/// Calling reader as function will write the value for given ``Container``
public struct Writer {

    public let storage: Storage
    public let context: Context

    public init(storage: Storage, context: Context) {
        self.storage = storage
        self.context = context
    }
    
    // functions `callAsFunction(T)` are defined in concrete types e.g. Atom, as extensions.
}


