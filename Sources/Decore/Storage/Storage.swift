import os
/// Storage for ``Container``s.
/// Each time the value is read from the storage, it builds a dependency graph.
/// When value of one ``Container`` changes, storage enumerates through all dependencies
/// and these will recalculate their value calling the ``Container/value()`` function.
public final class Storage {

    /// A unique key for the container.
    public enum Key: Hashable {
        case container(AnyHashable)
        case group(AnyHashable)
        case groupItem(AnyHashable, id: AnyHashable)
    }

    /// Raw storage with all the ``Container``s
    var storage: [Key: Any] = [:]

    /// TBD
    var dependencies: [Key: [Key]] = [:]

    /// Raw storage with all the ``Observation``s
    var observations: [Storage.Key: ObservationStorage] = [:]

    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: Observation, for container: Key, context: Context) {
        if let observationStorage = observations[container] {
            observationStorage.insert(observation)
            return
        }

        let observationStorage = ObservationStorage()
        observationStorage.insert(observation)
        observations[container] = observationStorage
    }

    func insertDependency(_ depender: Key, for key: Key) {
        var dependencies = self.dependencies[key] ?? []
        dependencies.append(depender)
        self.dependencies[key] = dependencies
    }


    /// Reads the value from storage.
    /// Uses `fallbackValue` in cases when value isn't in storage.
    /// if `shouldStoreFallbackValue` is `true` writes `fallbackValue` into storage
    /// Adds dependency of `depender` for key that is being read.
    /// - Returns: Value
    func readValue<Value>(
        at destination: Key,
        fallbackValue: () -> Value,
        context: Context,
        shouldStoreFallbackValue: Bool = true,
        depender: Key? = nil
    ) -> Value {
        let signpostName: StaticString = "Storage.read"
        let subsystem: String = "\(destination) | \(context)"
        os_signpost(.begin, log: .init(subsystem: subsystem, category: .pointsOfInterest), name: signpostName)
        defer {
            os_signpost(.end, log: .init(subsystem: subsystem, category: .pointsOfInterest), name: signpostName)
        }
        if let depender = depender {
            insertDependency(depender, for: destination)
        }
        guard let value = storage[destination] as? Value
        else {
            let newValue = fallbackValue()
            if shouldStoreFallbackValue {
                update(value: newValue, atKey: destination)
            }
            return newValue
        }
        return value
    }

    public func update(value: Any, atKey destination: Key) {
        let signpostName: StaticString = "Storage.update"
        os_signpost(.begin, log: .init(subsystem: "\(destination)", category: .pointsOfInterest), name: signpostName)
        defer {
            os_signpost(.end, log: .init(subsystem: "\(destination)", category: .pointsOfInterest), name: signpostName)
        }
        willChangeValue(destination)
        invalidateValue(at: destination)
        storage[destination] = value
        didChangeValue(destination)
    }

    private func invalidateValue(at key: Storage.Key) {
        storage.removeValue(forKey: key)
        for depender in dependencies[key] ?? [] {
            storage.removeValue(forKey: depender)
        }
    }

    private func willChangeValue(_ destination: Key) {
        let signpostName: StaticString = "Storage.willChangeValue"
        os_signpost(.begin, log: .init(subsystem: "\(destination)", category: .pointsOfInterest), name: signpostName)
        defer {
            os_signpost(.end, log: .init(subsystem: "\(destination)", category: .pointsOfInterest), name: signpostName)
        }

        os_signpost(.event, log: .init(subsystem: "\(destination)", category: .pointsOfInterest), name: signpostName)
        observations[destination]?.willChangeValue()
        
        for dependency in dependencies[destination] ?? [] {
            os_signpost(.event, log: .init(subsystem: "\(dependency)", category: .pointsOfInterest), name: signpostName)
            observations[dependency]?.willChangeValue()
        }
        invalidateValue(at: destination)
    }

    private func didChangeValue(_ destination: Key) {
        observations[destination]?.didChangeValue()
    }
}


extension Storage.Key: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .container(let name): return "\(name)"
        case .group(let name): return "\(name)"
        case .groupItem(let name, let id): return "\(name) | at id: \(id)"
        }
    }
}
