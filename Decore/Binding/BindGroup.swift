//
//  BindGroup.swift
//  Decore
//
//  Created by Maxim Bazarov on 15.02.22.
//

import SwiftUI

@propertyWrapper
public struct BindGroup<ID, Value, State: GroupState<ID,Value>>: DynamicProperty, StorageBinding {

    public var storage: Storage {
        get { accessor.storage }
        set { accessor.storage = newValue }
    }

    @ObservedObject var observation: ObservableStorageObject
    internal var accessor: Accessor

    @Environment(\.storage) var environmentStorage

    public init(
        _ state: State,
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        let observation = ObservableStorageObject()
        self.observation = observation
        let context = Context(
            key: nil,
            observationID: nil, // doesn't exist yet
            file: file,
            fileID: fileID,
            line: line,
            column: column,
            function: function)

        self.accessor = Accessor(
            read: { storage, id in
                state.read(from: storage, at: id, context: context, observation: observation)
            },
            write: { storage, newValue, id in
                state.write(newValue: newValue, into: storage, at: id, context: context)
            },
            insertObservation: { storage, id in
                storage.insertObservation(observation, for: state.key(for: id), context: context)
            }
        )
        self.accessor.storage = environmentStorage
    }

    public var wrappedValue: Accessor {
        get { accessor }
        mutating set { accessor = newValue }
    }

    public var projectedValue: Binding<Accessor> {
        Binding (
            get: { accessor },
            set: { _ in }
        )
    }

}


extension BindGroup {
    public class Accessor {

        private var _storage: Storage!

        var storage: Storage {
            get { _storage }
            set { _storage = newValue }
        }

        var read: (Storage, ID) -> Value
        var write: (Storage, Value, ID) -> Void
        var insertObservation: (Storage, ID) -> Void

        internal init(
            read: @escaping (Storage, ID) -> Value,
            write: @escaping (Storage, Value, ID) -> Void,
            insertObservation: @escaping (Storage, ID) -> Void
        ) {
            self.read = read
            self.write = write
            self.insertObservation = insertObservation
        }


        public subscript(_ id: ID) -> Value {
            get {
                insertObservation(storage, id)
                return read(storage, id)
            }
            set {
                write(storage, newValue, id)
            }
        }
    }
}
