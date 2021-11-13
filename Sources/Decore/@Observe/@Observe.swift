
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
public struct Observe<C: Container>: DynamicProperty {

    @ObservedObject private var container: ContainerObserver<C>

    public var wrappedValue: C.Value {
        get { readFromStorage() }
    }

    private var readFromStorage: () -> C.Value = { fatalError() }

    public init(_ container: C.Type) {
        self.container = ContainerObserver()
    }

}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
private final class ContainerObserver<C: Container>: Observation, ObservableObject {

    let objectWillChange = ObservableObjectPublisher()

    var wrappedValue: C.Value { // we need to move it to incapsulate in the atom definition
        get {
            let storage = Warehouse[.defaultStorage]
            return storage.observe(container: C.self, observation: self)
        }
        set {
            let storage = Warehouse[.defaultStorage]
            storage.write(newValue, into: C.self)
        }
    }

    override func willChangeValue() {
        objectWillChange.send()
        super.willChangeValue()
    }
}

#endif
