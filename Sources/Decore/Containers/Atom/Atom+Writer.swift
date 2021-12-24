//
//  Atom.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

public extension Storage.Writer {

    /// Writes the given value into the given ``Atom``'s storage.
    func callAsFunction<C: Atom>(_ value: C.Value, into container: C.Type) {
        return self(value, into: container.key())
    }

}
