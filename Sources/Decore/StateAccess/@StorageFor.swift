//  
//  @Storage.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Provides a **read-only** access to the storage assigned to a given type.
///
/// **Usage:**
/// ```swift
/// @StorageFor(Self.self) var storage
/// ```
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
@propertyWrapper
public struct StorageFor<T>: DynamicProperty {

    public var wrappedValue: Storage {
        get { Warehouse.storage(for: holder) }
    }

    var holder: T.Type

    init(_ holder: T.Type) {
        self.holder = holder
    }
}
#endif
