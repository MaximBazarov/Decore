
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

    var observationStorage: Storage {
        Warehouse.storage(for: Self.self)
    }

    public var wrappedValue: Value {
        get {
            observationStorage.insertObservation(observation, for: key)
            return observationStorage.readValue(
                at: key,
                fallbackValue: fallbackValue,
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

    public init<WrappedContainer: Container>(_ container: WrappedContainer.Type)
    where WrappedContainer.Value == Value
    {
        key = container.key()
        fallbackValue = container.initialValue
        depender = nil
        shouldPreserveFallbackValue = true
    }

    public init<WrappedContainer: Computation>(_ computation: WrappedContainer.Type)
    where WrappedContainer.Value == Value
    {
        key = computation.key()
        depender = computation.key()
        let reader = Storage.Reader(owner: depender)
        fallbackValue = { computation.value(read: reader) }
        shouldPreserveFallbackValue = true
    }

    public init<WrappedContainer: GroupContainer>(_ wrapped: WrappedContainer.Type)
    where WrappedContainer.Value == Value
    {
        key = wrapped.key()
        depender = nil
        shouldPreserveFallbackValue = true
        fallbackValue = { wrapped.initialValue() }
    }

}

#endif
