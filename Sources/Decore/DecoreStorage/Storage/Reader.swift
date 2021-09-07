/// Reader is a wrapper to access the values in storage observing changes.
/// Calling reader as function will return the value for given ``Container``
public struct Reader {

    public let storage: Storage
    public let observation: Observation
    public let context: Context

    public init(storage: Storage, observation: Observation, context: Context) {
        self.storage = storage
        self.observation = observation
        self.context = context
    }

    // functions `callAsFunction(T)` are defined in concrete types e.g. Atom, as extensions.

}

