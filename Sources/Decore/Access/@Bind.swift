//
//  @Bind.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Provides a **two-way** access to the value of a given container.
/// When declared inside the `SwiftUI.View` or ``Consumer`` notifies these
/// about the Containers' value change.
///
/// **Usage:**
/// ```swift
/// struct TestView: View {
///
///     @Bind(NameAtom.self) var name
///
///     var body: some View {
///         TextField($name)
///     }
/// }
/// ```
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
@propertyWrapper
public struct Bind<Value>: DynamicProperty {

    @ObservedObject var observation = ObservableStorageObject()
    @StorageFor(Self.self) var observationStorage

    internal let key: Storage.Key
    internal let depender: Storage.Key?
    internal let fallbackValue: () -> Value
    internal let shouldPreserveFallbackValue: Bool
    internal let context: Context

    public var wrappedValue: Value {
        get {
            observationStorage.insertObservation(observation, for: key, context: context)
            return observationStorage.readValue(
                at: key,
                fallbackValue: fallbackValue,
                context: context,
                shouldStoreFallbackValue: shouldPreserveFallbackValue,
                depender: depender
            )
        }
        nonmutating set {
            observationStorage.update(value: newValue, atKey: key)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    /// Binding to ``ComputedAtom``
    public init<WrappedContainer: ComputedAtom>(
        _ computation: WrappedContainer.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        self.context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        key = computation.key()
        depender = computation.key()
        let reader = Storage.Reader(context: context, owner: depender)
        fallbackValue = { computation.value(read: reader) }
        shouldPreserveFallbackValue = true
    }

    /// Binding to ``AtomGroup``
    public init<WrappedContainer: AtomGroup>(
        _ wrapped: WrappedContainer.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        self.context = context
        key = wrapped.key()
        depender = nil
        shouldPreserveFallbackValue = true
        fallbackValue = { wrapped.initialValue(context: context) }
    }

}

#endif
