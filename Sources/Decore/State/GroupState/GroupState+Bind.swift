//  
//  GroupState+Bind.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Bind {

    /// Initializes ``Bind`` for a ``GroupState``.
    init<G: GroupState>(
        _ state: G.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where G.Value == Value
    {
        let context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        self.context = context
        key = state.key()
        depender = nil
        shouldPreserveFallbackValue = true
        let storage = storage ?? StorageFor(Self.self).wrappedValue
        fallbackValue = { state.initialValue(context: context, in: storage) }
        self.storage = storage
    }

}
