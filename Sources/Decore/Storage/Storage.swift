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
    var storage: [AnyHashable: Any] = [:]

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

    func update<C: ValueContainer>(
        _ container: C.Type,
        value: C.Value,
        atKey destination: Key
    ) {
        willChangeValue(destination)
        invalidateValue(at: destination)
        if shouldWriteValue(of: container) {
            storage[destination] = value
        }
        didChangeValue(destination)
    }

    private func shouldWriteValue<C: ValueContainer>(of container: C.Type) -> Bool {
        if let computation = container.self as? ComputationConfiguration.Type {
            return computation.shouldStoreComputedValue()
        }
        return true
    }

    private func invalidateValue(at key: Storage.Key) {
        storage.removeValue(forKey: key)
    }

    private func willChangeValue(_ destination: Key) {
        observations[destination]?.willChangeValue()
        invalidateValue(at: destination)
    }

    private func didChangeValue(_ destination: Key) {
        observations[destination]?.didChangeValue()
    }
}
