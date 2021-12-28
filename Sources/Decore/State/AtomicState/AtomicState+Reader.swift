//
//  AtomicState+Reader.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage.Reader {

    /// Reads the value of the provided ``AtomicState``.
    ///
    /// **Usage:**
    /// ```swift
    /// let greetings = read(SomeState.self)
    /// ```
    ///
    func callAsFunction<C: AtomicState>(_ state: C.Type) -> C.Value {
        return self(state.key(), fallbackValue: state.initialValue)
    }

}
