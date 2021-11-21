
#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Notifies the view when value changed.
/// Provides one-way read access to the the value at given ``Container`` type.
/// Uses the storage assigned to the consumer from the ``Environment``
/// or default storage otherwise.
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

    @ObservedObject var observation: ContainerObservation

    let binding: Bind<Value>

    public var wrappedValue: Value {
        get {
            binding.wrappedValue            
        }
    }

    public init<C: Container>(_ container: C.Type) where C.Value == Value {
        let binding = Bind(container)
        observation = binding.observation
        self.binding = binding
    }

    public init<C: Computation>(_ computation: C.Type) where C.Value == Value {
        let binding = Bind(computation)
        observation = binding.observation
        self.binding = binding
    }

}


#endif
