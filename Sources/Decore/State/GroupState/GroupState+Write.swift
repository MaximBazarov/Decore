//  
//  GroupState+Write.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

public extension Storage.Writer {

    /// Writes the given value into the provided ``GroupState``
    /// at given ``GroupState/ID``.
    ///
    /// **Usage:**
    /// ```swift
    /// write("hello", into: SomeState.self, at: id)
    /// ```
    ///
    func callAsFunction<G: GroupState>(_ value: G.Element, into state: G.Type, at id: G.ID) {
        return self(value, into: state.key(for: id))
    }

}
