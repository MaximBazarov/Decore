//
//  Storage.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

import Darwin

/// **TBD**: Storage for ``AtomicState``s.
/// Each time the value is read from the storage, it builds a dependency graph.
/// When value of one ``AtomicState`` changes, storage enumerates through all dependencies
/// and these will recalculate their value calling the ``AtomicState/initialValue()`` function.
public final class Storage {

    /// A unique key for the container.
    public enum Key: Hashable {
        case container(AnyHashable)
        case group(AnyHashable)
        case groupItem(AnyHashable, id: AnyHashable)
    }

    public init() {}

    /// Values in storage
    var values: [Key: Any] = [:]

    /// TBD
    var dependencies: [Key: Set<Key>] = [:]

    /// Raw storage with all the ``Observation``s
    var observations: [Storage.Key: ObservationStorage] = [:]

    var transaction: Transaction?

    let transactionStarted = Telemetry.SensitiveEvent("transaction-started")
    let transactionFinished = Telemetry.SensitiveEvent("transaction-finished")
    
    /// Reads the value from storage.
    /// Uses `fallbackValue` in cases when value isn't in storage.
    /// if `shouldStoreFallbackValue` is `true` writes `fallbackValue` into storage
    /// Adds dependency of `depender` for key that is being read.
    /// - Returns: Value
    internal func readValue<Value>(
        at destination: Key,
        fallbackValue: () -> Value,
        context: Context,
        shouldStoreFallbackValue: Bool = true,
        depender: Key? = nil
    ) -> Value {
        if let transaction = transaction {
            return transaction.readValue(
                at: destination,
                fallbackValue: fallbackValue,
                depender: depender)
        }
        else {
            let transaction = Transaction(self)
            self.transaction = transaction
            let value = transaction.readValue(
                at: destination,
                fallbackValue: fallbackValue)
            mergeValues(of: transaction, into: self)
            mergeDependencies(of: transaction, into: self)
            var updatedKeys = Set(transaction.values.keys)
            if let depender = depender { updatedKeys.remove(depender) }
//            notify(updatedKeys)
            self.transaction = nil
            return value
        }

   }

    func mergeValues(of transaction: Transaction, into storage: Storage) {
        transaction.values.forEach { key, value in
            storage.values[key] = value
        }
    }

    // MARK: - Observations -

    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: StorageObservation, for container: Key, context: Context) {
        observations[container, default: ObservationStorage()].insert(observation)
    }

    func observations(of keys: Set<Key>) -> Set<ObjectIdentifier> {
        var result = Set<ObjectIdentifier>()
        keys.forEach { key in
            observations(of: key).forEach {
                result.insert($0)
            }
        }
        return result
    }

    func observations(of key: Key) -> Set<ObjectIdentifier> {
        guard let observationStorage = observations[key] else { return [] }
        return observationStorage.observations.valid
    }

    func mergeDependencies(of transaction: Transaction, into storage: Storage) {
        transaction.dependenciesOf.forEach { key, dependents in
            dependents.forEach { depender in
                dependencies[key, default: []].insert(depender)
            }
        }
    }

    func notify(observations: Set<StorageObservation>)

    // MARK: - Write -

    internal func write(value: Any, atKey destination: Key) {
        willChangeValue(destination)
        invalidateValueDependencies(at: destination)
        values[destination] = value
        didChangeValue(destination)
    }

    private func invalidateValueDependencies(at key: Storage.Key) {
        for depender in dependencies[key] ?? [] {
            values.removeValue(forKey: depender)
        }
    }

    private func willChangeValue(_ destination: Key) {
        observations[destination]?.willChangeValue()
        for dependency in dependencies[destination] ?? [] {
            observations[dependency]?.willChangeValue()
        }
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
