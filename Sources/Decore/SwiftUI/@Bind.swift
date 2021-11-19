
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

    @ObservedObject var containerObserver: ObservableContainer<Value>

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
        containerObserver = ObservableContainer<Value>(
            key: container.key(),
            fallbackValue: {
                container.initialValue()
            }
        )
    }
}

public protocol MirrorSubscribe {
    func subscribe(_ callBack: @escaping () -> Void )
}

#endif
