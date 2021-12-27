//
//  ComputedAtom.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// ComputedAtom is the ``AtomicState`` that calculates a value
/// depending on the other values in the storage that ``ComputedAtom`` reads during computation.
/// if ``ComputedAtom/shouldStoreComputedValue()-2c6d5`` returns true,
/// the computed value will be written into the ``Storage``.
/// By default it returns `true`.
///
/// **Usage:**
/// TBD
public protocol ComputedAtom: ValueContainer, KeyedContainer {

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool

    /// Called when when computation value is read
    /// and there is no valid value in the ``Storage``.
    ///
    /// `shouldStoreComputedValue()`: Defines whether a computed value
    /// should be written into the ``Storage``
    ///
    /// - Returns: ``Value``
    static func value(read: Storage.Reader) -> Value

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}


// MARK: - Key Default Implementation

public extension ComputedAtom {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``AtomicState`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}

public extension ComputedAtom {
    static func shouldStoreComputedValue() -> Bool { true }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Bind {
    /// Binding to ``ComputedAtom``
    init<WrappedContainer: ComputedAtom>(
        _ computation: WrappedContainer.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        self.context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        key = computation.key()
        depender = computation.key()
        self.storage = storage ?? StorageFor(Self.self).wrappedValue
        let reader = Storage.Reader(
            context: context,
            storage: self.storage,
            owner: depender
        )
        fallbackValue = { computation.value(read: reader) }
        shouldPreserveFallbackValue = true
    }
}
