//
//  Testability.swift
//  Decore
//
//  Created by Maxim Bazarov on 15.02.22.
//

import Decore

public extension BindGroup {

    /// BindGroup with preset storage
    init(
        _ state: State,
        storage: Storage,
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        self.init(state, file: file, fileID: fileID, line: line, column: column, function: function)
        self.storage = storage
    }
}


