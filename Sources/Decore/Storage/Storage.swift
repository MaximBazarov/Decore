/// Storage for ``Container``s.
/// Each time the value is read from the storage, it builds a dependency graph.
/// When value of one ``Container`` changes, storage enumerates through all dependencies
/// and these will recalculate their value calling the ``Container/value()`` function.
public final class Storage {


    // MARK: - Public Interface

    /// A unique key for the container.
    public enum Key: Hashable {
        case container(AnyHashable)
        case group(AnyHashable, container: AnyHashable)
    }

    // MARK: Write

    public func write<C: Container>(
        _ value: C.Value,
        into container: C.Type
    ) {
        let destination = C.key()
        update(container, value: value, key: destination)
    }

    public func write<C: ContainerGroup>(
        _ value: C.Value,
        into containerGroup: C.Type,
        at id: C.ID
    ) {
        let destination = C.key(id)
        update(containerGroup, value: value, key: destination)
    }

    // MARK: Observe

    func observe<C: Container>(
        container: C.Type,
        observation: Observation
    ) -> C.Value {
        let destination = C.key()
        insertObservation(observation, for: destination)
        let value = readValue(of: container, key: destination, initial: C.value)
        return value
    }

    // MARK: - Storage

    /// Raw storage with all the ``Container``s
    var storage: [AnyHashable: Any] = [:]

    /// Raw storage with all the ``Observation``s
    var observations: [Storage.Key: ObservationStorage] = [:]


    // MARK: - Read


    // MARK: - Observe


    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: Observation, for container: Key) {
        if let observationStorage = observations[container] {
            observationStorage.insert(observation)
        }

        let observationStorage = ObservationStorage()
        observationStorage.insert(observation)
        observations[container] = observationStorage
    }



    // MARK: - Write

    private func update<C: Container>(
        _ container: C.Type,
        value: C.Value,
        key destination: Key
    ) {
        willChangeValue(destination)
        invalidateValue(at: destination)
        if shouldWriteValue(of: container) {
            storage[destination] = value
        }
        didChangeValue(destination)
    }

    private func readValue<C: Container>(
        of container: C.Type,
        key destination: Key,
        initial: () -> C.Value
    ) -> C.Value {
        if let value = storage[destination] as? C.Value {
            return value
        }

        let newValue = initial()
        update(container, value: newValue, key: destination)
        return newValue
    }

    private func shouldWriteValue<C: Container>(of container: C.Type) -> Bool {
        if let computation = container.self as? ComputationConfiguration.Type {
            return computation.shouldStoreComputedValue()
        }
        return true
    }

    private func invalidateValue(at key: Storage.Key) {

    }

    private func willChangeValue(_ destination: Key) {
        observations[destination]?.willChangeValue()
        storage.removeValue(forKey: destination)
    }

    private func didChangeValue(_ destination: Key) {
        observations[destination]?.didChangeValue()
        storage.removeValue(forKey: destination)
    }
}
