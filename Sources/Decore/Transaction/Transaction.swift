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

    internal var values: [Key: Any] = [:]
    internal var dependenciesOf: [Key: Set<Key>] = [:]

    internal func readValue<Value>(
        at destination: Key,
        fallbackValue: () -> Value,
        depender: Key? = nil
    ) -> Value {
        let value: Value = {
            if let local = values[destination] as? Value { return local }
            if let global = storage?.values[destination] as? Value { return global }
            return fallbackValue()
        }()
        insertDependency(depender, for: destination)
        return value
    }

    init(_ storage: Storage) {
        self.storage = storage
    }

    func insertDependency(_ depender: Key?, for key: Key) {
        guard let depender = depender else { return }
        dependenciesOf[key, default: []].insert(depender)
    }
}
