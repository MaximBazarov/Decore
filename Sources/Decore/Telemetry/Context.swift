//
//  Context.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

import Foundation

/// Describe the place in the code.
public struct Context {

    /// If not nil context key will be used to add as a depender of read values
    let key: Storage.Key?

    /// if not nil observation of read target key (not necessarily self.key)
    /// will be added into storage
    let observationID: StorageObservation.ID?

    let file: String
    let fileID: String
    let line: Int
    let column: Int
    let function: String

    internal init(key: Storage.Key?, observationID: ObjectIdentifier?, file: String, fileID: String, line: Int, column: Int, function: String) {
        self.key = key
        self.observationID = observationID
        self.file = file
        self.fileID = fileID
        self.line = line
        self.column = column
        self.function = function
    }

    public static func here(file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function) -> Context {
        Self.init(
            key: nil,
            observationID: nil,
            file: file,
            fileID: fileID,
            line: line,
            column: column,
            function: function
        )
    }

    func appending(observationID: StorageObservation.ID) -> Context {
        return Context(
            key: self.key,
            observationID: observationID,
            file: self.file,
            fileID: self.fileID,
            line: self.line,
            column: self.column,
            function: self.function
        )
    }

    public func appending(key: Storage.Key) -> Context {
        return Context(
            key: key,
            observationID: self.observationID,
            file: self.file,
            fileID: self.fileID,
            line: self.line,
            column: self.column,
            function: self.function
        )
    }
}

extension Context: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(fileID), L\(line):C\(column) | \(function)"
    }
}
