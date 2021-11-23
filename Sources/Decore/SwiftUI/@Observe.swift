
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
public struct Observe<C: ValueContainer>: DynamicProperty {

    @ObservedObject var observation: ContainerObservation

    let binding: Bind<C>

    public var wrappedValue: C.Value {
        get {
            binding.wrappedValue            
        }
    }

    public init<WrappedContainer: Container>(_ container: WrappedContainer.Type)
    where WrappedContainer.Value == C.Value
    {
        let binding = Bind<C>(container)
        observation = binding.observation
        self.binding = binding
    }

    public init<WrappedContainer: Computation>(_ computation: WrappedContainer.Type)
    where WrappedContainer.Value == C.Value
    {
        let binding = Bind<C>(computation)
        observation = binding.observation
        self.binding = binding
    }

    public init<WrappedContainer: GroupContainer>(_ computation: WrappedContainer.Type)
    where WrappedContainer.Value == C.Value
    {
        let binding = Bind<C>(computation)
        observation = binding.observation
        self.binding = binding
    }

}


#endif
