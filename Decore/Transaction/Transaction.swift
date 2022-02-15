//  
//  Transaction.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

import Foundation

internal class Transaction {

    typealias Key = Storage.Key

    weak var storage: Storage?
    let context: Context

    var values: [Key: Any] = [:]
    var dependenciesOf: [Key: Set<Key>] = [:]
    var observationsOf: [Key: Storage.ObservationStorage] = [:]

    func readValue<Value>(
        at destinationKey: Key,
        readerKey: Key?,
        fallbackValue: () -> Value
    ) -> Value {
        let value: Value = {
            // Transaction
            if values.keys.contains(destinationKey),
               let local = values[destinationKey] as? Value
            {
                return local
            }

            // Storage
            if let storage = storage,
               storage.values.keys.contains(destinationKey),
               let global = storage.values[destinationKey] as? Value
            {
                return global
            }

            // Initial value
            let value = fallbackValue()
            values[destinationKey] = value
            return value
        }()

        insertDependency(readerKey, for: destinationKey)
        return value
    }

    func writeValue<Value>(
        value: Value,
        at destinationKey: Key,
        context: Context
    ) {
        invalidateDependencies(of: destinationKey)
        values[destinationKey] = value

    }

    init(_ storage: Storage, context: Context) {
        print("[TRANSACTION] started from \(context)")
        self.storage = storage
        self.context = context
    }

    deinit {
        print("[TRANSACTION] from \(context) finished")
    }

    func insertDependency(_ depender: Key?, for key: Key) {
        guard let depender = depender else { return }
        dependenciesOf[key, default: []].insert(depender)
        print("\(depender) depends on \(key)")
    }

    func invalidateDependencies(of key: Key) {
        values.removeValue(forKey: key)
        print("[TRANSACTION] Removed value for key: \(key)")
        for depender in dependenciesOf[key] ?? [] {
            values.removeValue(forKey: depender)
            print("[TRANSACTION] Removed value for key: \(depender)")
        }
    }

    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: StorageObservation, for container: Key) {
        let observations = observationsOf[container, default: Storage.ObservationStorage()]
        observations.insert(observation)
        observationsOf[container] = observations
    }
}
