//
//  WritableComputedGroupState+Writer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


public extension Storage.Writer {

    /// Writes the given value into the provided ``WritableComputedState``.
    ///
    /// **Usage:**
    /// ```swift
    /// write(10, into: SomeWritableComputedState.self)
    /// ```
    ///
    func callAsFunction<WCGS: WritableComputedGroupState>(_ value: WCGS.Element, into container: WCGS.Type, at id: WCGS.ID) {
        let reader = Storage.Reader(context: context, storage: storage, owner: owner)
        return WCGS.setValue(value, at: id, read: reader, write: self)
    }

}
