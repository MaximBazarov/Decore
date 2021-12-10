//
//  Storage+Writer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage {
    
    struct Writer {
        
        let owner: Storage.Key?
        let context: Context
        
        var storage: Storage
        
        public init(context: Context, storage: Storage? = nil, owner: Storage.Key? = nil) {
            self.context = context
            self.owner = owner
            self.storage = storage ?? Warehouse.storage(for: Self.self)
        }
        
        func callAsFunction<V>(_ key: Storage.Key, fallbackValue: () -> V) -> V {
            fatalError()
        }
        
    }
}
