//
//  Storage+Attach.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


import Foundation
import SwiftUI


/// Unlike atomic states group states store multiple values of the same type,
/// accessed by ``ID``
public class GroupState<ID: Hashable, Value> {

    var value: (ID) -> Value
    var persistValue: Bool

    func read(from storage: Storage, at id: ID, context: Context, observation: StorageObservation) -> Value {
        storage.insertObservation(observation, for: key(for: id), context: context)
        return storage.readValue(
            at: key(for: id),
            readerContext: context,
            fallbackValue: { value(id) },
            persistFallbackValue: persistValue
        )
    }

    func write(newValue: Value, into storage: Storage, at id: ID, context: Context) {
        storage.write(
            value: newValue,
            atKey: key(for: id),
            context: context
        )
    }

    func key(for id: ID) -> Storage.Key {
        .groupItem(
            String(describing: self.self),
            id: id
        )
    }

    public init(value: @escaping (ID) -> Value, persistValue: Bool = true) {
        self.value = value
        self.persistValue = persistValue
    }

}

public class GroupOperator<ID, Value> {

}


class ImageDownloader: GroupOperator<Int, String> {

}


protocol StorageBinding {
    var storage: Storage { get set }
}

private struct StorageKey: EnvironmentKey {
    static let defaultValue = Storage()
}

extension EnvironmentValues {
    var storage: Storage {
        get { self[StorageKey.self] }
        set { self[StorageKey.self] = newValue }
    }
}

public extension Storage {

    //    func attach<T: GroupOperator>(_ operator: T.Type) {
    ////        let observer = observerType.init()
    ////        observers[observerType.key] = observer
    //
    //    }


    internal static func allBindings(in operatorGroup: Any) -> [StorageBinding] {
        let operatorMirror = Mirror(reflecting: operatorGroup)
        return operatorMirror.children.compactMap { $0.value as? StorageBinding }



    }

}
