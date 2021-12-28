//
//  ComputedState+Writer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage.Writer {

    /// Writes the given value into the provided ``ComputedState``.
    ///
    /// **Usage:**
    /// ```swift
    /// write("hello", into: SomeState.self)
    /// ```
    ///
    func callAsFunction<C: ComputedState>(_ value: C.Value, into state: C.Type) {
        return self(value, into: state.key())
    }
}
