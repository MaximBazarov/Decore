
#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Notifies the view when value changed.
/// Provides one-way read access to the the value at given ``Container`` type.
/// Reads the storage assigned to the consumer from ``Environment``.
///
/// **Usage:**
/// ```swift
/// struct TestView: View {
///
///     @Observe(NameAtom.self) var name
///
///     var body: some View {
///         Text(name)
///     }
/// }
/// ```
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
@propertyWrapper
public struct Observe<Value>: DynamicProperty {

    @ObservedObject var containerObserver: ContainerObserver<Value>

    public var wrappedValue: Value {
        get { containerObserver.value }
    }

    init<C: Container>(_ container: C.Type) where C.Value == Value {
        containerObserver = ContainerObserver<Value>(
            key: container.key(),
            fallbackValue: {
                container.initialValue()
            }
        )
    }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
@propertyWrapper
public struct Bind<Value>: DynamicProperty {

    @ObservedObject var containerObserver: ContainerObserver<Value>

    public var wrappedValue: Value {
        get { containerObserver.value }
        nonmutating set { containerObserver.value = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public init<C: Container>(_ container: C.Type) where C.Value == Value {
        containerObserver = ContainerObserver<Value>(
            key: container.key(),
            fallbackValue: {
                container.initialValue()
            }
        )
    }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ContainerObserver<Value>: Observation, ObservableObject {

    internal init(key: Storage.Key, fallbackValue: @escaping () -> Value) {
        self.key = key
        self.fallbackValue = fallbackValue
    }

    let key: Storage.Key
    let fallbackValue: () -> Value

    var value: Value {
        get {
            let storage = Warehouse[.defaultStorage]
            let read = Storage.Reader(storage: storage)
            storage.insertObservation(self, for: key)
            return read(key, fallbackValue: fallbackValue)            
        }
        set {
            let storage = Warehouse[.defaultStorage]
            storage.update(value: newValue, atKey: key)
        }
    }

    let objectWillChange = ObservableObjectPublisher()

    override func willChangeValue() {
        objectWillChange.send()
        super.willChangeValue()
    }
}


#endif
