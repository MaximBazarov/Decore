//
//  ComputedState+Bind.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Bind {

    /// Initializes ``Bind`` for a ``ComputedState``.
    init<C: ComputedState>(
        _ state: C.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where C.Value == Value
    {
        self.context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        key = state.key()
        depender = state.key()
        self.storage = storage ?? StorageFor(Self.self).wrappedValue
        let reader = Storage.Reader(
            context: context,
            storage: self.storage,
            owner: depender
        )
        fallbackValue = { state.value(read: reader) }
        shouldPreserveFallbackValue = true
    }
}
