//
//  Atom.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Bind {

    /// Binding to the ``Atom`` value
    public init<A: Atom>(
        _ container: A.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line,
        column: Int = #column, function: String = #function
    )
    where A.Value == Value
    {
        self.context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        key = container.key()
        fallbackValue = container.initialValue
        depender = nil
        shouldPreserveFallbackValue = true
    }
}
