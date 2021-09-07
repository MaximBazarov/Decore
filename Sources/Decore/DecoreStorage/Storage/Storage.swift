/// Storage for ``Container``s that stores the values by its ``Key``,
/// builds the dependencies tree, and assign the observations to observed ``Container``s.
/// to access the value in the storage, use the ``Reader`` or ``StateOf``.
public final class Storage {
    
    internal var observations: [Storage.Key: ObservationStorage] = [:]
    internal var dependencies: [Storage.Key: Set<Storage.Key>] = [:]
    internal var values: [Storage.Key: Any] = [:]
    
    
    /// Creates a new storage
    public init() {}


    /// Read value from the storage adding observation,
    /// and building the dependency tree
    /// - Parameters:
    ///   - container: ``Storage.Key`` to read
    ///   - context: Context of the reader, that will be depending on `key`
    ///   - observation: ``Observation`` to notify of changes
    ///   - fallbackValue: Function that provides the value if it's not in the storage.
    ///   - cachingEnabled: If true, the provided fallback value will be written into the storage.
    ///
    /// - Returns: Value stored at key or `fallbackValue` if it's not in the storage.
    func read<Value>(
        _ container: Storage.Key,
        context: Context,
        fallbackValue: () -> Value,
        observation: Observation? = nil,
        cachingEnabled: Bool = true
    ) -> Value {
        let reader = context.container
        let tracingValue: Value?
        print("┌─[R] \(context) reads \(container) ")

        defer {
            if let observation = observation {
                observations.insert(observation, for: reader)
            }
            dependencies.insert(reader, dependsOn: container)
            let value = tracingValue != nil ? String(describing: tracingValue!) : ""
            print("└─ \(container) -> \(value) [/R]")
        }

        if !cachingEnabled {
            let value = fallbackValue()
            print("├─  read \(container) fallbackValue, no-caching")
            tracingValue = value
            return value
        }

        if let value = values[container] as? Value {
            print("├─  read \(container) cached value")
            tracingValue = value
            return value
        }

        let value = fallbackValue()
        print("├─  read \(container) fallbackValue, caching...")
        write(value, into: container, context: Context(container: .storage("CACHE FALLBACK VALUE")))
        tracingValue = value
        return value
    }
    
    func write<Value>(_ value: Value, into container: Storage.Key, context: Context) {
        print("┌─[W] \(context) writes \(value) into \(container)")

        var observationStorages: Set<ObservationStorage> = []

        if let storage = observations[container] {
            observationStorages.insert(storage)
        }

        var keysToInvalidate: Set<Key> = []

        dependencies[container]?.forEach { dependency in
            if let storage = observations[dependency] {
                observationStorages.insert(storage)
            }
            keysToInvalidate.insert(dependency)
        }

        keysToInvalidate.forEach { key in
            print("├─ invalidated \(key) in  storage")
            values.removeValue(forKey: key)
        }

        values[container] = value
        var invalidated = 0
        var disposed = 0

        observationStorages.forEach { storage in
            let (i, d) = storage.invalidateIfNeeded()
            invalidated += i
            disposed += d
        }
        if invalidated > 0 {
            print("├─ \(invalidated) invalidated observations of \(container)")
        }
        if disposed > 0 {
            print("├─ \(disposed) disposed observations of \(container)")
        }

        observationStorages.forEach { storage in
            storage.ready()
        }
        print("├─  standby observations of [ \(container) ]")

        print("└─ \(container) [/W]")
    }

}


// MARK:  - Observations
/// Syntax sugar for [Storage.Key: ObservationStorage]
extension Dictionary where Key == Storage.Key, Value == ObservationStorage {
    
    mutating func insert<O: Observation>(_ observation: O, for key: Storage.Key) {
        defer {
            print("├─ \(observation.context) — observes -> \(key)")
        }
        guard self[key] != nil else {
            let storage = ObservationStorage()
            storage.insert(observation)
            self[key] = storage
            return
        }
        self[key]!.insert(observation)
    }
    
}

// MARK:  - Dependencies
/// Syntax sugar for [Storage.Key: Set<Storage.Key>]
extension Dictionary where Key == Storage.Key, Value == Set<Storage.Key> {
    
    mutating func insert(_ dependence: Storage.Key, dependsOn key: Storage.Key) {
        guard dependence != key else { return }
        defer {
            print("├─ \(dependence) — depends on -> \(key)")
        }
        guard self[key] != nil else {
            var storage = Set<Storage.Key>()
            storage.insert(dependence)
            self[key] = storage
            return
        }
        self[key]!.insert(dependence)
    }
}

