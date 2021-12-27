//
//  AtomicState.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage.Writer {

    /// Writes the given value into the given ``AtomicState``'s storage.
    func callAsFunction<C: AtomicState>(_ value: C.Value, into container: C.Type) {
        return self(value, into: container.key())
    }

}
