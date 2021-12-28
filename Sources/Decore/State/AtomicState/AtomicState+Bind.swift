//
//  AtomicState+Bind.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Bind {

    /// Initializes ``Bind`` for an ``AtomicState``.
    public init<A: AtomicState>(
        _ state: A.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line,
        column: Int = #column, function: String = #function
    )
    where A.Value == Value
    {
        self.context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        key = state.key()
        fallbackValue = state.initialValue
        depender = nil
        shouldPreserveFallbackValue = true
        self.storage = storage ?? StorageFor(Self.self).wrappedValue
    }
}
