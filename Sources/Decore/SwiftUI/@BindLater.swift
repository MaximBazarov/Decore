
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
//@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
//@propertyWrapper
//public struct BindLater<CG: ContainerGroup>: DynamicProperty {
//
//    @ObservedObject var containerObserver: ObservableContainer<CG.Value>
//
//    public var wrappedValue: GroupBinder<CG> {
//        get { containerObserver.value }
//        nonmutating set { containerObserver.value = newValue }
//    }
//
//    public var projectedValue: Binding<Value> {
//        Binding(
//            get: { wrappedValue },
//            set: { wrappedValue = $0 }
//        )
//    }
//
//    public init(_ group: CG.Type) {
//        containerObserver = ObservableContainer<CG.Value>(
//            key: group.key(for: id),
//            fallbackValue: {
//                container.initialValue()
//            }
//        )
//    }
//}
//
//class GroupBinder<CG: ContainerGroup> {
//
//}

#endif
