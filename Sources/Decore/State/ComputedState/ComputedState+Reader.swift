//
//  ComputedState+Reader.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage.Reader {

    /// Reads the value of the provided ``ComputedState``.
    ///
    /// **Usage:**
    /// ```swift
    /// let value = read(SomeComputedState.self)
    /// ```
    ///
    func callAsFunction<C: ComputedState>(_ state: C.Type) -> C.Value {
        self.callAsFunction(
            state.key(),
            fallbackValue: { state.value(read: self) },
            preserveFallbackValue: C.shouldStoreComputedValue()
        )
    }

}
