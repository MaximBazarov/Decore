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

/// Provides a **two-way** access to the value of a given state type.
///
/// When declared inside the `SwiftUI.View` acts as `@Binding`
/// updating the view when value changed.
///
/// When used inside a ``Consumer`` calls ``Consumer/onUpdate()``
/// when value changes. Read ``Consumer`` documentation for more details.
///
/// When used inside other classes, structure or functions
/// acts as a normal variable providing access to the value.
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

    internal let key: Storage.Key
    internal let depender: Storage.Key?
    internal let fallbackValue: () -> Value
    internal let shouldPreserveFallbackValue: Bool
    internal let context: Context
    internal let storage: Storage

    public var wrappedValue: Value {
        get {
            storage.insertObservation(observation, for: key, context: context)
            return storage.readValue(
                at: key,
                fallbackValue: fallbackValue,
                context: context,
                shouldStoreFallbackValue: shouldPreserveFallbackValue,
                depender: depender
            )
        }
        nonmutating set {
            storage.write(value: newValue, atKey: key)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

}

#endif
