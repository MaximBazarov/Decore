//  
//  GroupState+Read.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

public extension Storage.Reader {

    /// Reads the value of the provided ``GroupState`` at given ``GroupState/ID``.
    ///
    /// **Usage:**
    /// ```swift
    /// let greetings = read(SomeState.self, at: id)
    /// ```
    ///
    func callAsFunction<G: GroupState>(_ state: G.Type, at id: G.ID) -> G.Element {
        return self(state.key(for: id), fallbackValue: { state.initialValue(for: id) } )
    }

}

