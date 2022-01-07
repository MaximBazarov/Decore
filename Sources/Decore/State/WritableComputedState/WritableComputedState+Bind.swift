//
//  WritableComputedState+Bind.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Bind {

    /// Initializes ``Bind`` for an ``WritableComputedState``.
    public init<WCS: WritableComputedState>(
        _ state: WCS.Type,
        storage: Storage? = nil,
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    )
    where WCS.Value == Value
    {
        let context = Context(
            key: state.key(),
            observationID: nil, // doesn't exist yet
            file: file,
            fileID: fileID,
            line: line,
            column: column,
            function: function)
        let storage = storage ?? StorageFor(Self.self).wrappedValue
        let reader = Storage.Reader(
            context: context,
            storage: storage)

        self.init(
            key: state.key(),
            context: context,
            fallbackValue: {
                state.value(read: reader)
            },
            shouldPreserveFallbackValue: WCS.shouldStoreComputedValue(),
            storage: storage)
    }
}
