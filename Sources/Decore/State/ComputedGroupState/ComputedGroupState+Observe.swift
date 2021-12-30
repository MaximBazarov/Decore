//
//  ComputedGroupState+Observe.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Observe {

    /// Initializes ``Observe`` for a ``ComputedGroupState``.
    public init<CG: ComputedGroupState>(
        _ state: CG.Type,
        storage: Storage? = nil,
        /** Context **/
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    )
    where CG.Value == Value
    {

        let context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        self.context = context
        key = state.key()
        depender = state.key()
        shouldPreserveFallbackValue = CG.shouldStoreComputedValue()
        let storage = storage ?? StorageFor(Self.self).wrappedValue
        fallbackValue = { state.initialValue(context: context, in: storage) }
        self.storage = storage
    }
}
