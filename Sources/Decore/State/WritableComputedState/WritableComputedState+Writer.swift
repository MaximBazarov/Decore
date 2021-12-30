//
//  WritableComputedState+Writer.swift
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
    func callAsFunction<WCS: WritableComputedState>(_ value: WCS.Value, into container: WCS.Type) {
        let reader = Storage.Reader(context: context, storage: storage, owner: owner)
        return WCS.setValue(value, read: reader, write: self)
    }

}
