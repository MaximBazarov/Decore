
#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Notifies the view when value changed.
/// Provides two-way access to the the value at given ``ValueContainer`` type.
/// Uses the storage assigned to the consumer from the ``Environment``
/// or default storage otherwise.
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

    @ObservedObject var observation = ContainerObservation()

    let key: Storage.Key
    let depender: Storage.Key?
    let fallbackValue: () -> Value
    let shouldPreserveFallbackValue: Bool

    var storage: Storage {
        Warehouse.storage(for: Self.self)
    }

    public var wrappedValue: Value {
        get {
            storage.insertObservation(observation, for: key)
            return storage.readValue(
                at: key,
                fallbackValue: fallbackValue,
                shouldStoreFallbackValue: shouldPreserveFallbackValue,
                depender: depender
            )
        }
        nonmutating set {
            storage.update(value: newValue, atKey: key)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public init<C: Container>(_ container: C.Type) where C.Value == Value {
        key = container.key()
        fallbackValue = container.initialValue
        depender = nil
        shouldPreserveFallbackValue = true
    }

    public init<C: Computation>(_ computation: C.Type) where C.Value == Value {
        key = computation.key()
        depender = computation.key()
        let reader = Storage.Reader(owner: depender)
        fallbackValue = { computation.value(read: reader) }
        shouldPreserveFallbackValue = true
    }

}

#endif
