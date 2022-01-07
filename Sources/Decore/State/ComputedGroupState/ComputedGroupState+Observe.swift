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
        let context = Context(
            key: nil,
            observationID: nil, // doesn't exist yet
            file: file,
            fileID: fileID,
            line: line,
            column: column,
            function: function)

        let storage = storage ?? StorageFor(Self.self).wrappedValue

        self.init(
            key: state.key(),
            context: context,
            fallbackValue: { state.initialValue(context: context, in: storage) },
            shouldPreserveFallbackValue: CG.shouldStoreComputedValue(),
            storage: storage)
    }
}
