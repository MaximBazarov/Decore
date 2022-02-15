//
//  Storage+Writer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage {
    
    final class Writer {
        
        let context: Context
        let storage: Storage
        
        public init(context: Context, storage: Storage) {
            self.context = context
            self.storage = storage
        }
    }
}
