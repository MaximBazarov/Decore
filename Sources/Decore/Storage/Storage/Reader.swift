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

    /// Returns the value from storage for given ```Atom``
    func callAsFunction<A: Atom>(_ atom: A.Type) -> A.Value {
        storage.read(
            atom.key,
            context: context,
            fallbackValue: { A.initial() },
            observation: observation
        )
    }
    
    /// Returns the computed value for a given ```Computation``
    func callAsFunction<C: Computation>(_ computation: C.Type) -> C.Value {
        storage.read(
            C.key,
            context: context,
            fallbackValue: { C.value(self) },
            observation: observation,
            cachingEnabled: false
        )
    }

    /// Returns the value from storage for a given ```Derived``
    func callAsFunction<D: Derived>(_ derived: D.Type) -> D.Value {
        storage.read(
            derived.key,
            context: context,
            fallbackValue: { D.value(self) },
            observation: observation
        )
    }

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

