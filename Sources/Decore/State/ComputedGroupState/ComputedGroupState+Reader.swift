//
//  ComputedGroupState+Reader.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage.Reader {

    /// Reads the value of the provided ``ComputedGroupState``.
    ///
    /// **Usage:**
    /// ```swift
    /// let value = read(SomeComputedState.self, at: id)
    /// ```
    ///
    func callAsFunction<CG: ComputedGroupState>(_ state: CG.Type, at id: CG.ID) -> CG.Element {
        return self(state.key(), fallbackValue: { state.value(at: id, read: self) })
    }

}
