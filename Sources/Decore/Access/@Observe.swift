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

    public init<WrappedContainer: Container>(
        _ container: WrappedContainer.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let binding = Bind(container, file: file, fileID: fileID, line: line, column: column, function: function)
        observation = binding.observation
        self.binding = binding
    }

    public init<WrappedContainer: Computation>(
        _ computation: WrappedContainer.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let binding = Bind(computation, file: file, fileID: fileID, line: line, column: column, function: function)
        observation = binding.observation
        self.binding = binding
    }

    public init<WrappedContainer: GroupContainer>(
        _ group: WrappedContainer.Type,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    )
    where WrappedContainer.Value == Value
    {
        let binding = Bind(group,file: file, fileID: fileID, line: line, column: column, function: function)
        observation = binding.observation
        self.binding = binding
    }

}


#endif
