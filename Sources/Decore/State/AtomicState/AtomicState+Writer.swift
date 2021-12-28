//
//  AtomicState+Writer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage.Writer {

    /// Writes the given value into the provided ``AtomicState``.
    ///
    /// **Usage:**
    /// ```swift
    /// write("hello", into: SomeState.self)
    /// ```
    ///
    func callAsFunction<C: AtomicState>(_ value: C.Value, into container: C.Type) {
        return self(value, into: container.key())
    }
}
