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

    func readValue<Value>(
        at destinationKey: Key,
        readerKey: Key?,
        fallbackValue: () -> Value
    ) -> Value {
        let value: Value = {
            if let local = values[destinationKey] as? Value { return local }
            if let global = storage?.values[destinationKey] as? Value { return global }

            // Initial value
            let value = fallbackValue()
            values[destinationKey] = value
            return value
        }()
        insertDependency(readerKey, for: destinationKey)
        return value
    }

    init(_ storage: Storage, context: Context) {
        self.storage = storage
        self.context = context
    }

    func insertDependency(_ depender: Key?, for key: Key) {
        guard let depender = depender else { return }
        dependenciesOf[key, default: []].insert(depender)
    }
}
