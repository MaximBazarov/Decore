//
//  Storage.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

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
        case observersGroup(AnyHashable, id: AnyHashable)
    }

    public init() {}

    /// Values in storage
    var values: [Key: Any] = [:]

    /// TBD
    var dependencies: [Key: Set<Key>] = [:]

    /// Observers
    var observers: [String: Any] = [:]

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
        readerContext: Context,
        fallbackValue: () -> Value,
        persistFallbackValue: Bool
    ) -> Value {

        if transaction == nil {
            let transaction = Transaction(self, context: readerContext)
            self.transaction = transaction
            let value = transaction.readValue(
                at: destination,
                readerKey: readerContext.key,
                fallbackValue: fallbackValue)
            merge(transaction: transaction)
            return value
        } else {
            let transaction = self.transaction!
            let value = transaction.readValue(
                at: destination,
                readerKey: readerContext.key,
                fallbackValue: fallbackValue)
            return value
        }
   }

    internal func insertObservation(
        _ observation: StorageObservation,
        for key: Key,
        context: Context
    ) {
        if let transaction = transaction {
            transaction.insertObservation(observation, for: key)
        } else {
            let newObservations = observations[key, default: Storage.ObservationStorage()]
            newObservations.insert(observation)
            observations[key] = newObservations
        }
    }

    // MARK: - Transaction Integration -
    private func merge(transaction: Transaction) {
        print("Merging transaction: \(transaction)")
        mergeDependencies(of: transaction, into: self)

        let updatedKeys = Set(transaction.values.keys)
        // Reduce to unique values
        let observationsToNotify: [StorageObservation] = updatedKeys
            .reduce(into: [:], { partialResult, key in
                observations(of: key).forEach { observation in
                    guard observation.id != transaction.context.observationID else { return }
                    partialResult[observation.id] = observation
                }
            })
            .values.map{ $0 }

        print("Notifying observations: \(observationsToNotify)")
        notifyWillChangeValue(observationsToNotify)

        mergeValues(of: transaction, into: self)

        notifyDidChangeValue(observationsToNotify)

        mergeObservations(of: transaction, into: self)
        self.transaction = nil
    }

    func mergeValues(of transaction: Transaction, into storage: Storage) {
        transaction.values.forEach { key, value in
            storage.values[key] = value
        }
    }

    func mergeObservations(of transaction: Transaction, into storage: Storage) {
        transaction.observationsOf.forEach { key, value in
            observations[key] = value
        }
    }

    // MARK: - Observations -

    func observations(of keys: Set<Key>) -> [StorageObservation] {
        keys.flatMap { observations(of: $0) }
    }

    func observations(of key: Key) -> [StorageObservation] {
        return observations[key]?.observations.values.map{ $0 } ?? []
    }

    func mergeDependencies(of transaction: Transaction, into storage: Storage) {
        transaction.dependenciesOf.forEach { key, dependents in
            dependents.forEach { depender in
                dependencies[key, default: []].insert(depender)
            }
        }
    }

    // MARK: Observation Notifications

    private func notifyWillChangeValue(_ observations: [StorageObservation]) {
        observations.forEach { observation in
            observation.willChangeValue()
        }
    }

    private func notifyDidChangeValue(_ observations: [StorageObservation]) {
        observations.forEach { observation in
            observation.didChangeValue()
        }
    }


    // MARK: - Write -

    internal func write(value: Any, atKey destination: Key, context: Context) {
        invalidateValueDependencies(at: destination)
        values[destination] = value
        if transaction == nil {
            let transaction = Transaction(self, context: context)
            self.transaction = transaction
            transaction.writeValue(value: value, at: destination, context: context)
            merge(transaction: transaction)
        } else {
            let transaction = self.transaction!
            transaction.writeValue(value: value, at: destination, context: context)
        }

    }

    private func invalidateValueDependencies(at key: Storage.Key) {
        for depender in dependencies[key] ?? [] {
            values.removeValue(forKey: depender)
            print("removed key: \(depender)")
        }
    }

}


extension Storage.Key: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .container(let name): return "\(name)"
        case .group(let name): return "\(name)"
        case .groupItem(let name, let id): return "\(name) | at id: \(id)"
        case .observersGroup(let name, let id): return "\(name) | at id: \(id)"
        }
    }
}
