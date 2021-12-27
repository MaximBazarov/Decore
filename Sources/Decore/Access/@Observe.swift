//
//  @Observe.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Provides a **read-only** access to the value of a given container.
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
public struct Observe<Value>: DynamicProperty {

    @ObservedObject var observation: ObservableStorageObject

    let binding: Bind<Value>

    public var context: Context {
        binding.context
    }

    public var wrappedValue: Value {
        get {
            binding.wrappedValue            
        }
    }

    /// One way binding to ``AtomicState`` value
    public init<A: AtomicState>(
        _ container: A.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where A.Value == Value
    {
        let binding = Bind(container, storage: storage, file: file, fileID: fileID, line: line, column: column, function: function)
        self.observation = binding.observation
        self.binding = binding
    }
    
    public init<WrappedContainer: ComputedAtom>(
        _ computation: WrappedContainer.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let binding = Bind(computation, storage: storage, file: file, fileID: fileID, line: line, column: column, function: function)
        observation = binding.observation
        self.binding = binding
    }

    public init<WrappedContainer: GroupState>(
        _ group: WrappedContainer.Type,
        storage: Storage? = nil,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let binding = Bind(group, storage: storage, file: file, fileID: fileID, line: line, column: column, function: function)
        observation = binding.observation
        self.binding = binding
    }

}


#endif
