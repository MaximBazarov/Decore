/// Storage for ``Container``s.
/// Each time the value is read from the storage, it builds a dependency graph.
/// When value of one ``Container`` changes, storage enumerates through all dependencies
/// and these will recalculate their value calling the ``Container/value()`` function.
public final class Storage {

    /// A unique key for the container.
    public enum Key: Hashable {
        case container(AnyHashable)
        case group(AnyHashable, container: AnyHashable)
    }

    /// Raw storage with all the ``Container``s
    var storage: [Key: Any] = [:]

    /// TBD
    var dependencies: [Key: [Key]] = [:]

    /// Raw storage with all the ``Observation``s
    var observations: [Storage.Key: ObservationStorage] = [:]

    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: Observation, for container: Key) {
        if let observationStorage = observations[container] {
            observationStorage.insert(observation)
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

    func readValue(at destination: Key) -> Any? {
        let value = storage[destination]
        return value
    }

    public func update(value: Any, atKey destination: Key) {
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
        observations[destination]?.willChangeValue()
        invalidateValue(at: destination)
    }

    private func didChangeValue(_ destination: Key) {
        observations[destination]?.didChangeValue()
    }
}
